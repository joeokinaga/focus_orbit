import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/features/session/application/session_controller.dart';
import 'package:focus_orbit/features/session/domain/view_mode.dart';

final viewModeControllerProvider =
    NotifierProvider<ViewModeController, ViewMode>(ViewModeController.new);

/// 要件2: Focus View / Orbit Viewの切替。判断規則はViewModePolicy(D2)に委譲。
class ViewModeController extends Notifier<ViewMode> {
  @override
  ViewMode build() => ViewMode.focus;

  /// 戻り値false = セッション非アクティブによる拒否(UIはトースト等で通知)。
  bool toggle() {
    final phase = ref.read(sessionControllerProvider).phase;
    if (!ViewModePolicy.canToggle(phase)) return false;
    state = state == ViewMode.focus ? ViewMode.orbit : ViewMode.focus;
    return true;
  }
}
