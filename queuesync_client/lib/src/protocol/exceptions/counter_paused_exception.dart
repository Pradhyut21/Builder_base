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

/// Thrown when a visitor attempts to join a paused counter.
abstract class CounterPausedException
    implements _i1.SerializableException, _i1.SerializableModel {
  CounterPausedException._({
    required this.counterId,
    required this.message,
  });

  factory CounterPausedException({
    required int counterId,
    required String message,
  }) = _CounterPausedExceptionImpl;

  factory CounterPausedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CounterPausedException(
      counterId: jsonSerialization['counterId'] as int,
      message: jsonSerialization['message'] as String,
    );
  }

  int counterId;

  String message;

  /// Returns a shallow copy of this [CounterPausedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CounterPausedException copyWith({
    int? counterId,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CounterPausedException',
      'counterId': counterId,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'CounterPausedException(counterId: $counterId, message: $message)';
  }
}

class _CounterPausedExceptionImpl extends CounterPausedException {
  _CounterPausedExceptionImpl({
    required int counterId,
    required String message,
  }) : super._(
         counterId: counterId,
         message: message,
       );

  /// Returns a shallow copy of this [CounterPausedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CounterPausedException copyWith({
    int? counterId,
    String? message,
  }) {
    return CounterPausedException(
      counterId: counterId ?? this.counterId,
      message: message ?? this.message,
    );
  }
}
