/// Staff cross-counter authorization test.
///
/// The spec explicitly requires: "staff member for Counter A calling an action
/// on Counter B must be rejected with an authorization exception."
///
/// This test verifies that the two-layer auth check in AuthHelper works:
///   1. Authenticated ✓
///   2. Staff for the SPECIFIC counter being acted on ✓
library;

import 'package:test/test.dart';
import 'package:queuesync_server/src/generated/protocol.dart';
import 'integration/test_tools/serverpod_test_tools.dart';

/// Integration tests for cross-counter staff authorization.
///
/// These run against a real test database (configured in config/test.yaml).
/// See README.md for how to run these locally.
void main() {
  withServerpod('StaffEndpoint cross-counter authorization', (
    sessionBuilder,
    endpoints,
  ) {
    late int counterAId;
    late int counterBId;

    // In serverpod_test 3.4, the test tools methods take a TestSessionBuilder
    // with authentication configured inline — not a pre-built Session object.
    // The TestSessionBuilder with auth override is created per test or shared below.
    late TestSessionBuilder staffABuilder;
    late TestSessionBuilder staffBBuilder;

    setUp(() async {
      final session = sessionBuilder.build();

      // Create two counters.
      final counterA = await Counter.db.insertRow(
        session,
        Counter(
          name: 'Counter A',
          isPaused: false,
          createdAt: DateTime.now().toUtc(),
        ),
      );
      final counterB = await Counter.db.insertRow(
        session,
        Counter(
          name: 'Counter B',
          isPaused: false,
          createdAt: DateTime.now().toUtc(),
        ),
      );
      counterAId = counterA.id!;
      counterBId = counterB.id!;

      // Create staff for Counter A.
      await StaffUser.db.insertRow(
        session,
        StaffUser(
          counterId: counterAId,
          email: 'staff_a@queuesync.test',
        ),
      );

      // Create staff for Counter B.
      await StaffUser.db.insertRow(
        session,
        StaffUser(
          counterId: counterBId,
          email: 'staff_b@queuesync.test',
        ),
      );

      // Build authenticated session builders for each staff member.
      // In Serverpod 3.4, AuthenticationOverride.authenticationInfo takes
      // a String userIdentifier (the email for the email IDP) not an int.
      staffABuilder = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          'staff_a@queuesync.test',
          {},
        ),
      );

      staffBBuilder = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          'staff_b@queuesync.test',
          {},
        ),
      );
    });

    test(
      'Staff A can pause Counter A',
      () async {
        // Should succeed without throwing.
        await expectLater(
          endpoints.staff.pauseCounter(staffABuilder, counterAId),
          completes,
        );
      },
    );

    test(
      'Staff A is REJECTED when acting on Counter B (cross-counter auth)',
      () async {
        // This is the key security test from the spec.
        // Being authenticated as staff for Counter A must NOT grant access
        // to Counter B actions.
        await expectLater(
          endpoints.staff.pauseCounter(staffABuilder, counterBId),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );

    test(
      'Staff B is REJECTED when acting on Counter A (cross-counter auth)',
      () async {
        await expectLater(
          endpoints.staff.callNext(staffBBuilder, counterAId),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );

    test(
      'Unauthenticated caller is rejected on staff endpoint',
      () async {
        await expectLater(
          endpoints.staff.callNext(sessionBuilder, counterAId),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );

    test(
      'markServed from waiting state throws InvalidStateTransitionException',
      () async {
        // Insert a waiting entry.
        final session = sessionBuilder.build();
        final entry = await QueueEntry.db.insertRow(
          session,
          QueueEntry(
            counterId: counterAId,
            visitorName: 'Test Visitor',
            phone: null,
            joinedAt: DateTime.now().toUtc(),
            status: QueueEntryStatus.waiting,
            calledAt: null,
            position: 1,
            ownerToken: 'test_token',
          ),
        );

        // markServed from `waiting` must throw — not silently succeed.
        await expectLater(
          endpoints.staff.markServed(staffABuilder, entry.id!),
          throwsA(isA<InvalidStateTransitionException>()),
        );
      },
    );
  });
}
