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
import 'queue_entry_status.dart' as _i2;

/// A visitor's entry in a queue counter.
/// Position is computed server-side on every read; never stored or trusted from the client.
abstract class QueueEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = QueueEntryTable();

  static const db = QueueEntryRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static QueueEntryInclude include() {
    return QueueEntryInclude._();
  }

  static QueueEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<QueueEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<QueueEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<QueueEntryTable>? orderByList,
    QueueEntryInclude? include,
  }) {
    return QueueEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QueueEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(QueueEntry.t),
      include: include,
    );
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

class QueueEntryUpdateTable extends _i1.UpdateTable<QueueEntryTable> {
  QueueEntryUpdateTable(super.table);

  _i1.ColumnValue<int, int> counterId(int value) => _i1.ColumnValue(
    table.counterId,
    value,
  );

  _i1.ColumnValue<String, String> visitorName(String value) => _i1.ColumnValue(
    table.visitorName,
    value,
  );

  _i1.ColumnValue<String, String> phone(String? value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> joinedAt(DateTime value) =>
      _i1.ColumnValue(
        table.joinedAt,
        value,
      );

  _i1.ColumnValue<_i2.QueueEntryStatus, _i2.QueueEntryStatus> status(
    _i2.QueueEntryStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> calledAt(DateTime? value) =>
      _i1.ColumnValue(
        table.calledAt,
        value,
      );

  _i1.ColumnValue<int, int> position(int value) => _i1.ColumnValue(
    table.position,
    value,
  );

  _i1.ColumnValue<String, String> ownerToken(String value) => _i1.ColumnValue(
    table.ownerToken,
    value,
  );
}

class QueueEntryTable extends _i1.Table<int?> {
  QueueEntryTable({super.tableRelation}) : super(tableName: 'queue_entries') {
    updateTable = QueueEntryUpdateTable(this);
    counterId = _i1.ColumnInt(
      'counterId',
      this,
    );
    visitorName = _i1.ColumnString(
      'visitorName',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    joinedAt = _i1.ColumnDateTime(
      'joinedAt',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
    calledAt = _i1.ColumnDateTime(
      'calledAt',
      this,
    );
    position = _i1.ColumnInt(
      'position',
      this,
      hasDefault: true,
    );
    ownerToken = _i1.ColumnString(
      'ownerToken',
      this,
    );
  }

  late final QueueEntryUpdateTable updateTable;

  /// Foreign key to the counter this entry belongs to.
  late final _i1.ColumnInt counterId;

  /// Visitor's display name (trimmed, 1-80 characters).
  late final _i1.ColumnString visitorName;

  /// Optional phone number (validated format if provided).
  late final _i1.ColumnString phone;

  /// Server-assigned join timestamp, used for position ordering.
  late final _i1.ColumnDateTime joinedAt;

  /// Typed status enum - never a raw String.
  late final _i1.ColumnEnum<_i2.QueueEntryStatus> status;

  /// Set when status transitions to called.
  late final _i1.ColumnDateTime calledAt;

  /// Computed 1-based rank among waiting entries, ordered by joinedAt.
  /// Populated by the endpoint on reads, NOT stored as a persistent DB column.
  late final _i1.ColumnInt position;

  /// Per-session ownership token returned at join time.
  /// Required to call leaveQueue - prevents visitor A from cancelling visitor B's spot.
  late final _i1.ColumnString ownerToken;

  @override
  List<_i1.Column> get columns => [
    id,
    counterId,
    visitorName,
    phone,
    joinedAt,
    status,
    calledAt,
    position,
    ownerToken,
  ];
}

class QueueEntryInclude extends _i1.IncludeObject {
  QueueEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => QueueEntry.t;
}

class QueueEntryIncludeList extends _i1.IncludeList {
  QueueEntryIncludeList._({
    _i1.WhereExpressionBuilder<QueueEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(QueueEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => QueueEntry.t;
}

class QueueEntryRepository {
  const QueueEntryRepository._();

  /// Returns a list of [QueueEntry]s matching the given query parameters.
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
  Future<List<QueueEntry>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<QueueEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<QueueEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<QueueEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<QueueEntry>(
      where: where?.call(QueueEntry.t),
      orderBy: orderBy?.call(QueueEntry.t),
      orderByList: orderByList?.call(QueueEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [QueueEntry] matching the given query parameters.
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
  Future<QueueEntry?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<QueueEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<QueueEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<QueueEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<QueueEntry>(
      where: where?.call(QueueEntry.t),
      orderBy: orderBy?.call(QueueEntry.t),
      orderByList: orderByList?.call(QueueEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [QueueEntry] by its [id] or null if no such row exists.
  Future<QueueEntry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<QueueEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [QueueEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [QueueEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<QueueEntry>> insert(
    _i1.DatabaseSession session,
    List<QueueEntry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<QueueEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [QueueEntry] and returns the inserted row.
  ///
  /// The returned [QueueEntry] will have its `id` field set.
  Future<QueueEntry> insertRow(
    _i1.DatabaseSession session,
    QueueEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<QueueEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [QueueEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<QueueEntry>> update(
    _i1.DatabaseSession session,
    List<QueueEntry> rows, {
    _i1.ColumnSelections<QueueEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<QueueEntry>(
      rows,
      columns: columns?.call(QueueEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QueueEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<QueueEntry> updateRow(
    _i1.DatabaseSession session,
    QueueEntry row, {
    _i1.ColumnSelections<QueueEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<QueueEntry>(
      row,
      columns: columns?.call(QueueEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QueueEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<QueueEntry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<QueueEntryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<QueueEntry>(
      id,
      columnValues: columnValues(QueueEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [QueueEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<QueueEntry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<QueueEntryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<QueueEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<QueueEntryTable>? orderBy,
    _i1.OrderByListBuilder<QueueEntryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<QueueEntry>(
      columnValues: columnValues(QueueEntry.t.updateTable),
      where: where(QueueEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QueueEntry.t),
      orderByList: orderByList?.call(QueueEntry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [QueueEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<QueueEntry>> delete(
    _i1.DatabaseSession session,
    List<QueueEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<QueueEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [QueueEntry].
  Future<QueueEntry> deleteRow(
    _i1.DatabaseSession session,
    QueueEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<QueueEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<QueueEntry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<QueueEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<QueueEntry>(
      where: where(QueueEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<QueueEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<QueueEntry>(
      where: where?.call(QueueEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [QueueEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<QueueEntryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<QueueEntry>(
      where: where(QueueEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
