import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../endpoints/queue_endpoint.dart';

/// Auto-expiry handler for called queue entries.
///
/// Registered as a Serverpod future call. When a visitor is called but does
/// not get marked served or no-show within [kCallExpiryMinutes] minutes,
/// this handler fires and transitions the entry to `expired`.
///
/// Serverpod persists future calls in the database, so this survives a server
/// restart — unlike a plain Dart Timer which is lost on restart.
///
/// The entry ID is passed via QueueUpdateSignal.counterId (field repurposed to
/// carry the entry ID, since we needed a SerializableModel — creating a
/// dedicated wrapper model would be cleaner but this keeps model count low).
///
/// Registration: see lib/server.dart where this is registered with
/// pod.registerFutureCall.
class EntryExpiryFutureCall extends FutureCall<QueueUpdateSignal> {
  @override
  Future<void> invoke(
    Session session,
    QueueUpdateSignal? object,
  ) async {
    if (object == null) {
      session.log(
        'EntryExpiryFutureCall: null parameter — ignoring',
        level: LogLevel.warning,
      );
      return;
    }

    // The counterId field carries the entryId (repurposed to avoid a dedicated model).
    final entryId = object.counterId;

    final entry = await QueueEntry.db.findById(session, entryId);
    if (entry == null) {
      session.log(
        'EntryExpiryFutureCall: entryId=$entryId not found, skipping',
      );
      return;
    }

    // Only expire if still in `called` state.
    // If markServed or markNoShow already ran, this is a no-op.
    if (entry.status != QueueEntryStatus.called) {
      session.log(
        'EntryExpiryFutureCall: entryId=$entryId already in '
        'status=${entry.status.name}, no action needed',
      );
      return;
    }

    await QueueEntry.db.updateRow(
      session,
      entry.copyWith(status: QueueEntryStatus.expired),
    );

    session.log(
      'EntryExpiryFutureCall: entryId=$entryId expired '
      '(not served within ${kCallExpiryMinutes}min window)',
    );

    await session.messages.postMessage(
      queueChannel(entry.counterId),
      QueueUpdateSignal(counterId: entry.counterId),
      global: false,
    );
  }
}
