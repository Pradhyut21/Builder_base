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

/// Represents a virtual queue counter (e.g., "Clinic Counter A").
abstract class Counter implements _i1.SerializableModel {
  Counter._({
    this.id,
    required this.name,
    bool? isPaused,
    required this.createdAt,
  }) : isPaused = isPaused ?? false;

  factory Counter({
    int? id,
    required String name,
    bool? isPaused,
    required DateTime createdAt,
  }) = _CounterImpl;

  factory Counter.fromJson(Map<String, dynamic> jsonSerialization) {
    return Counter(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      isPaused: jsonSerialization['isPaused'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isPaused']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Human-readable name of the counter (1–80 characters).
  String name;

  /// When true, new joinQueue calls are rejected; existing entries are preserved.
  bool isPaused;

  /// Server-assigned creation timestamp.
  DateTime createdAt;

  /// Returns a shallow copy of this [Counter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Counter copyWith({
    int? id,
    String? name,
    bool? isPaused,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Counter',
      if (id != null) 'id': id,
      'name': name,
      'isPaused': isPaused,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CounterImpl extends Counter {
  _CounterImpl({
    int? id,
    required String name,
    bool? isPaused,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         isPaused: isPaused,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Counter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Counter copyWith({
    Object? id = _Undefined,
    String? name,
    bool? isPaused,
    DateTime? createdAt,
  }) {
    return Counter(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      isPaused: isPaused ?? this.isPaused,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
