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

/// Thrown when a state transition is attempted from an invalid source state.
/// e.g., markServed from `waiting` or from a terminal state.
abstract class InvalidStateTransitionException
    implements _i1.SerializableException, _i1.SerializableModel {
  InvalidStateTransitionException._({
    required this.entryId,
    required this.currentStatus,
    required this.attemptedAction,
    required this.message,
  });

  factory InvalidStateTransitionException({
    required int entryId,
    required String currentStatus,
    required String attemptedAction,
    required String message,
  }) = _InvalidStateTransitionExceptionImpl;

  factory InvalidStateTransitionException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return InvalidStateTransitionException(
      entryId: jsonSerialization['entryId'] as int,
      currentStatus: jsonSerialization['currentStatus'] as String,
      attemptedAction: jsonSerialization['attemptedAction'] as String,
      message: jsonSerialization['message'] as String,
    );
  }

  int entryId;

  String currentStatus;

  String attemptedAction;

  String message;

  /// Returns a shallow copy of this [InvalidStateTransitionException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InvalidStateTransitionException copyWith({
    int? entryId,
    String? currentStatus,
    String? attemptedAction,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvalidStateTransitionException',
      'entryId': entryId,
      'currentStatus': currentStatus,
      'attemptedAction': attemptedAction,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'InvalidStateTransitionException(entryId: $entryId, currentStatus: $currentStatus, attemptedAction: $attemptedAction, message: $message)';
  }
}

class _InvalidStateTransitionExceptionImpl
    extends InvalidStateTransitionException {
  _InvalidStateTransitionExceptionImpl({
    required int entryId,
    required String currentStatus,
    required String attemptedAction,
    required String message,
  }) : super._(
         entryId: entryId,
         currentStatus: currentStatus,
         attemptedAction: attemptedAction,
         message: message,
       );

  /// Returns a shallow copy of this [InvalidStateTransitionException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InvalidStateTransitionException copyWith({
    int? entryId,
    String? currentStatus,
    String? attemptedAction,
    String? message,
  }) {
    return InvalidStateTransitionException(
      entryId: entryId ?? this.entryId,
      currentStatus: currentStatus ?? this.currentStatus,
      attemptedAction: attemptedAction ?? this.attemptedAction,
      message: message ?? this.message,
    );
  }
}
