import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/sync_mode.dart';
import 'package:focus_orbit/features/session/domain/session_phase.dart';

part 'focus_session.freezed.dart';

/// 1回の集中セッション。
@freezed
abstract class FocusSession with _$FocusSession {
  const factory FocusSession({
    required SessionId id,
    required Duration plannedDuration,
    /// 進行(tick)は遷移ではないため、elapsedの更新はSessionControllerが
    /// copyWithで行う(D12)。
    required Duration elapsed,
    required SessionPhase phase,
    required MotifId motifId,
    required SyncMode syncMode,
  }) = _FocusSession;
}
