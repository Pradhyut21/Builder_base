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
import 'queue_entry_status.dart' as _i2;

/// A visitor's entry in a queue counter.
/// Position is computed server-side on every read; never stored or trusted from the client.
abstract class QueueEntry implements _i1.SerializableModel {
  QueueEntry._({
    this.id,
    required this.counterId,
    required this.visitorName,
    this.phone,
    required this.joinedAt,
    required this.status,
    this.calledAt,
    int? position,
    required this.ownerToken,
  }) : position = position ?? -1;

  factory QueueEntry({
    int? id,
    required int counterId,
    required String visitorName,
    String? phone,
    required DateTime joinedAt,
    required _i2.QueueEntryStatus status,
    DateTime? calledAt,
    int? position,
    required String ownerToken,
  }) = _QueueEntryImpl;

  factory QueueEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueueEntry(
      id: jsonSerialization['id'] as int?,
      counterId: jsonSerialization['counterId'] as int,
      visitorName: jsonSerialization['visitorName'] as String,
      phone: jsonSerialization['phone'] as String?,
      joinedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinedAt'],
      ),
      status: _i2.QueueEntryStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      calledAt: jsonSerialization['calledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['calledAt']),
      position: jsonSerialization['position'] as int?,
      ownerToken: jsonSerialization['ownerToken'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Foreign key to the counter this entry belongs to.
  int counterId;

  /// Visitor's display name (trimmed, 1-80 characters).
  String visitorName;

  /// Optional phone number (validated format if provided).
  String? phone;

  /// Server-assigned join timestamp, used for position ordering.
  DateTime joinedAt;

  /// Typed status enum - never a raw String.
  _i2.QueueEntryStatus status;

  /// Set when status transitions to called.
  DateTime? calledAt;

  /// Computed 1-based rank among waiting entries, ordered by joinedAt.
  /// Populated by the endpoint on reads, NOT stored as a persistent DB column.
  int position;

  /// Per-session ownership token returned at join time.
  /// Required to call leaveQueue - prevents visitor A from cancelling visitor B's spot.
  String ownerToken;

  /// Returns a shallow copy of this [QueueEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  QueueEntry copyWith({
    int? id,
    int? counterId,
    String? visitorName,
    String? phone,
    DateTime? joinedAt,
    _i2.QueueEntryStatus? status,
    DateTime? calledAt,
    int? position,
    String? ownerToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QueueEntry',
      if (id != null) 'id': id,
      'counterId': counterId,
      'visitorName': visitorName,
      if (phone != null) 'phone': phone,
      'joinedAt': joinedAt.toJson(),
      'status': status.toJson(),
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      'position': position,
      'ownerToken': ownerToken,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QueueEntryImpl extends QueueEntry {
  _QueueEntryImpl({
    int? id,
    required int counterId,
    required String visitorName,
    String? phone,
    required DateTime joinedAt,
    required _i2.QueueEntryStatus status,
    DateTime? calledAt,
    int? position,
    required String ownerToken,
  }) : super._(
         id: id,
         counterId: counterId,
         visitorName: visitorName,
         phone: phone,
         joinedAt: joinedAt,
         status: status,
         calledAt: calledAt,
         position: position,
         ownerToken: ownerToken,
       );

  /// Returns a shallow copy of this [QueueEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  QueueEntry copyWith({
    Object? id = _Undefined,
    int? counterId,
    String? visitorName,
    Object? phone = _Undefined,
    DateTime? joinedAt,
    _i2.QueueEntryStatus? status,
    Object? calledAt = _Undefined,
    int? position,
    String? ownerToken,
  }) {
    return QueueEntry(
      id: id is int? ? id : this.id,
      counterId: counterId ?? this.counterId,
      visitorName: visitorName ?? this.visitorName,
      phone: phone is String? ? phone : this.phone,
      joinedAt: joinedAt ?? this.joinedAt,
      status: status ?? this.status,
      calledAt: calledAt is DateTime? ? calledAt : this.calledAt,
      position: position ?? this.position,
      ownerToken: ownerToken ?? this.ownerToken,
    );
  }
}
