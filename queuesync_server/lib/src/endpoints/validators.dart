import '../generated/protocol.dart';

/// Server-side input validation utilities.
///
/// All validation is done server-side because client-side validation
/// is not a security control — it's a UX convenience only.
class Validators {
  /// Validates and trims a visitor name.
  /// Throws [ValidationException] if empty after trim or > 80 chars.
  static String validateName(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw ValidationException(
        field: 'visitorName',
        message: 'Name must not be empty.',
      );
    }
    if (trimmed.length > 80) {
      throw ValidationException(
        field: 'visitorName',
        message: 'Name must be 80 characters or fewer.',
      );
    }
    return trimmed;
  }

  /// Validates an optional phone number.
  /// Allows digits, spaces, dashes, parentheses, and a leading +.
  /// Rejects anything else with a typed [ValidationException].
  static String? validatePhone(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final trimmed = raw.trim();
    // Permissive but real pattern: allows international formats
    final phoneRegex = RegExp(r'^\+?[\d\s\-().]{7,20}$');
    if (!phoneRegex.hasMatch(trimmed)) {
      throw ValidationException(
        field: 'phone',
        message:
            'Phone number format is invalid. Use digits, spaces, dashes, or parentheses.',
      );
    }
    return trimmed;
  }

  /// Validates a counter ID — must be a positive integer.
  /// Throws [ValidationException] if not.
  static void validatePositiveId(int id, String fieldName) {
    if (id <= 0) {
      throw ValidationException(
        field: fieldName,
        message: '$fieldName must be a positive integer.',
      );
    }
  }
}
