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

/// Links a Serverpod auth user to a counter they manage.
/// Credentials are owned by Serverpod's auth module; this only stores
/// the counter-staff relationship.
abstract class StaffUser implements _i1.SerializableModel {
  StaffUser._({
    this.id,
    required this.counterId,
    required this.email,
  });

  factory StaffUser({
    int? id,
    required int counterId,
    required String email,
  }) = _StaffUserImpl;

  factory StaffUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffUser(
      id: jsonSerialization['id'] as int?,
      counterId: jsonSerialization['counterId'] as int,
      email: jsonSerialization['email'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Foreign key to the counter this staff member manages.
  int counterId;

  /// Email used for login - must match the auth provider's email.
  String email;

  /// Returns a shallow copy of this [StaffUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StaffUser copyWith({
    int? id,
    int? counterId,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffUser',
      if (id != null) 'id': id,
      'counterId': counterId,
      'email': email,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StaffUserImpl extends StaffUser {
  _StaffUserImpl({
    int? id,
    required int counterId,
    required String email,
  }) : super._(
         id: id,
         counterId: counterId,
         email: email,
       );

  /// Returns a shallow copy of this [StaffUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StaffUser copyWith({
    Object? id = _Undefined,
    int? counterId,
    String? email,
  }) {
    return StaffUser(
      id: id is int? ? id : this.id,
      counterId: counterId ?? this.counterId,
      email: email ?? this.email,
    );
  }
}
