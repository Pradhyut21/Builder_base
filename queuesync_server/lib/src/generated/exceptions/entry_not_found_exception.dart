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

import 'package:serverpod/serverpod.dart' as _i1;

/// Thrown when a requested entry or counter ID does not exist in the database.
abstract class EntryNotFoundException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  EntryNotFoundException._({
    required this.entityType,
    required this.id,
    required this.message,
  });

  factory EntryNotFoundException({
    required String entityType,
    required int id,
    required String message,
  }) = _EntryNotFoundExceptionImpl;

  factory EntryNotFoundException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EntryNotFoundException(
      entityType: jsonSerialization['entityType'] as String,
      id: jsonSerialization['id'] as int,
      message: jsonSerialization['message'] as String,
    );
  }

  String entityType;

  int id;

  String message;

  /// Returns a shallow copy of this [EntryNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EntryNotFoundException copyWith({
    String? entityType,
    int? id,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EntryNotFoundException',
      'entityType': entityType,
      'id': id,
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EntryNotFoundException',
      'entityType': entityType,
      'id': id,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'EntryNotFoundException(entityType: $entityType, id: $id, message: $message)';
  }
}

class _EntryNotFoundExceptionImpl extends EntryNotFoundException {
  _EntryNotFoundExceptionImpl({
    required String entityType,
    required int id,
    required String message,
  }) : super._(
         entityType: entityType,
         id: id,
         message: message,
       );

  /// Returns a shallow copy of this [EntryNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EntryNotFoundException copyWith({
    String? entityType,
    int? id,
    String? message,
  }) {
    return EntryNotFoundException(
      entityType: entityType ?? this.entityType,
      id: id ?? this.id,
      message: message ?? this.message,
    );
  }
}
