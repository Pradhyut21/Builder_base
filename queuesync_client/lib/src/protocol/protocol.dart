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
import 'counter.dart' as _i2;
import 'exceptions/counter_paused_exception.dart' as _i3;
import 'exceptions/entry_not_found_exception.dart' as _i4;
import 'exceptions/invalid_state_transition_exception.dart' as _i5;
import 'exceptions/unauthorized_exception.dart' as _i6;
import 'exceptions/validation_exception.dart' as _i7;
import 'greetings/greeting.dart' as _i8;
import 'queue_entry.dart' as _i9;
import 'queue_entry_status.dart' as _i10;
import 'queue_update_signal.dart' as _i11;
import 'staff_user.dart' as _i12;
import 'package:queuesync_client/src/protocol/queue_entry.dart' as _i13;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i14;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i15;
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
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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

    if (t == _i2.Counter) {
      return _i2.Counter.fromJson(data) as T;
    }
    if (t == _i3.CounterPausedException) {
      return _i3.CounterPausedException.fromJson(data) as T;
    }
    if (t == _i4.EntryNotFoundException) {
      return _i4.EntryNotFoundException.fromJson(data) as T;
    }
    if (t == _i5.InvalidStateTransitionException) {
      return _i5.InvalidStateTransitionException.fromJson(data) as T;
    }
    if (t == _i6.UnauthorizedException) {
      return _i6.UnauthorizedException.fromJson(data) as T;
    }
    if (t == _i7.ValidationException) {
      return _i7.ValidationException.fromJson(data) as T;
    }
    if (t == _i8.Greeting) {
      return _i8.Greeting.fromJson(data) as T;
    }
    if (t == _i9.QueueEntry) {
      return _i9.QueueEntry.fromJson(data) as T;
    }
    if (t == _i10.QueueEntryStatus) {
      return _i10.QueueEntryStatus.fromJson(data) as T;
    }
    if (t == _i11.QueueUpdateSignal) {
      return _i11.QueueUpdateSignal.fromJson(data) as T;
    }
    if (t == _i12.StaffUser) {
      return _i12.StaffUser.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Counter?>()) {
      return (data != null ? _i2.Counter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CounterPausedException?>()) {
      return (data != null ? _i3.CounterPausedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.EntryNotFoundException?>()) {
      return (data != null ? _i4.EntryNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.InvalidStateTransitionException?>()) {
      return (data != null
              ? _i5.InvalidStateTransitionException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i6.UnauthorizedException?>()) {
      return (data != null ? _i6.UnauthorizedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.ValidationException?>()) {
      return (data != null ? _i7.ValidationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.Greeting?>()) {
      return (data != null ? _i8.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.QueueEntry?>()) {
      return (data != null ? _i9.QueueEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.QueueEntryStatus?>()) {
      return (data != null ? _i10.QueueEntryStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.QueueUpdateSignal?>()) {
      return (data != null ? _i11.QueueUpdateSignal.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.StaffUser?>()) {
      return (data != null ? _i12.StaffUser.fromJson(data) : null) as T;
    }
    if (t == List<_i13.QueueEntry>) {
      return (data as List).map((e) => deserialize<_i13.QueueEntry>(e)).toList()
          as T;
    }
    try {
      return _i14.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i15.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Counter => 'Counter',
      _i3.CounterPausedException => 'CounterPausedException',
      _i4.EntryNotFoundException => 'EntryNotFoundException',
      _i5.InvalidStateTransitionException => 'InvalidStateTransitionException',
      _i6.UnauthorizedException => 'UnauthorizedException',
      _i7.ValidationException => 'ValidationException',
      _i8.Greeting => 'Greeting',
      _i9.QueueEntry => 'QueueEntry',
      _i10.QueueEntryStatus => 'QueueEntryStatus',
      _i11.QueueUpdateSignal => 'QueueUpdateSignal',
      _i12.StaffUser => 'StaffUser',
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
      case _i2.Counter():
        return 'Counter';
      case _i3.CounterPausedException():
        return 'CounterPausedException';
      case _i4.EntryNotFoundException():
        return 'EntryNotFoundException';
      case _i5.InvalidStateTransitionException():
        return 'InvalidStateTransitionException';
      case _i6.UnauthorizedException():
        return 'UnauthorizedException';
      case _i7.ValidationException():
        return 'ValidationException';
      case _i8.Greeting():
        return 'Greeting';
      case _i9.QueueEntry():
        return 'QueueEntry';
      case _i10.QueueEntryStatus():
        return 'QueueEntryStatus';
      case _i11.QueueUpdateSignal():
        return 'QueueUpdateSignal';
      case _i12.StaffUser():
        return 'StaffUser';
    }
    className = _i14.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i15.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    if (data is List<_i13.QueueEntry>) {
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
      return deserialize<_i2.Counter>(data['data']);
    }
    if (dataClassName == 'CounterPausedException') {
      return deserialize<_i3.CounterPausedException>(data['data']);
    }
    if (dataClassName == 'EntryNotFoundException') {
      return deserialize<_i4.EntryNotFoundException>(data['data']);
    }
    if (dataClassName == 'InvalidStateTransitionException') {
      return deserialize<_i5.InvalidStateTransitionException>(data['data']);
    }
    if (dataClassName == 'UnauthorizedException') {
      return deserialize<_i6.UnauthorizedException>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_i7.ValidationException>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i8.Greeting>(data['data']);
    }
    if (dataClassName == 'QueueEntry') {
      return deserialize<_i9.QueueEntry>(data['data']);
    }
    if (dataClassName == 'QueueEntryStatus') {
      return deserialize<_i10.QueueEntryStatus>(data['data']);
    }
    if (dataClassName == 'QueueUpdateSignal') {
      return deserialize<_i11.QueueUpdateSignal>(data['data']);
    }
    if (dataClassName == 'StaffUser') {
      return deserialize<_i12.StaffUser>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i14.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i15.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == 'List<QueueEntry>') {
      return deserialize<List<_i13.QueueEntry>>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

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
      return _i14.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i15.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
