import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Shared authorization helpers used by StaffEndpoint.
///
/// Enforces two layers:
///   1. The caller is authenticated (Serverpod auth check).
///   2. The authenticated user is staff for the SPECIFIC counterId being acted on.
///
/// Both checks are required. Being authenticated as staff for Counter A does
/// NOT grant authorization to act on Counter B. This is tested in
/// test/staff_cross_counter_test.dart.
///
/// ### How we get the user's email in Serverpod 3.4
/// When using the email IDP, Serverpod stores the user's email as the
/// `userIdentifier` on [AuthenticationInfo]. We use this directly instead of
/// a separate user-info lookup, which saves a round-trip and avoids the old
/// `Users.findUserByUserId` API that was removed in the 3.x auth refactor.
class AuthHelper {
  /// Verifies the session is authenticated AND the user is staff for [counterId].
  ///
  /// Throws [UnauthorizedException] if either check fails.
  /// Returns the authenticated user identifier (email) on success.
  static Future<String> requireStaffForCounter(
    Session session,
    int counterId,
  ) async {
    // Layer 1: Authentication check.
    // session.authenticated is set by Serverpod from the JWT in the request.
    // It is null for unauthenticated requests — no session.auth needed.
    final authInfo = session.authenticated;
    if (authInfo == null) {
      session.log(
        'Unauthenticated access attempt on counterId=$counterId',
        level: LogLevel.warning,
      );
      throw UnauthorizedException(message: 'Authentication required.');
    }

    // Layer 2: Cross-counter authorization check.
    // userIdentifier is the email for the email IDP.
    // staff for Counter A must be rejected when acting on Counter B.
    final email = authInfo.userIdentifier;

    final staffUser = await StaffUser.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email) & t.counterId.equals(counterId),
    );

    if (staffUser == null) {
      session.log(
        'Authorization failure: user=$email '
        'attempted action on counterId=$counterId — not their counter',
        level: LogLevel.warning,
      );
      throw UnauthorizedException(
        message: 'You are not authorized to manage counter $counterId.',
      );
    }

    return email;
  }
}
