import 'package:focus_orbit/core/domain/app_failure.dart';
import 'package:focus_orbit/core/domain/result.dart';
import 'package:focus_orbit/features/economy/domain/coin_transaction.dart';
import 'package:focus_orbit/features/economy/domain/economy_ledger.dart';
import 'package:focus_orbit/features/economy/domain/user_settings.dart';

sealed class StorageFailure implements AppFailure {
  const StorageFailure();
}

final class StorageIoFailure extends StorageFailure {
  const StorageIoFailure(this.cause);
  final Object cause;
}

final class StorageCorrupted extends StorageFailure {
  const StorageCorrupted();
}

final class StorageMigrationFailed extends StorageFailure {
  const StorageMigrationFailed(this.fromVersion, this.toVersion);
  final int fromVersion;
  final int toVersion;
}

/// ローカル永続化の契約。実装はdrift(AD-3)、スキーマはT7-A1(ARCHITECTURE.md §7)が正。
/// 【実装拘束】
/// - apply()は「台帳INSERT + snapshot更新」を単一DBトランザクションで行う
/// - べき等性の真実はDBのUNIQUE(idempotency_key)。インメモリappliedKeysは
///   射影に過ぎず、UNIQUE違反捕捉時はAlreadyAppliedとして返す(事前チェックのみ禁止)
/// - 初回起動(データなし)は失敗ではなくEconomyState.initial()を返す
/// - 解放状態と残高は台帳からの射影(D14): 二重書込の不整合を構造的に排除
abstract interface class LocalPreferencesRepository {
  Future<Result<EconomyState, StorageFailure>> loadEconomyState();

  /// T6のEconomyLedger.applyを永続化境界で原子的に実行する
  Future<Result<LedgerResult, StorageFailure>> apply(CoinTransaction tx);

  /// ショップ用リアクティブ購読(適用成功のたびに新状態を流す)
  Stream<EconomyState> watchEconomyState();

  Future<Result<UserSettings, StorageFailure>> loadSettings();

  Future<Result<void, StorageFailure>> saveSettings(UserSettings settings);
}
