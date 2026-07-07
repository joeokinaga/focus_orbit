import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/domain/motif_skin.dart';

part 'coin_transaction.freezed.dart';

/// D9: economy→motif は許可済みdomain間エッジ(ID・価格の参照)。
@freezed
sealed class CoinTransaction with _$CoinTransaction {
  const CoinTransaction._();

  @Assert('amount > 0')
  const factory CoinTransaction.earn({
    required String idempotencyKey,
    required int amount,
    required DateTime occurredAt,
  }) = Earn;

  @Assert('amount > 0')
  const factory CoinTransaction.spendUnlock({
    required String idempotencyKey,
    required int amount,
    required MotifId motifId,
    required DateTime occurredAt,
  }) = SpendUnlock;

  /// セッション報酬: キーはsessionId由来 → T4のGrantRewardと1:1
  factory CoinTransaction.sessionReward({
    required SessionId sessionId,
    required int coins,
    required DateTime occurredAt,
  }) =>
      CoinTransaction.earn(
          idempotencyKey: 'session:${sessionId.value}',
          amount: coins,
          occurredAt: occurredAt);

  /// モチーフ解放: 価格0(初期解放品)の購入トランザクションは生成禁止(D10)
  factory CoinTransaction.motifUnlock({
    required MotifSkin motif,
    required DateTime occurredAt,
  }) {
    assert(motif.priceCoins > 0, '価格0は購入対象外(D10)');
    return CoinTransaction.spendUnlock(
        idempotencyKey: 'unlock:${motif.id.value}',
        amount: motif.priceCoins,
        motifId: motif.id,
        occurredAt: occurredAt);
  }
}
