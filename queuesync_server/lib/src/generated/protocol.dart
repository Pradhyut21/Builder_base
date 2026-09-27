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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'counter.dart' as _i5;
import 'exceptions/counter_paused_exception.dart' as _i6;
import 'exceptions/entry_not_found_exception.dart' as _i7;
import 'exceptions/invalid_state_transition_exception.dart' as _i8;
import 'exceptions/unauthorized_exception.dart' as _i9;
import 'exceptions/validation_exception.dart' as _i10;
import 'greetings/greeting.dart' as _i11;
import 'queue_entry.dart' as _i12;
import 'queue_entry_status.dart' as _i13;
import 'queue_update_signal.dart' as _i14;
import 'staff_user.dart' as _i15;
import 'package:queuesync_server/src/generated/queue_entry.dart' as _i16;
export 'counter.dart';
export 'exceptions/counter_paused_exception.dart';
export 'exceptions/entry_not_found_exception.dart';
export 'exceptions/invalid_state_transition_exception.dart';
export 'exceptions/unauthorized_exception.dart';
export 'exceptions/validation_exception.dart';
export 'greetings/greeting.dart';
export 'queue_entry.dart';
export 'queue_entry_status.dart';
export 'queue_update_signal.dart';
export 'staff_user.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'counters',
      dartName: 'Counter',
      schema: 'public',
      module: 'queuesync',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'counters_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'isPaused',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'counters_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'counters_name_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'name',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'queue_entries',
      dartName: 'QueueEntry',
      schema: 'public',
      module: 'queuesync',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'queue_entries_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'counterId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'visitorName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'phone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'joinedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:QueueEntryStatus',
        ),
        _i2.ColumnDefinition(
          name: 'calledAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'position',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: r"'-1'::integer",
        ),
        _i2.ColumnDefinition(
          name: 'ownerToken',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'queue_entries_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'queue_entries_counter_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'counterId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'queue_entries_counter_status_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'counterId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'queue_entries_joined_at_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'counterId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'joinedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'staff_users',
      dartName: 'StaffUser',
      schema: 'public',
      module: 'queuesync',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'staff_users_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'counterId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'staff_users_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'staff_users_counter_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'counterId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'staff_users_email_counter_unique',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'counterId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.Counter) {
      return _i5.Counter.fromJson(data) as T;
    }
    if (t == _i6.CounterPausedException) {
      return _i6.CounterPausedException.fromJson(data) as T;
    }
    if (t == _i7.EntryNotFoundException) {
      return _i7.EntryNotFoundException.fromJson(data) as T;
    }
    if (t == _i8.InvalidStateTransitionException) {
      return _i8.InvalidStateTransitionException.fromJson(data) as T;
    }
    if (t == _i9.UnauthorizedException) {
      return _i9.UnauthorizedException.fromJson(data) as T;
    }
    if (t == _i10.ValidationException) {
      return _i10.ValidationException.fromJson(data) as T;
    }
    if (t == _i11.Greeting) {
      return _i11.Greeting.fromJson(data) as T;
    }
    if (t == _i12.QueueEntry) {
      return _i12.QueueEntry.fromJson(data) as T;
    }
    if (t == _i13.QueueEntryStatus) {
      return _i13.QueueEntryStatus.fromJson(data) as T;
    }
    if (t == _i14.QueueUpdateSignal) {
      return _i14.QueueUpdateSignal.fromJson(data) as T;
    }
    if (t == _i15.StaffUser) {
      return _i15.StaffUser.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Counter?>()) {
      return (data != null ? _i5.Counter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CounterPausedException?>()) {
      return (data != null ? _i6.CounterPausedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.EntryNotFoundException?>()) {
      return (data != null ? _i7.EntryNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.InvalidStateTransitionException?>()) {
      return (data != null
              ? _i8.InvalidStateTransitionException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i9.UnauthorizedException?>()) {
      return (data != null ? _i9.UnauthorizedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.ValidationException?>()) {
      return (data != null ? _i10.ValidationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.Greeting?>()) {
      return (data != null ? _i11.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.QueueEntry?>()) {
      return (data != null ? _i12.QueueEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.QueueEntryStatus?>()) {
      return (data != null ? _i13.QueueEntryStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.QueueUpdateSignal?>()) {
      return (data != null ? _i14.QueueUpdateSignal.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.StaffUser?>()) {
      return (data != null ? _i15.StaffUser.fromJson(data) : null) as T;
    }
    if (t == List<_i16.QueueEntry>) {
      return (data as List).map((e) => deserialize<_i16.QueueEntry>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.Counter => 'Counter',
      _i6.CounterPausedException => 'CounterPausedException',
      _i7.EntryNotFoundException => 'EntryNotFoundException',
      _i8.InvalidStateTransitionException => 'InvalidStateTransitionException',
      _i9.UnauthorizedException => 'UnauthorizedException',
      _i10.ValidationException => 'ValidationException',
      _i11.Greeting => 'Greeting',
      _i12.QueueEntry => 'QueueEntry',
      _i13.QueueEntryStatus => 'QueueEntryStatus',
      _i14.QueueUpdateSignal => 'QueueUpdateSignal',
      _i15.StaffUser => 'StaffUser',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('queuesync.', '');
    }

    switch (data) {
      case _i5.Counter():
        return 'Counter';
      case _i6.CounterPausedException():
        return 'CounterPausedException';
      case _i7.EntryNotFoundException():
        return 'EntryNotFoundException';
      case _i8.InvalidStateTransitionException():
        return 'InvalidStateTransitionException';
      case _i9.UnauthorizedException():
        return 'UnauthorizedException';
      case _i10.ValidationException():
        return 'ValidationException';
      case _i11.Greeting():
        return 'Greeting';
      case _i12.QueueEntry():
        return 'QueueEntry';
      case _i13.QueueEntryStatus():
        return 'QueueEntryStatus';
      case _i14.QueueUpdateSignal():
        return 'QueueUpdateSignal';
      case _i15.StaffUser():
        return 'StaffUser';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    if (data is List<_i16.QueueEntry>) {
      return 'List<QueueEntry>';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Counter') {
      return deserialize<_i5.Counter>(data['data']);
    }
    if (dataClassName == 'CounterPausedException') {
      return deserialize<_i6.CounterPausedException>(data['data']);
    }
    if (dataClassName == 'EntryNotFoundException') {
      return deserialize<_i7.EntryNotFoundException>(data['data']);
    }
    if (dataClassName == 'InvalidStateTransitionException') {
      return deserialize<_i8.InvalidStateTransitionException>(data['data']);
    }
    if (dataClassName == 'UnauthorizedException') {
      return deserialize<_i9.UnauthorizedException>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_i10.ValidationException>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i11.Greeting>(data['data']);
    }
    if (dataClassName == 'QueueEntry') {
      return deserialize<_i12.QueueEntry>(data['data']);
    }
    if (dataClassName == 'QueueEntryStatus') {
      return deserialize<_i13.QueueEntryStatus>(data['data']);
    }
    if (dataClassName == 'QueueUpdateSignal') {
      return deserialize<_i14.QueueUpdateSignal>(data['data']);
    }
    if (dataClassName == 'StaffUser') {
      return deserialize<_i15.StaffUser>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == 'List<QueueEntry>') {
      return deserialize<List<_i16.QueueEntry>>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i5.Counter:
        return _i5.Counter.t;
      case _i12.QueueEntry:
        return _i12.QueueEntry.t;
      case _i15.StaffUser:
        return _i15.StaffUser.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'queuesync';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
