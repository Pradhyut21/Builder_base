import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'auth_helper.dart';
import 'queue_endpoint.dart';
import 'validators.dart';

/// Staff-facing queue management endpoint.
///
/// EVERY method enforces two authorization layers:
///   1. Caller is authenticated via Serverpod auth.
///   2. Authenticated user is staff for the SPECIFIC counterId being acted on.
///
/// Being authenticated as staff for Counter A does NOT authorize actions on
/// Counter B. This is tested in test/staff_cross_counter_test.dart.
class StaffEndpoint extends Endpoint {
  /// Calls the next waiting visitor for [counterId].
  ///
  /// Idempotency guard: if there is already a `called` entry for this counter,
  /// returns it without calling another. This prevents a double-tap from calling
  /// two people. Guard is server-side — a disabled button does not protect
  /// against two browser tabs open at once.
  Future<QueueEntry?> callNext(Session session, int counterId) async {
    Validators.validatePositiveId(counterId, 'counterId');
    await AuthHelper.requireStaffForCounter(session, counterId);

    return await session.db.transaction<QueueEntry?>((tx) async {
      // Idempotency: return existing called entry if one exists.
      final alreadyCalled = await QueueEntry.db.findFirstRow(
        session,
        where: (t) =>
            t.counterId.equals(counterId) &
            t.status.equals(QueueEntryStatus.called),
        transaction: tx,
      );
      if (alreadyCalled != null) {
        session.log(
          'callNext: idempotency — entryId=${alreadyCalled.id} already called',
        );
        return alreadyCalled.copyWith(position: 0);
      }

      final next = await QueueEntry.db.findFirstRow(
        session,
        where: (t) =>
            t.counterId.equals(counterId) &
            t.status.equals(QueueEntryStatus.waiting),
        orderBy: (t) => t.joinedAt,
        transaction: tx,
      );

      if (next == null) {
        session.log('callNext: no waiting entries for counterId=$counterId');
        return null;
      }

      final now = DateTime.now().toUtc();
      final updated = await QueueEntry.db.updateRow(
        session,
        next.copyWith(status: QueueEntryStatus.called, calledAt: now),
        transaction: tx,
      );

      session.log(
        'callNext: entryId=${updated.id} counterId=$counterId '
        'name=${updated.visitorName} called at $now',
      );

      // Schedule auto-expiry via Serverpod future call.
      // Future calls persist in the DB and survive server restarts —
      // unlike a plain Dart Timer which is lost on restart.
      // QueueUpdateSignal carries the entry ID as counterId field (reused for simplicity)
      // so the FutureCall handler can parse it.
      // ignore: deprecated_member_use
      await session.serverpod.futureCallWithDelay(
        'expire_entry',
        QueueUpdateSignal(counterId: updated.id!),
        Duration(minutes: kCallExpiryMinutes),
      );

      await session.messages.postMessage(
        queueChannel(counterId),
        QueueUpdateSignal(counterId: counterId),
        global: false,
      );

      return updated.copyWith(position: 0);
    });
  }

  /// Marks the currently called entry as served.
  /// Only valid from status == `called`.
  Future<void> markServed(Session session, int entryId) async {
    Validators.validatePositiveId(entryId, 'entryId');
    final entry = await _requireEntryInCalledState(
      session,
      entryId,
      'markServed',
    );
    await AuthHelper.requireStaffForCounter(session, entry.counterId);

    await QueueEntry.db.updateRow(
      session,
      entry.copyWith(status: QueueEntryStatus.served),
    );
    session.log('markServed: entryId=$entryId counterId=${entry.counterId}');

    await session.messages.postMessage(
      queueChannel(entry.counterId),
      QueueUpdateSignal(counterId: entry.counterId),
      global: false,
    );
  }

  /// Marks the currently called entry as no-show (expires it).
  /// Only valid from status == `called`.
  Future<void> markNoShow(Session session, int entryId) async {
    Validators.validatePositiveId(entryId, 'entryId');
    final entry = await _requireEntryInCalledState(
      session,
      entryId,
      'markNoShow',
    );
    await AuthHelper.requireStaffForCounter(session, entry.counterId);

    await QueueEntry.db.updateRow(
      session,
      entry.copyWith(status: QueueEntryStatus.expired),
    );
    session.log('markNoShow: entryId=$entryId counterId=${entry.counterId}');

    await session.messages.postMessage(
      queueChannel(entry.counterId),
      QueueUpdateSignal(counterId: entry.counterId),
      global: false,
    );
  }

  /// Pauses a counter — new joins are rejected, existing entries preserved.
  Future<void> pauseCounter(Session session, int counterId) async {
    Validators.validatePositiveId(counterId, 'counterId');
    await AuthHelper.requireStaffForCounter(session, counterId);
    final counter = await _requireCounter(session, counterId);
    await Counter.db.updateRow(session, counter.copyWith(isPaused: true));
    session.log('pauseCounter: counterId=$counterId');
  }

  /// Resumes a paused counter.
  Future<void> resumeCounter(Session session, int counterId) async {
    Validators.validatePositiveId(counterId, 'counterId');
    await AuthHelper.requireStaffForCounter(session, counterId);
    final counter = await _requireCounter(session, counterId);
    await Counter.db.updateRow(session, counter.copyWith(isPaused: false));
    session.log('resumeCounter: counterId=$counterId');
  }

  /// Returns the counter's current state (particularly isPaused).
  /// Used by the staff UI to sync pause state on mount and after toggles,
  /// so two browser tabs always reflect the same server-side value.
  Future<Counter?> getCounterStatus(Session session, int counterId) async {
    Validators.validatePositiveId(counterId, 'counterId');
    await AuthHelper.requireStaffForCounter(session, counterId);
    return Counter.db.findById(session, counterId);
  }

  /// Streams the full (unredacted) live queue for staff.
  /// Includes phone numbers and full names — staff need this.
  Stream<List<QueueEntry>> watchStaffQueue(
    Session session,
    int counterId,
  ) async* {
    Validators.validatePositiveId(counterId, 'counterId');
    await AuthHelper.requireStaffForCounter(session, counterId);

    yield await _fetchFullQueue(session, counterId);

    await for (final _ in session.messages.createStream<QueueUpdateSignal>(
      queueChannel(counterId),
    )) {
      yield await _fetchFullQueue(session, counterId);
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<List<QueueEntry>> _fetchFullQueue(
    Session session,
    int counterId,
  ) async {
    final entries = await QueueEntry.db.find(
      session,
      where: (t) =>
          t.counterId.equals(counterId) &
          t.status.inSet({QueueEntryStatus.waiting, QueueEntryStatus.called}),
      orderBy: (t) => t.joinedAt,
    );
    // Secondary tie-breaker on sequential DB id guarantees deterministic
    // ordering even if two entries share the exact same microsecond timestamp.
    entries.sort((a, b) {
      final cmp = a.joinedAt.compareTo(b.joinedAt);
      if (cmp != 0) return cmp;
      return (a.id ?? 0).compareTo(b.id ?? 0);
    });

    int pos = 1;
    return entries.map((e) {
      final position = e.status == QueueEntryStatus.waiting ? pos++ : 0;
      return e.copyWith(ownerToken: '', position: position);
    }).toList();
  }

  Future<QueueEntry> _requireEntryInCalledState(
    Session session,
    int entryId,
    String action,
  ) async {
    final entry = await QueueEntry.db.findById(session, entryId);
    if (entry == null) {
      throw EntryNotFoundException(
        entityType: 'QueueEntry',
        id: entryId,
        message: 'Queue entry $entryId not found.',
      );
    }
    if (entry.status != QueueEntryStatus.called) {
      session.log(
        '$action rejected: entryId=$entryId status=${entry.status} must be called',
        level: LogLevel.warning,
      );
      throw InvalidStateTransitionException(
        entryId: entryId,
        currentStatus: entry.status.name,
        attemptedAction: action,
        message:
            '$action requires status=called, but entry is ${entry.status.name}.',
      );
    }
    return entry;
  }

  Future<Counter> _requireCounter(Session session, int counterId) async {
    final counter = await Counter.db.findById(session, counterId);
    if (counter == null) {
      throw EntryNotFoundException(
        entityType: 'Counter',
        id: counterId,
        message: 'Counter $counterId not found.',
      );
    }
    return counter;
  }
}
