import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:focus_orbit/core/domain/app_failure.dart';
import 'package:focus_orbit/features/economy/domain/coin_transaction.dart';
import 'package:focus_orbit/features/economy/domain/unlock_state.dart';
import 'package:focus_orbit/features/economy/domain/wallet.dart';
import 'package:focus_orbit/features/motif/domain/motifs/water_motif.dart';

part 'economy_ledger.freezed.dart';

@freezed
abstract class EconomyState with _$EconomyState {
  const factory EconomyState({
    required Wallet wallet,
    required UnlockState unlocks,
    /// 永続台帳(drift, T7)のインメモリ射影。べき等性の真実はDBのUNIQUE制約。
    required Set<String> appliedKeys,
  }) = _EconomyState;

  factory EconomyState.initial() => EconomyState(
        wallet: Wallet.empty(),
        unlocks: UnlockState(unlockedIds: {const WaterMotif().id}), // D10
        appliedKeys: const <String>{}, // T10修正: const {} は空Map推論のため型明示
      );
}

sealed class EconomyFailure implements AppFailure {
  const EconomyFailure();
}

final class InsufficientBalance extends EconomyFailure {
  const InsufficientBalance({required this.required, required this.available});
  final int required;
  final int available;
}

/// core/Result<T,E>でなく専用3値: べき等ヒット(AlreadyApplied)を成功と
/// 区別して観測可能にするため(監査・デバッグ用途)。
sealed class LedgerResult {
  const LedgerResult();
}

final class Applied extends LedgerResult {
  const Applied(this.state);
  final EconomyState state;
}

final class AlreadyApplied extends LedgerResult {
  const AlreadyApplied(this.state); // stateは入力と同一インスタンス
  final EconomyState state;
}

final class LedgerRejected extends LedgerResult {
  const LedgerRejected(this.failure);
  final EconomyFailure failure;
}

/// 経済圏の唯一の状態遷移点。残高・解放の変更は全てここを通る(T6)。
class EconomyLedger {
  const EconomyLedger._();

  static LedgerResult apply(EconomyState state, CoinTransaction tx) {
    if (state.appliedKeys.contains(tx.idempotencyKey)) {
      return AlreadyApplied(state); // 二重適用→状態不変(同一インスタンス)
    }
    return switch (tx) {
      Earn(:final amount) => Applied(state.copyWith(
          wallet: Wallet(balance: state.wallet.balance + amount),
          appliedKeys: {...state.appliedKeys, tx.idempotencyKey})),
      SpendUnlock(:final amount, :final motifId) =>
        !state.wallet.canAfford(amount)
            ? LedgerRejected(InsufficientBalance(
                required: amount, available: state.wallet.balance))
            : Applied(state.copyWith(
                wallet: Wallet(balance: state.wallet.balance - amount),
                unlocks: state.unlocks.unlock(motifId),
                appliedKeys: {...state.appliedKeys, tx.idempotencyKey})),
    };
  }
}
