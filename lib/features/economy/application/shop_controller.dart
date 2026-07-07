import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/core/application/clock.dart';
import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/result.dart';
import 'package:focus_orbit/features/economy/application/economy_providers.dart';
import 'package:focus_orbit/features/economy/domain/coin_transaction.dart';
import 'package:focus_orbit/features/economy/domain/economy_ledger.dart';
import 'package:focus_orbit/features/motif/domain/motif_catalog.dart';

/// 購入結果。UIはこれで表示分岐する(プロバイダ固有型に依存しない)。
enum PurchaseOutcome {
  unlocked,
  alreadyOwned,
  insufficientBalance,
  unknownMotif,
  storageError,
}

final shopControllerProvider = Provider<ShopController>(ShopController.new);

/// ショップ経済圏の同期ロジック(要件5)。
/// 台帳(T6)はカタログを検証しない設計のため、カタログ検証はここが担う(D11)。
class ShopController {
  ShopController(this._ref);

  final Ref _ref;

  Future<PurchaseOutcome> purchase(MotifId id) async {
    final motif = MotifCatalog.byId(id);
    if (motif == null) return PurchaseOutcome.unknownMotif; // D11
    if (motif.priceCoins == 0) return PurchaseOutcome.alreadyOwned; // D10

    final tx = CoinTransaction.motifUnlock(
      motif: motif,
      occurredAt: _ref.read(clockProvider)(),
    );
    final res = await _ref.read(localPreferencesRepositoryProvider).apply(tx);
    // await後にstateもref(watch系)も触らないためmountedガード不要(T9監査#3)
    return switch (res) {
      Success(value: Applied()) => PurchaseOutcome.unlocked,
      Success(value: AlreadyApplied()) => PurchaseOutcome.alreadyOwned,
      Success(value: LedgerRejected()) => PurchaseOutcome.insufficientBalance,
      Failure() => PurchaseOutcome.storageError,
    };
  }

  /// 【デバッグ専用シード(P3-T2 E2E足場)】台帳を「通る」正規のearn取引で
  /// コインを付与する。フラグ書換の裏口ではない — D14(残高=台帳射影)・
  /// T6(べき等キー)・T7/D22(DB制約)の全防御層は生きたまま動く。
  /// キーはタップ毎に一意('debug-seed:{epoch_us}')のため連打で累積付与できる。
  /// releaseビルドでは到達不能(assert相当のガードで即throw)。
  Future<void> debugSeedCoins(int coins) async {
    if (!kDebugMode) {
      throw StateError('debugSeedCoins はdebugビルド専用');
    }
    final now = _ref.read(clockProvider)();
    await _ref.read(localPreferencesRepositoryProvider).apply(
          CoinTransaction.sessionReward(
            sessionId: SessionId('debug-seed:${now.microsecondsSinceEpoch}'),
            coins: coins,
            occurredAt: now,
          ),
        );
    // await後にstateもref(watch系)も触らない(T9監査#3と同型)
  }
}
