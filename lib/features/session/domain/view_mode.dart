import 'package:focus_orbit/features/session/domain/session_phase.dart';

/// 要件2: Focus View(メイングラフィック) / Orbit View(宇宙・マルチ同期)
enum ViewMode { focus, orbit }

/// D2: 切替はアクティブフェーズ中のみ。exhaustive switch(defaultなし)で網羅を強制。
class ViewModePolicy {
  const ViewModePolicy._();

  static bool canToggle(SessionPhase phase) => switch (phase) {
        Running() || Warning() => true,
        Idle() || Completed() || Aborted() => false,
      };
}
