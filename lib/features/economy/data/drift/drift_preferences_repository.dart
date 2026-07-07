import 'package:drift/drift.dart';
import 'package:sqlite3/common.dart' show SqliteException;

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/result.dart';
import 'package:focus_orbit/features/economy/data/drift/economy_database.dart';
import 'package:focus_orbit/features/economy/domain/coin_transaction.dart';
import 'package:focus_orbit/features/economy/domain/economy_ledger.dart';
import 'package:focus_orbit/features/economy/domain/local_preferences_repository.dart';
import 'package:focus_orbit/features/economy/domain/user_settings.dart';

/// P2-T1: LocalPreferencesRepository の drift 実装(AD-3, §7契約)。
///
/// 【実装拘束の充足】
/// - apply() = 「台帳INSERT + snapshot更新」を単一 _db.transaction で実行。
/// - べき等性の真実は DB の UNIQUE(idempotency_key)。インメモリ appliedKeys
///   ヒットは高速経路に過ぎず、UNIQUE 違反の捕捉時も AlreadyApplied を返す
///   (競合時の正当経路。事前チェックのみへの依存は無い)。
/// - 初回起動(行ゼロ)は EconomyState.initial() / UserSettings.defaults()
///   であり失敗ではない。
/// - 残高・解放状態は台帳からの射影(D14): 射影関数は独自集計を持たず、
///   EconomyLedger.apply(T6, 経済圏唯一の遷移点)による初期状態からの
///   リプレイとして実装。ドメインとDBの解釈が構造的に乖離しない。
class DriftPreferencesRepository implements LocalPreferencesRepository {
  DriftPreferencesRepository(this._db);

  final EconomyDatabase _db;

  // ---------------------------------------------------------------- load

  @override
  Future<Result<EconomyState, StorageFailure>> loadEconomyState() async {
    try {
      final rows = await _orderedLedgerRows().get();
      final state = _project(rows);
      // snapshot はキャッシュ(D14)。台帳射影との不一致 = 同一トランザクション
      // 規約が破られた証拠なので StorageCorrupted として表面化させる。
      final snapshot = await _snapshotRow();
      final snapshotMissing = snapshot == null && rows.isNotEmpty;
      final snapshotDiverged =
          snapshot != null && snapshot.balance != state.wallet.balance;
      if (snapshotMissing || snapshotDiverged) {
        return const Failure(StorageCorrupted());
      }
      return Success(state);
    } on StorageCorrupted catch (e) {
      return Failure(e);
    } on Exception catch (e) {
      return Failure(StorageIoFailure(e));
    }
  }

  // --------------------------------------------------------------- apply

  @override
  Future<Result<LedgerResult, StorageFailure>> apply(CoinTransaction tx) async {
    try {
      final result = await _db.transaction<LedgerResult>(() async {
        final rows = await _orderedLedgerRows().get();
        final current = _project(rows);
        final domainResult = EconomyLedger.apply(current, tx);
        switch (domainResult) {
          case AlreadyApplied():
          case LedgerRejected():
            // 拒否・既適用は書き込みゼロでそのまま返す(トランザクションは
            // 読み取りのみで終了)。
            return domainResult;
          case Applied(state: final next):
            await _db.into(_db.coinTransactionRows).insert(_toCompanion(tx));
            await _db.into(_db.walletSnapshotRows).insertOnConflictUpdate(
                  WalletSnapshotRowsCompanion.insert(
                    id: const Value(1),
                    balance: next.wallet.balance,
                  ),
                );
            return domainResult;
        }
      });
      return Success(result);
    } on StorageCorrupted catch (e) {
      return Failure(e);
    } on Exception catch (e) {
      if (_isUniqueViolation(e)) {
        // 競合(別isolate/プロセスが同一キーを先に適用)。UNIQUE 制約が真実
        // であることの帰結として、これは失敗ではなく AlreadyApplied(T7)。
        // トランザクションはロールバック済みなので最新状態を読み直す。
        final reloaded = await loadEconomyState();
        return switch (reloaded) {
          Success(value: final state) => Success(AlreadyApplied(state)),
          Failure(error: final failure) => Failure(failure),
        };
      }
      return Failure(StorageIoFailure(e));
    }
  }

  // --------------------------------------------------------------- watch

  /// ショップ用リアクティブ購読。drift の watch は listen 直後に現在値を
  /// 1件流すため、economyStateProvider(StreamProvider)側は追加処理なしで
  /// 初期表示できる。台帳破損はStreamエラーとして表面化し、AsyncValue.error
  /// で観測される(握り潰さない)。
  @override
  Stream<EconomyState> watchEconomyState() =>
      _orderedLedgerRows().watch().map(_project);

  // ------------------------------------------------------------ settings

  @override
  Future<Result<UserSettings, StorageFailure>> loadSettings() async {
    try {
      final row = await (_db.select(_db.userSettingsRows)
            ..where((t) => t.id.equals(1)))
          .getSingleOrNull();
      if (row == null) {
        // 初回起動は失敗ではない(§7)。既定値は保存せず返すだけ:
        // 「保存された設定が無い」状態を上書きしない。
        return Success(UserSettings.defaults());
      }
      // LANDMINE ②: freezed に fromJson は無い。ここが明示マッパー。
      // 未知の selectedMotifId はそのまま返す — フォールバックは
      // カタログ検証責務を持つ呼び出し側(D11, ShopController/DI)の仕事。
      return Success(UserSettings(
        selectedMotifId: MotifId(row.selectedMotifId),
        defaultSessionDuration:
            Duration(milliseconds: row.defaultSessionDurationMs),
        bgmEnabled: row.bgmEnabled,
      ));
    } on Exception catch (e) {
      return Failure(StorageIoFailure(e));
    }
  }

  @override
  Future<Result<void, StorageFailure>> saveSettings(
      UserSettings settings) async {
    try {
      await _db.into(_db.userSettingsRows).insertOnConflictUpdate(
            UserSettingsRowsCompanion.insert(
              id: const Value(1),
              selectedMotifId: settings.selectedMotifId.value,
              defaultSessionDurationMs:
                  settings.defaultSessionDuration.inMilliseconds,
              bgmEnabled: settings.bgmEnabled,
            ),
          );
      return const Success(null);
    } on Exception catch (e) {
      return Failure(StorageIoFailure(e));
    }
  }

  // ------------------------------------------------------------ internal

  SimpleSelectStatement<$CoinTransactionRowsTable, CoinTransactionRow>
      _orderedLedgerRows() => _db.select(_db.coinTransactionRows)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]);

  Future<WalletSnapshotRow?> _snapshotRow() =>
      (_db.select(_db.walletSnapshotRows)..where((t) => t.id.equals(1)))
          .getSingleOrNull();

  /// D14 射影: initial() から台帳を id 昇順にリプレイ。
  /// リプレイ中の AlreadyApplied / LedgerRejected は「INSERT時に検証済みの
  /// 行が再生不能」= 台帳破損の証拠なので StorageCorrupted を投げる。
  EconomyState _project(List<CoinTransactionRow> rows) {
    var state = EconomyState.initial();
    for (final row in rows) {
      final result = EconomyLedger.apply(state, _toDomain(row));
      state = switch (result) {
        Applied(state: final next) => next,
        AlreadyApplied() || LedgerRejected() => throw const StorageCorrupted(),
      };
    }
    return state;
  }

  CoinTransaction _toDomain(CoinTransactionRow row) {
    final occurredAt =
        DateTime.fromMillisecondsSinceEpoch(row.occurredAtUtcMs, isUtc: true);
    switch (row.type) {
      case kTxTypeEarn:
        return CoinTransaction.earn(
          idempotencyKey: row.idempotencyKey,
          amount: row.amount,
          occurredAt: occurredAt,
        );
      case kTxTypeSpendUnlock:
        final motifId = row.motifId;
        if (motifId == null) {
          // テーブルCHECKにより到達不能のはずだが、外部改変への防衛。
          throw const StorageCorrupted();
        }
        return CoinTransaction.spendUnlock(
          idempotencyKey: row.idempotencyKey,
          amount: row.amount,
          motifId: MotifId(motifId),
          occurredAt: occurredAt,
        );
      default:
        throw const StorageCorrupted();
    }
  }

  CoinTransactionRowsCompanion _toCompanion(CoinTransaction tx) =>
      switch (tx) {
        Earn(
          :final idempotencyKey,
          :final amount,
          :final occurredAt,
        ) =>
          CoinTransactionRowsCompanion.insert(
            idempotencyKey: idempotencyKey,
            type: kTxTypeEarn,
            amount: amount,
            occurredAtUtcMs: occurredAt.toUtc().millisecondsSinceEpoch,
          ),
        SpendUnlock(
          :final idempotencyKey,
          :final amount,
          :final motifId,
          :final occurredAt,
        ) =>
          CoinTransactionRowsCompanion.insert(
            idempotencyKey: idempotencyKey,
            type: kTxTypeSpendUnlock,
            amount: amount,
            motifId: Value(motifId.value),
            occurredAtUtcMs: occurredAt.toUtc().millisecondsSinceEpoch,
          ),
      };

  /// UNIQUE(idempotency_key) 違反の判定。
  /// 一次判定: sqlite3 の SqliteException 拡張コード
  ///   SQLITE_CONSTRAINT(19) / SQLITE_CONSTRAINT_UNIQUE(2067)。
  /// 二次判定: SQLite が安定して出すメッセージ書式
  ///   'UNIQUE constraint failed: coin_transactions.idempotency_key'
  ///   (executor実装によって例外が別型にラップされる場合の保険)。
  bool _isUniqueViolation(Object e) {
    if (e is SqliteException &&
        (e.extendedResultCode == 2067 || e.resultCode == 19)) {
      return e.toString().contains('idempotency_key');
    }
    final message = e.toString();
    return message.contains('UNIQUE constraint failed') &&
        message.contains('idempotency_key');
  }
}
