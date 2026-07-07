import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_phase.freezed.dart';

enum AbortReason { pickedUp, graceTimeout, userCancelled, systemInterrupted }

/// セッションフェーズ。遷移規則はsession_transition.dart(T0-A3 v1.1が正)。
@freezed
sealed class SessionPhase with _$SessionPhase {
  const factory SessionPhase.idle() = Idle;
  const factory SessionPhase.running() = Running;
  const factory SessionPhase.warning() = Warning;
  const factory SessionPhase.completed({required int rewardCoins}) = Completed;
  const factory SessionPhase.aborted({required AbortReason reason}) = Aborted;
}
