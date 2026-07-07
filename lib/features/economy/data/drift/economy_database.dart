import 'package:drift/drift.dart';

part 'economy_database.g.dart';

/// P2-T1: ARCHITECTURE.md §7 のスキーマ契約を実装する drift DDL。
///
/// 【第3層防御(T7)】経済圏の不変条件は三層で守る:
///   (1) EconomyLedger.apply の業務規則 (2) Wallet等の @Assert
///   (3) 本ファイルの DB 制約 — UNIQUE(idempotency_key) / CHECK(amount > 0)
///       / CHECK(balance >= 0)。(1)(2)にバグがあっても(3)がINSERT/UPDATEを
///       拒否し、トランザクションごとロールバックさせる。
///
/// 【列名規約】drift 既定の snake_case 変換に依存する
///   (idempotencyKey → idempotency_key)。§7 の表と1:1対応。
/// 【時刻】UTCエポックms の INTEGER(§7)。DateTime型カラムは使わない
///   (driftのdateTime既定は秒精度のため、msを自前intで保持)。

const String kTxTypeEarn = 'earn';
const String kTxTypeSpendUnlock = 'spend_unlock';

/// 台帳: 追記専用(append-only)。UPDATE/DELETEを発行するコードは書かない。
/// マイグレーションでの破壊的変更も禁止(§7)。
@DataClassName('CoinTransactionRow')
class CoinTransactionRows extends Table {
  @override
  String get tableName => 'coin_transactions';

  IntColumn get id => integer().autoIncrement()();

  /// べき等性の真実(T7)。事前チェックではなくこのUNIQUE違反の捕捉が正。
  TextColumn get idempotencyKey => text().unique()();

  /// 'earn' | 'spend_unlock'。下の customConstraints で値域もCHECK。
  TextColumn get type => text()();

  /// CHECK(amount > 0): 0円・負額トランザクションはDB層でも構築不可能。
  IntColumn get amount => integer().check(amount.isBiggerThanValue(0))();

  /// spend_unlock のときのみ非NULL(earnはNULL)。整合はテーブルCHECKで強制。
  TextColumn get motifId => text().nullable()();

  IntColumn get occurredAtUtcMs => integer()();

  @override
  List<String> get customConstraints => [
        // type の値域と、type↔motif_id の整合を第3層で強制する。
        "CHECK ((type = 'earn' AND motif_id IS NULL) "
            "OR (type = 'spend_unlock' AND motif_id IS NOT NULL))",
      ];
}

/// 残高キャッシュ(D14: 真実は台帳、これは射影の写し)。
/// 台帳INSERTと同一トランザクションでのみ更新される。
/// CHECK(balance >= 0): 負残高は(1)(2)をすり抜けてもここで死ぬ。
@DataClassName('WalletSnapshotRow')
class WalletSnapshotRows extends Table {
  @override
  String get tableName => 'wallet_snapshot';

  /// 単一行規約: CHECK(id = 1) で2行目の存在をDB層で禁止。
  IntColumn get id => integer().check(id.equals(1))();

  IntColumn get balance => integer().check(balance.isBiggerOrEqualValue(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ユーザー設定(単一行・全列NOT NULL = drift非nullable既定で充足)。
/// freezed に fromJson が無いため(LANDMINE ②)、ドメイン⇔行の変換は
/// DriftPreferencesRepository 側で明示マッパーとして実装する。
@DataClassName('UserSettingsRow')
class UserSettingsRows extends Table {
  @override
  String get tableName => 'user_settings';

  IntColumn get id => integer().check(id.equals(1))();

  TextColumn get selectedMotifId => text()();

  /// Duration はミリ秒intで永続化(§7: 時刻・期間はUTCエポックms/ms単位)。
  IntColumn get defaultSessionDurationMs =>
      integer().check(defaultSessionDurationMs.isBiggerThanValue(0))();

  BoolColumn get bgmEnabled => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [CoinTransactionRows, WalletSnapshotRows, UserSettingsRows],
)
class EconomyDatabase extends _$EconomyDatabase {
  /// 実行体(QueryExecutor)は外部注入: 本番は drift_flutter の
  /// openEconomyDatabaseConnection()、テストは NativeDatabase.memory()。
  /// これによりテストが Flutter バインディング非依存で決定的に走る。
  EconomyDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // §7: 台帳テーブル(coin_transactions)への破壊的変更は禁止。
          // 将来のスキーマ変更は「列追加＋新テーブル」の加算的ステップのみ。
          // v1が最初の版のため、ここに到達するアップグレード経路は存在しない。
          throw StateError('unknown schema upgrade $from -> $to');
        },
      );
}
