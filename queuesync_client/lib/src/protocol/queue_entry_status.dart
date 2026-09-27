/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Status of a visitor's queue entry.
/// Using a typed enum prevents invalid states and untyped comparisons.
/// A raw String status field allows invalid states — this enum does not.
enum QueueEntryStatus implements _i1.SerializableModel {
  waiting,
  called,
  served,
  expired,
  left;

  static QueueEntryStatus fromJson(String name) {
    switch (name) {
      case 'waiting':
        return QueueEntryStatus.waiting;
      case 'called':
        return QueueEntryStatus.called;
      case 'served':
        return QueueEntryStatus.served;
      case 'expired':
        return QueueEntryStatus.expired;
      case 'left':
        return QueueEntryStatus.left;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "QueueEntryStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
