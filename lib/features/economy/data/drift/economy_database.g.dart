// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'economy_database.dart';

// ignore_for_file: type=lint
class $CoinTransactionRowsTable extends CoinTransactionRows
    with TableInfo<$CoinTransactionRowsTable, CoinTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoinTransactionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    check: () => ComparableExpr(amount).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motifIdMeta = const VerificationMeta(
    'motifId',
  );
  @override
  late final GeneratedColumn<String> motifId = GeneratedColumn<String>(
    'motif_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtUtcMsMeta = const VerificationMeta(
    'occurredAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> occurredAtUtcMs = GeneratedColumn<int>(
    'occurred_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idempotencyKey,
    type,
    amount,
    motifId,
    occurredAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coin_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoinTransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('motif_id')) {
      context.handle(
        _motifIdMeta,
        motifId.isAcceptableOrUnknown(data['motif_id']!, _motifIdMeta),
      );
    }
    if (data.containsKey('occurred_at_utc_ms')) {
      context.handle(
        _occurredAtUtcMsMeta,
        occurredAtUtcMs.isAcceptableOrUnknown(
          data['occurred_at_utc_ms']!,
          _occurredAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurredAtUtcMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoinTransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoinTransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      motifId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motif_id'],
      ),
      occurredAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at_utc_ms'],
      )!,
    );
  }

  @override
  $CoinTransactionRowsTable createAlias(String alias) {
    return $CoinTransactionRowsTable(attachedDatabase, alias);
  }
}

class CoinTransactionRow extends DataClass
    implements Insertable<CoinTransactionRow> {
  final int id;

  /// べき等性の真実(T7)。事前チェックではなくこのUNIQUE違反の捕捉が正。
  final String idempotencyKey;

  /// 'earn' | 'spend_unlock'。下の customConstraints で値域もCHECK。
  final String type;

  /// CHECK(amount > 0): 0円・負額トランザクションはDB層でも構築不可能。
  final int amount;

  /// spend_unlock のときのみ非NULL(earnはNULL)。整合はテーブルCHECKで強制。
  final String? motifId;
  final int occurredAtUtcMs;
  const CoinTransactionRow({
    required this.id,
    required this.idempotencyKey,
    required this.type,
    required this.amount,
    this.motifId,
    required this.occurredAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || motifId != null) {
      map['motif_id'] = Variable<String>(motifId);
    }
    map['occurred_at_utc_ms'] = Variable<int>(occurredAtUtcMs);
    return map;
  }

  CoinTransactionRowsCompanion toCompanion(bool nullToAbsent) {
    return CoinTransactionRowsCompanion(
      id: Value(id),
      idempotencyKey: Value(idempotencyKey),
      type: Value(type),
      amount: Value(amount),
      motifId: motifId == null && nullToAbsent
          ? const Value.absent()
          : Value(motifId),
      occurredAtUtcMs: Value(occurredAtUtcMs),
    );
  }

  factory CoinTransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoinTransactionRow(
      id: serializer.fromJson<int>(json['id']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      motifId: serializer.fromJson<String?>(json['motifId']),
      occurredAtUtcMs: serializer.fromJson<int>(json['occurredAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'motifId': serializer.toJson<String?>(motifId),
      'occurredAtUtcMs': serializer.toJson<int>(occurredAtUtcMs),
    };
  }

  CoinTransactionRow copyWith({
    int? id,
    String? idempotencyKey,
    String? type,
    int? amount,
    Value<String?> motifId = const Value.absent(),
    int? occurredAtUtcMs,
  }) => CoinTransactionRow(
    id: id ?? this.id,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    motifId: motifId.present ? motifId.value : this.motifId,
    occurredAtUtcMs: occurredAtUtcMs ?? this.occurredAtUtcMs,
  );
  CoinTransactionRow copyWithCompanion(CoinTransactionRowsCompanion data) {
    return CoinTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      motifId: data.motifId.present ? data.motifId.value : this.motifId,
      occurredAtUtcMs: data.occurredAtUtcMs.present
          ? data.occurredAtUtcMs.value
          : this.occurredAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoinTransactionRow(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('motifId: $motifId, ')
          ..write('occurredAtUtcMs: $occurredAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idempotencyKey, type, amount, motifId, occurredAtUtcMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoinTransactionRow &&
          other.id == this.id &&
          other.idempotencyKey == this.idempotencyKey &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.motifId == this.motifId &&
          other.occurredAtUtcMs == this.occurredAtUtcMs);
}

class CoinTransactionRowsCompanion extends UpdateCompanion<CoinTransactionRow> {
  final Value<int> id;
  final Value<String> idempotencyKey;
  final Value<String> type;
  final Value<int> amount;
  final Value<String?> motifId;
  final Value<int> occurredAtUtcMs;
  const CoinTransactionRowsCompanion({
    this.id = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.motifId = const Value.absent(),
    this.occurredAtUtcMs = const Value.absent(),
  });
  CoinTransactionRowsCompanion.insert({
    this.id = const Value.absent(),
    required String idempotencyKey,
    required String type,
    required int amount,
    this.motifId = const Value.absent(),
    required int occurredAtUtcMs,
  }) : idempotencyKey = Value(idempotencyKey),
       type = Value(type),
       amount = Value(amount),
       occurredAtUtcMs = Value(occurredAtUtcMs);
  static Insertable<CoinTransactionRow> custom({
    Expression<int>? id,
    Expression<String>? idempotencyKey,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? motifId,
    Expression<int>? occurredAtUtcMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (motifId != null) 'motif_id': motifId,
      if (occurredAtUtcMs != null) 'occurred_at_utc_ms': occurredAtUtcMs,
    });
  }

  CoinTransactionRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? idempotencyKey,
    Value<String>? type,
    Value<int>? amount,
    Value<String?>? motifId,
    Value<int>? occurredAtUtcMs,
  }) {
    return CoinTransactionRowsCompanion(
      id: id ?? this.id,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      motifId: motifId ?? this.motifId,
      occurredAtUtcMs: occurredAtUtcMs ?? this.occurredAtUtcMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (motifId.present) {
      map['motif_id'] = Variable<String>(motifId.value);
    }
    if (occurredAtUtcMs.present) {
      map['occurred_at_utc_ms'] = Variable<int>(occurredAtUtcMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoinTransactionRowsCompanion(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('motifId: $motifId, ')
          ..write('occurredAtUtcMs: $occurredAtUtcMs')
          ..write(')'))
        .toString();
  }
}

class $WalletSnapshotRowsTable extends WalletSnapshotRows
    with TableInfo<$WalletSnapshotRowsTable, WalletSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletSnapshotRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    check: () => id.equals(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<int> balance = GeneratedColumn<int>(
    'balance',
    aliasedName,
    false,
    check: () => ComparableExpr(balance).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, balance];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_snapshot';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletSnapshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletSnapshotRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance'],
      )!,
    );
  }

  @override
  $WalletSnapshotRowsTable createAlias(String alias) {
    return $WalletSnapshotRowsTable(attachedDatabase, alias);
  }
}

class WalletSnapshotRow extends DataClass
    implements Insertable<WalletSnapshotRow> {
  /// 単一行規約: CHECK(id = 1) で2行目の存在をDB層で禁止。
  final int id;
  final int balance;
  const WalletSnapshotRow({required this.id, required this.balance});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['balance'] = Variable<int>(balance);
    return map;
  }

  WalletSnapshotRowsCompanion toCompanion(bool nullToAbsent) {
    return WalletSnapshotRowsCompanion(id: Value(id), balance: Value(balance));
  }

  factory WalletSnapshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletSnapshotRow(
      id: serializer.fromJson<int>(json['id']),
      balance: serializer.fromJson<int>(json['balance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'balance': serializer.toJson<int>(balance),
    };
  }

  WalletSnapshotRow copyWith({int? id, int? balance}) =>
      WalletSnapshotRow(id: id ?? this.id, balance: balance ?? this.balance);
  WalletSnapshotRow copyWithCompanion(WalletSnapshotRowsCompanion data) {
    return WalletSnapshotRow(
      id: data.id.present ? data.id.value : this.id,
      balance: data.balance.present ? data.balance.value : this.balance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletSnapshotRow(')
          ..write('id: $id, ')
          ..write('balance: $balance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, balance);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletSnapshotRow &&
          other.id == this.id &&
          other.balance == this.balance);
}

class WalletSnapshotRowsCompanion extends UpdateCompanion<WalletSnapshotRow> {
  final Value<int> id;
  final Value<int> balance;
  const WalletSnapshotRowsCompanion({
    this.id = const Value.absent(),
    this.balance = const Value.absent(),
  });
  WalletSnapshotRowsCompanion.insert({
    this.id = const Value.absent(),
    required int balance,
  }) : balance = Value(balance);
  static Insertable<WalletSnapshotRow> custom({
    Expression<int>? id,
    Expression<int>? balance,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (balance != null) 'balance': balance,
    });
  }

  WalletSnapshotRowsCompanion copyWith({Value<int>? id, Value<int>? balance}) {
    return WalletSnapshotRowsCompanion(
      id: id ?? this.id,
      balance: balance ?? this.balance,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (balance.present) {
      map['balance'] = Variable<int>(balance.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletSnapshotRowsCompanion(')
          ..write('id: $id, ')
          ..write('balance: $balance')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsRowsTable extends UserSettingsRows
    with TableInfo<$UserSettingsRowsTable, UserSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    check: () => id.equals(1),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedMotifIdMeta = const VerificationMeta(
    'selectedMotifId',
  );
  @override
  late final GeneratedColumn<String> selectedMotifId = GeneratedColumn<String>(
    'selected_motif_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultSessionDurationMsMeta =
      const VerificationMeta('defaultSessionDurationMs');
  @override
  late final GeneratedColumn<int> defaultSessionDurationMs =
      GeneratedColumn<int>(
        'default_session_duration_ms',
        aliasedName,
        false,
        check: () =>
            ComparableExpr(defaultSessionDurationMs).isBiggerThanValue(0),
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _bgmEnabledMeta = const VerificationMeta(
    'bgmEnabled',
  );
  @override
  late final GeneratedColumn<bool> bgmEnabled = GeneratedColumn<bool>(
    'bgm_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bgm_enabled" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    selectedMotifId,
    defaultSessionDurationMs,
    bgmEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('selected_motif_id')) {
      context.handle(
        _selectedMotifIdMeta,
        selectedMotifId.isAcceptableOrUnknown(
          data['selected_motif_id']!,
          _selectedMotifIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedMotifIdMeta);
    }
    if (data.containsKey('default_session_duration_ms')) {
      context.handle(
        _defaultSessionDurationMsMeta,
        defaultSessionDurationMs.isAcceptableOrUnknown(
          data['default_session_duration_ms']!,
          _defaultSessionDurationMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultSessionDurationMsMeta);
    }
    if (data.containsKey('bgm_enabled')) {
      context.handle(
        _bgmEnabledMeta,
        bgmEnabled.isAcceptableOrUnknown(data['bgm_enabled']!, _bgmEnabledMeta),
      );
    } else if (isInserting) {
      context.missing(_bgmEnabledMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      selectedMotifId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_motif_id'],
      )!,
      defaultSessionDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_session_duration_ms'],
      )!,
      bgmEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bgm_enabled'],
      )!,
    );
  }

  @override
  $UserSettingsRowsTable createAlias(String alias) {
    return $UserSettingsRowsTable(attachedDatabase, alias);
  }
}

class UserSettingsRow extends DataClass implements Insertable<UserSettingsRow> {
  final int id;
  final String selectedMotifId;

  /// Duration はミリ秒intで永続化(§7: 時刻・期間はUTCエポックms/ms単位)。
  final int defaultSessionDurationMs;
  final bool bgmEnabled;
  const UserSettingsRow({
    required this.id,
    required this.selectedMotifId,
    required this.defaultSessionDurationMs,
    required this.bgmEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['selected_motif_id'] = Variable<String>(selectedMotifId);
    map['default_session_duration_ms'] = Variable<int>(
      defaultSessionDurationMs,
    );
    map['bgm_enabled'] = Variable<bool>(bgmEnabled);
    return map;
  }

  UserSettingsRowsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsRowsCompanion(
      id: Value(id),
      selectedMotifId: Value(selectedMotifId),
      defaultSessionDurationMs: Value(defaultSessionDurationMs),
      bgmEnabled: Value(bgmEnabled),
    );
  }

  factory UserSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      selectedMotifId: serializer.fromJson<String>(json['selectedMotifId']),
      defaultSessionDurationMs: serializer.fromJson<int>(
        json['defaultSessionDurationMs'],
      ),
      bgmEnabled: serializer.fromJson<bool>(json['bgmEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'selectedMotifId': serializer.toJson<String>(selectedMotifId),
      'defaultSessionDurationMs': serializer.toJson<int>(
        defaultSessionDurationMs,
      ),
      'bgmEnabled': serializer.toJson<bool>(bgmEnabled),
    };
  }

  UserSettingsRow copyWith({
    int? id,
    String? selectedMotifId,
    int? defaultSessionDurationMs,
    bool? bgmEnabled,
  }) => UserSettingsRow(
    id: id ?? this.id,
    selectedMotifId: selectedMotifId ?? this.selectedMotifId,
    defaultSessionDurationMs:
        defaultSessionDurationMs ?? this.defaultSessionDurationMs,
    bgmEnabled: bgmEnabled ?? this.bgmEnabled,
  );
  UserSettingsRow copyWithCompanion(UserSettingsRowsCompanion data) {
    return UserSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      selectedMotifId: data.selectedMotifId.present
          ? data.selectedMotifId.value
          : this.selectedMotifId,
      defaultSessionDurationMs: data.defaultSessionDurationMs.present
          ? data.defaultSessionDurationMs.value
          : this.defaultSessionDurationMs,
      bgmEnabled: data.bgmEnabled.present
          ? data.bgmEnabled.value
          : this.bgmEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsRow(')
          ..write('id: $id, ')
          ..write('selectedMotifId: $selectedMotifId, ')
          ..write('defaultSessionDurationMs: $defaultSessionDurationMs, ')
          ..write('bgmEnabled: $bgmEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, selectedMotifId, defaultSessionDurationMs, bgmEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsRow &&
          other.id == this.id &&
          other.selectedMotifId == this.selectedMotifId &&
          other.defaultSessionDurationMs == this.defaultSessionDurationMs &&
          other.bgmEnabled == this.bgmEnabled);
}

class UserSettingsRowsCompanion extends UpdateCompanion<UserSettingsRow> {
  final Value<int> id;
  final Value<String> selectedMotifId;
  final Value<int> defaultSessionDurationMs;
  final Value<bool> bgmEnabled;
  const UserSettingsRowsCompanion({
    this.id = const Value.absent(),
    this.selectedMotifId = const Value.absent(),
    this.defaultSessionDurationMs = const Value.absent(),
    this.bgmEnabled = const Value.absent(),
  });
  UserSettingsRowsCompanion.insert({
    this.id = const Value.absent(),
    required String selectedMotifId,
    required int defaultSessionDurationMs,
    required bool bgmEnabled,
  }) : selectedMotifId = Value(selectedMotifId),
       defaultSessionDurationMs = Value(defaultSessionDurationMs),
       bgmEnabled = Value(bgmEnabled);
  static Insertable<UserSettingsRow> custom({
    Expression<int>? id,
    Expression<String>? selectedMotifId,
    Expression<int>? defaultSessionDurationMs,
    Expression<bool>? bgmEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (selectedMotifId != null) 'selected_motif_id': selectedMotifId,
      if (defaultSessionDurationMs != null)
        'default_session_duration_ms': defaultSessionDurationMs,
      if (bgmEnabled != null) 'bgm_enabled': bgmEnabled,
    });
  }

  UserSettingsRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? selectedMotifId,
    Value<int>? defaultSessionDurationMs,
    Value<bool>? bgmEnabled,
  }) {
    return UserSettingsRowsCompanion(
      id: id ?? this.id,
      selectedMotifId: selectedMotifId ?? this.selectedMotifId,
      defaultSessionDurationMs:
          defaultSessionDurationMs ?? this.defaultSessionDurationMs,
      bgmEnabled: bgmEnabled ?? this.bgmEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (selectedMotifId.present) {
      map['selected_motif_id'] = Variable<String>(selectedMotifId.value);
    }
    if (defaultSessionDurationMs.present) {
      map['default_session_duration_ms'] = Variable<int>(
        defaultSessionDurationMs.value,
      );
    }
    if (bgmEnabled.present) {
      map['bgm_enabled'] = Variable<bool>(bgmEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsRowsCompanion(')
          ..write('id: $id, ')
          ..write('selectedMotifId: $selectedMotifId, ')
          ..write('defaultSessionDurationMs: $defaultSessionDurationMs, ')
          ..write('bgmEnabled: $bgmEnabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$EconomyDatabase extends GeneratedDatabase {
  _$EconomyDatabase(QueryExecutor e) : super(e);
  $EconomyDatabaseManager get managers => $EconomyDatabaseManager(this);
  late final $CoinTransactionRowsTable coinTransactionRows =
      $CoinTransactionRowsTable(this);
  late final $WalletSnapshotRowsTable walletSnapshotRows =
      $WalletSnapshotRowsTable(this);
  late final $UserSettingsRowsTable userSettingsRows = $UserSettingsRowsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    coinTransactionRows,
    walletSnapshotRows,
    userSettingsRows,
  ];
}

typedef $$CoinTransactionRowsTableCreateCompanionBuilder =
    CoinTransactionRowsCompanion Function({
      Value<int> id,
      required String idempotencyKey,
      required String type,
      required int amount,
      Value<String?> motifId,
      required int occurredAtUtcMs,
    });
typedef $$CoinTransactionRowsTableUpdateCompanionBuilder =
    CoinTransactionRowsCompanion Function({
      Value<int> id,
      Value<String> idempotencyKey,
      Value<String> type,
      Value<int> amount,
      Value<String?> motifId,
      Value<int> occurredAtUtcMs,
    });

class $$CoinTransactionRowsTableFilterComposer
    extends Composer<_$EconomyDatabase, $CoinTransactionRowsTable> {
  $$CoinTransactionRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motifId => $composableBuilder(
    column: $table.motifId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurredAtUtcMs => $composableBuilder(
    column: $table.occurredAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoinTransactionRowsTableOrderingComposer
    extends Composer<_$EconomyDatabase, $CoinTransactionRowsTable> {
  $$CoinTransactionRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motifId => $composableBuilder(
    column: $table.motifId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAtUtcMs => $composableBuilder(
    column: $table.occurredAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoinTransactionRowsTableAnnotationComposer
    extends Composer<_$EconomyDatabase, $CoinTransactionRowsTable> {
  $$CoinTransactionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get motifId =>
      $composableBuilder(column: $table.motifId, builder: (column) => column);

  GeneratedColumn<int> get occurredAtUtcMs => $composableBuilder(
    column: $table.occurredAtUtcMs,
    builder: (column) => column,
  );
}

class $$CoinTransactionRowsTableTableManager
    extends
        RootTableManager<
          _$EconomyDatabase,
          $CoinTransactionRowsTable,
          CoinTransactionRow,
          $$CoinTransactionRowsTableFilterComposer,
          $$CoinTransactionRowsTableOrderingComposer,
          $$CoinTransactionRowsTableAnnotationComposer,
          $$CoinTransactionRowsTableCreateCompanionBuilder,
          $$CoinTransactionRowsTableUpdateCompanionBuilder,
          (
            CoinTransactionRow,
            BaseReferences<
              _$EconomyDatabase,
              $CoinTransactionRowsTable,
              CoinTransactionRow
            >,
          ),
          CoinTransactionRow,
          PrefetchHooks Function()
        > {
  $$CoinTransactionRowsTableTableManager(
    _$EconomyDatabase db,
    $CoinTransactionRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoinTransactionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoinTransactionRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CoinTransactionRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> motifId = const Value.absent(),
                Value<int> occurredAtUtcMs = const Value.absent(),
              }) => CoinTransactionRowsCompanion(
                id: id,
                idempotencyKey: idempotencyKey,
                type: type,
                amount: amount,
                motifId: motifId,
                occurredAtUtcMs: occurredAtUtcMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String idempotencyKey,
                required String type,
                required int amount,
                Value<String?> motifId = const Value.absent(),
                required int occurredAtUtcMs,
              }) => CoinTransactionRowsCompanion.insert(
                id: id,
                idempotencyKey: idempotencyKey,
                type: type,
                amount: amount,
                motifId: motifId,
                occurredAtUtcMs: occurredAtUtcMs,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoinTransactionRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$EconomyDatabase,
      $CoinTransactionRowsTable,
      CoinTransactionRow,
      $$CoinTransactionRowsTableFilterComposer,
      $$CoinTransactionRowsTableOrderingComposer,
      $$CoinTransactionRowsTableAnnotationComposer,
      $$CoinTransactionRowsTableCreateCompanionBuilder,
      $$CoinTransactionRowsTableUpdateCompanionBuilder,
      (
        CoinTransactionRow,
        BaseReferences<
          _$EconomyDatabase,
          $CoinTransactionRowsTable,
          CoinTransactionRow
        >,
      ),
      CoinTransactionRow,
      PrefetchHooks Function()
    >;
typedef $$WalletSnapshotRowsTableCreateCompanionBuilder =
    WalletSnapshotRowsCompanion Function({Value<int> id, required int balance});
typedef $$WalletSnapshotRowsTableUpdateCompanionBuilder =
    WalletSnapshotRowsCompanion Function({Value<int> id, Value<int> balance});

class $$WalletSnapshotRowsTableFilterComposer
    extends Composer<_$EconomyDatabase, $WalletSnapshotRowsTable> {
  $$WalletSnapshotRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletSnapshotRowsTableOrderingComposer
    extends Composer<_$EconomyDatabase, $WalletSnapshotRowsTable> {
  $$WalletSnapshotRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletSnapshotRowsTableAnnotationComposer
    extends Composer<_$EconomyDatabase, $WalletSnapshotRowsTable> {
  $$WalletSnapshotRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);
}

class $$WalletSnapshotRowsTableTableManager
    extends
        RootTableManager<
          _$EconomyDatabase,
          $WalletSnapshotRowsTable,
          WalletSnapshotRow,
          $$WalletSnapshotRowsTableFilterComposer,
          $$WalletSnapshotRowsTableOrderingComposer,
          $$WalletSnapshotRowsTableAnnotationComposer,
          $$WalletSnapshotRowsTableCreateCompanionBuilder,
          $$WalletSnapshotRowsTableUpdateCompanionBuilder,
          (
            WalletSnapshotRow,
            BaseReferences<
              _$EconomyDatabase,
              $WalletSnapshotRowsTable,
              WalletSnapshotRow
            >,
          ),
          WalletSnapshotRow,
          PrefetchHooks Function()
        > {
  $$WalletSnapshotRowsTableTableManager(
    _$EconomyDatabase db,
    $WalletSnapshotRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletSnapshotRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletSnapshotRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletSnapshotRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> balance = const Value.absent(),
              }) => WalletSnapshotRowsCompanion(id: id, balance: balance),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required int balance}) =>
                  WalletSnapshotRowsCompanion.insert(id: id, balance: balance),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletSnapshotRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$EconomyDatabase,
      $WalletSnapshotRowsTable,
      WalletSnapshotRow,
      $$WalletSnapshotRowsTableFilterComposer,
      $$WalletSnapshotRowsTableOrderingComposer,
      $$WalletSnapshotRowsTableAnnotationComposer,
      $$WalletSnapshotRowsTableCreateCompanionBuilder,
      $$WalletSnapshotRowsTableUpdateCompanionBuilder,
      (
        WalletSnapshotRow,
        BaseReferences<
          _$EconomyDatabase,
          $WalletSnapshotRowsTable,
          WalletSnapshotRow
        >,
      ),
      WalletSnapshotRow,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsRowsTableCreateCompanionBuilder =
    UserSettingsRowsCompanion Function({
      Value<int> id,
      required String selectedMotifId,
      required int defaultSessionDurationMs,
      required bool bgmEnabled,
    });
typedef $$UserSettingsRowsTableUpdateCompanionBuilder =
    UserSettingsRowsCompanion Function({
      Value<int> id,
      Value<String> selectedMotifId,
      Value<int> defaultSessionDurationMs,
      Value<bool> bgmEnabled,
    });

class $$UserSettingsRowsTableFilterComposer
    extends Composer<_$EconomyDatabase, $UserSettingsRowsTable> {
  $$UserSettingsRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedMotifId => $composableBuilder(
    column: $table.selectedMotifId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultSessionDurationMs => $composableBuilder(
    column: $table.defaultSessionDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bgmEnabled => $composableBuilder(
    column: $table.bgmEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsRowsTableOrderingComposer
    extends Composer<_$EconomyDatabase, $UserSettingsRowsTable> {
  $$UserSettingsRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedMotifId => $composableBuilder(
    column: $table.selectedMotifId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultSessionDurationMs => $composableBuilder(
    column: $table.defaultSessionDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bgmEnabled => $composableBuilder(
    column: $table.bgmEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsRowsTableAnnotationComposer
    extends Composer<_$EconomyDatabase, $UserSettingsRowsTable> {
  $$UserSettingsRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get selectedMotifId => $composableBuilder(
    column: $table.selectedMotifId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultSessionDurationMs => $composableBuilder(
    column: $table.defaultSessionDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get bgmEnabled => $composableBuilder(
    column: $table.bgmEnabled,
    builder: (column) => column,
  );
}

class $$UserSettingsRowsTableTableManager
    extends
        RootTableManager<
          _$EconomyDatabase,
          $UserSettingsRowsTable,
          UserSettingsRow,
          $$UserSettingsRowsTableFilterComposer,
          $$UserSettingsRowsTableOrderingComposer,
          $$UserSettingsRowsTableAnnotationComposer,
          $$UserSettingsRowsTableCreateCompanionBuilder,
          $$UserSettingsRowsTableUpdateCompanionBuilder,
          (
            UserSettingsRow,
            BaseReferences<
              _$EconomyDatabase,
              $UserSettingsRowsTable,
              UserSettingsRow
            >,
          ),
          UserSettingsRow,
          PrefetchHooks Function()
        > {
  $$UserSettingsRowsTableTableManager(
    _$EconomyDatabase db,
    $UserSettingsRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> selectedMotifId = const Value.absent(),
                Value<int> defaultSessionDurationMs = const Value.absent(),
                Value<bool> bgmEnabled = const Value.absent(),
              }) => UserSettingsRowsCompanion(
                id: id,
                selectedMotifId: selectedMotifId,
                defaultSessionDurationMs: defaultSessionDurationMs,
                bgmEnabled: bgmEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String selectedMotifId,
                required int defaultSessionDurationMs,
                required bool bgmEnabled,
              }) => UserSettingsRowsCompanion.insert(
                id: id,
                selectedMotifId: selectedMotifId,
                defaultSessionDurationMs: defaultSessionDurationMs,
                bgmEnabled: bgmEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$EconomyDatabase,
      $UserSettingsRowsTable,
      UserSettingsRow,
      $$UserSettingsRowsTableFilterComposer,
      $$UserSettingsRowsTableOrderingComposer,
      $$UserSettingsRowsTableAnnotationComposer,
      $$UserSettingsRowsTableCreateCompanionBuilder,
      $$UserSettingsRowsTableUpdateCompanionBuilder,
      (
        UserSettingsRow,
        BaseReferences<
          _$EconomyDatabase,
          $UserSettingsRowsTable,
          UserSettingsRow
        >,
      ),
      UserSettingsRow,
      PrefetchHooks Function()
    >;

class $EconomyDatabaseManager {
  final _$EconomyDatabase _db;
  $EconomyDatabaseManager(this._db);
  $$CoinTransactionRowsTableTableManager get coinTransactionRows =>
      $$CoinTransactionRowsTableTableManager(_db, _db.coinTransactionRows);
  $$WalletSnapshotRowsTableTableManager get walletSnapshotRows =>
      $$WalletSnapshotRowsTableTableManager(_db, _db.walletSnapshotRows);
  $$UserSettingsRowsTableTableManager get userSettingsRows =>
      $$UserSettingsRowsTableTableManager(_db, _db.userSettingsRows);
}
