/// Concurrent queue join tests.
///
/// The specification explicitly requires testing concurrent visitor joins:
/// "Two visitors can join simultaneously — they always get distinct positions (no collisions)."
///
/// This test verifies that:
/// 1. Concurrent joinQueue calls on the same counter execute safely with row-level locks.
/// 2. All visitors receive unique IDs and distinct, deterministic position numbers.
/// 3. No position collision occurs under simultaneous joins.
///
/// IMPORTANT: rollbackDatabase is set to `disabled` below. Serverpod's default
/// (`RollbackDatabase.afterEach`) wraps each test in one shared top-level
/// transaction so it can be rolled back afterward — but concurrent calls to
/// session.db.transaction (which is exactly what joinQueue does, called 5x
/// via Future.wait) cannot nest inside that wrapper and throw
/// InvalidConfigurationException under the default setting. Disabling it is
/// required to actually exercise concurrent, independently-connected
/// transactions racing for the same row lock — which is the entire point of
/// this test. See: https://docs.serverpod.dev/concepts/testing/configuration
///
/// Because rollback is disabled, nothing automatically cleans up after this
/// test group — tearDown below deletes everything it created so state
/// doesn't leak into other test files.
library;

import 'package:test/test.dart';
import 'package:queuesync_server/src/generated/protocol.dart';
import 'integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'QueueEndpoint concurrent joins',
    (sessionBuilder, endpoints) {
      late int counterId;

      setUp(() async {
        final session = sessionBuilder.build();

        // Create a test counter.
        final counter = await Counter.db.insertRow(
          session,
          Counter(
            name: 'Concurrent Test Counter',
            isPaused: false,
            createdAt: DateTime.now().toUtc(),
          ),
        );
        counterId = counter.id!;
      });

      tearDown(() async {
        // Manual cleanup — rollbackDatabase.disabled means nothing else
        // will remove these rows.
        final session = sessionBuilder.build();
        await QueueEntry.db.deleteWhere(
          session,
          where: (t) => t.counterId.equals(counterId),
        );
        await Counter.db.deleteWhere(
          session,
          where: (t) => t.id.equals(counterId),
        );
      });

      test(
        'Simultaneous concurrent joins produce distinct IDs and unique positions',
        () async {
          const joinCount = 5;

          // Launch concurrent joins simultaneously using Future.wait. With
          // rollbackDatabase.disabled, each joinQueue call's session.db.
          // transaction runs as a genuinely independent transaction, so this
          // actually exercises the FOR UPDATE row lock racing across
          // separate connections — not just interleaved async code sharing
          // one connection.
          final results = await Future.wait(
            List.generate(
              joinCount,
              (index) => endpoints.queue.joinQueue(
                sessionBuilder,
                counterId,
                'Visitor $index',
                null,
              ),
            ),
          );

          // 1. All joins succeeded.
          expect(results.length, equals(joinCount));

          // 2. All entries have distinct IDs.
          final ids = results.map((e) => e.id!).toSet();
          expect(ids.length, equals(joinCount));

          // 3. All entries have distinct positions (1 through joinCount).
          final positions = results.map((e) => e.position).toList()..sort();
          expect(positions, equals([1, 2, 3, 4, 5]));

          // 4. All have valid unique owner tokens.
          final tokens = results.map((e) => e.ownerToken).toSet();
          expect(tokens.length, equals(joinCount));

          // 5. Database contains exactly joinCount waiting entries for this counter.
          final session = sessionBuilder.build();
          final dbEntries = await QueueEntry.db.find(
            session,
            where: (t) => t.counterId.equals(counterId),
          );
          expect(dbEntries.length, equals(joinCount));
        },
      );

      test(
        'Concurrent joins are rejected when counter is paused',
        () async {
          final session = sessionBuilder.build();
          final counter = await Counter.db.findById(session, counterId);
          await Counter.db.updateRow(
            session,
            counter!.copyWith(isPaused: true),
          );

          // Attempt concurrent joins on paused counter.
          final futures = List.generate(
            3,
            (i) => endpoints.queue.joinQueue(
              sessionBuilder,
              counterId,
              'Visitor Paused $i',
              null,
            ),
          );

          for (final future in futures) {
            await expectLater(
              future,
              throwsA(isA<CounterPausedException>()),
            );
          }
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
