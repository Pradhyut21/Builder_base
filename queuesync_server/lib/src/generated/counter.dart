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

/// Represents a virtual queue counter (e.g., "Clinic Counter A").
abstract class Counter
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = CounterTable();

  static const db = CounterRepository._();

  @override
  int? id;

  /// Human-readable name of the counter (1–80 characters).
  String name;

  /// When true, new joinQueue calls are rejected; existing entries are preserved.
  bool isPaused;

  /// Server-assigned creation timestamp.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Counter',
      if (id != null) 'id': id,
      'name': name,
      'isPaused': isPaused,
      'createdAt': createdAt.toJson(),
    };
  }

  static CounterInclude include() {
    return CounterInclude._();
  }

  static CounterIncludeList includeList({
    _i1.WhereExpressionBuilder<CounterTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CounterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CounterTable>? orderByList,
    CounterInclude? include,
  }) {
    return CounterIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Counter.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Counter.t),
      include: include,
    );
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

class CounterUpdateTable extends _i1.UpdateTable<CounterTable> {
  CounterUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<bool, bool> isPaused(bool value) => _i1.ColumnValue(
    table.isPaused,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class CounterTable extends _i1.Table<int?> {
  CounterTable({super.tableRelation}) : super(tableName: 'counters') {
    updateTable = CounterUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    isPaused = _i1.ColumnBool(
      'isPaused',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final CounterUpdateTable updateTable;

  /// Human-readable name of the counter (1–80 characters).
  late final _i1.ColumnString name;

  /// When true, new joinQueue calls are rejected; existing entries are preserved.
  late final _i1.ColumnBool isPaused;

  /// Server-assigned creation timestamp.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    isPaused,
    createdAt,
  ];
}

class CounterInclude extends _i1.IncludeObject {
  CounterInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Counter.t;
}

class CounterIncludeList extends _i1.IncludeList {
  CounterIncludeList._({
    _i1.WhereExpressionBuilder<CounterTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Counter.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Counter.t;
}

class CounterRepository {
  const CounterRepository._();

  /// Returns a list of [Counter]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Counter>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CounterTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CounterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CounterTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Counter>(
      where: where?.call(Counter.t),
      orderBy: orderBy?.call(Counter.t),
      orderByList: orderByList?.call(Counter.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Counter] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Counter?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CounterTable>? where,
    int? offset,
    _i1.OrderByBuilder<CounterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CounterTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Counter>(
      where: where?.call(Counter.t),
      orderBy: orderBy?.call(Counter.t),
      orderByList: orderByList?.call(Counter.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Counter] by its [id] or null if no such row exists.
  Future<Counter?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Counter>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Counter]s in the list and returns the inserted rows.
  ///
  /// The returned [Counter]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Counter>> insert(
    _i1.DatabaseSession session,
    List<Counter> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Counter>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Counter] and returns the inserted row.
  ///
  /// The returned [Counter] will have its `id` field set.
  Future<Counter> insertRow(
    _i1.DatabaseSession session,
    Counter row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Counter>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Counter]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Counter>> update(
    _i1.DatabaseSession session,
    List<Counter> rows, {
    _i1.ColumnSelections<CounterTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Counter>(
      rows,
      columns: columns?.call(Counter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Counter]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Counter> updateRow(
    _i1.DatabaseSession session,
    Counter row, {
    _i1.ColumnSelections<CounterTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Counter>(
      row,
      columns: columns?.call(Counter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Counter] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Counter?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CounterUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Counter>(
      id,
      columnValues: columnValues(Counter.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Counter]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Counter>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CounterUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CounterTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CounterTable>? orderBy,
    _i1.OrderByListBuilder<CounterTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Counter>(
      columnValues: columnValues(Counter.t.updateTable),
      where: where(Counter.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Counter.t),
      orderByList: orderByList?.call(Counter.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Counter]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Counter>> delete(
    _i1.DatabaseSession session,
    List<Counter> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Counter>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Counter].
  Future<Counter> deleteRow(
    _i1.DatabaseSession session,
    Counter row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Counter>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Counter>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CounterTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Counter>(
      where: where(Counter.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CounterTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Counter>(
      where: where?.call(Counter.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Counter] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CounterTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Counter>(
      where: where(Counter.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
