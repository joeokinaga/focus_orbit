import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:focus_orbit/features/motif/domain/motif_skin.dart';
import 'package:focus_orbit/features/motif/domain/render_params.dart';
import 'package:focus_orbit/features/motif/presentation/renderers/motif_stage_renderer.dart';
import 'package:focus_orbit/features/motif/presentation/renderers/stage_renderer_registry.dart';
import 'package:focus_orbit/features/motif/presentation/stage/stage_simulation.dart';

/// ステージへの入力を1点に束ねるハンドル。
///
/// 【所有権】生成した側(FocusView / デバッグハーネス)が保持する。
/// 内部リソース(Timer/Stream等)を持たないため dispose は不要 —
/// Ticker の生成/破棄は [MotifStage] 側の責務(ライフサイクル監査参照)。
///
/// 【層規則】アプリの真実(SessionPhase 等)は知らない。呼び出し側が
/// フェーズ変化を本ハンドルの命令へ「翻訳」する(focus_view の
/// _onPhaseChanged と同じ、表示用アニメーションの起動/停止のパターン)。
class MotifStageController {
  MotifStageController({
    StagePhysicsTuning tuning = const StagePhysicsTuning(),
    int seed = 1207,
  }) : simulation = StageSimulation(tuning: tuning, seed: seed);

  final StageSimulation simulation;

  /// セッション進捗(elapsed / plannedDuration)を 0..1 で渡す。
  void setProgress(double value) => simulation.setTargetFill(value);

  /// 集中度 0..1(P4-V1 では呼び出し側の導出値。将来はセンサ由来)。
  void setIntensity(double value) => simulation.setIntensity(value);

  /// running 中 true(蓄積が進む)。warning / 非アクティブで false。
  void setPouring(bool active) => simulation.setPouring(active);

  /// 崩壊(揺れ検知)。impulse は将来センサ振幅を写像する。
  void shatter({double impulse = 1.0}) =>
      simulation.shatter(impulse: impulse);

  /// 新セッション開始時のクリーンアップ(P4-V2)。前セッションの
  /// 蓄積・飛散粒子を持ち越さない。呼び出し責務は親(翻訳層)にある。
  void reset() => simulation.reset();
}

/// モチーフの物理ステージ(P4-V1)。
///
/// 【層規則】本ウィジェットはロジックを持たない。(1) Ticker で sim を
/// 時間発展させる (2) 装備モチーフのレンダラで描くだけ。判断はすべて
/// controller の呼び出し側にある。
///
/// 【ライフサイクル監査】生成/破棄ペア:
///   _ticker (createTicker)      : initState / dispose
///   _repaint (ChangeNotifier)   : initState / dispose
///   ※ controller は親の所有物 — ここでは生成も破棄もしない。
///
/// 【性能】毎フレームの setState はしない。CustomPainter の
/// repaint Listenable を Ticker から直接叩き、build を再実行させない。
class MotifStage extends StatefulWidget {
  const MotifStage({
    super.key,
    required this.controller,
    required this.motif,
  });

  final MotifStageController controller;
  final MotifSkin motif;

  @override
  State<MotifStage> createState() => _MotifStageState();
}

class _MotifStageState extends State<MotifStage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final _RepaintSignal _repaint;

  @override
  void initState() {
    super.initState();
    _repaint = _RepaintSignal();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    // 生成の逆順で破棄
    _ticker.dispose();
    _repaint.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    widget.controller.simulation.advance(elapsed);
    _repaint.ping();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        willChange: true,
        painter: _StagePainter(
          simulation: widget.controller.simulation,
          renderer: StageRendererRegistry.byId(widget.motif.id),
          params: widget.motif.renderParams,
          repaint: _repaint,
        ),
      ),
    );
  }
}

class _StagePainter extends CustomPainter {
  _StagePainter({
    required this.simulation,
    required this.renderer,
    required this.params,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final StageSimulation simulation;
  final MotifStageRenderer renderer;
  final RenderParams params;

  @override
  void paint(Canvas canvas, Size size) {
    renderer.paint(canvas, size, simulation, params);
  }

  @override
  bool shouldRepaint(_StagePainter oldDelegate) =>
      oldDelegate.simulation != simulation ||
      oldDelegate.renderer != renderer ||
      oldDelegate.params != params;
}

/// Ticker→CustomPainter の再描画橋(notifyListeners を公開するだけ)。
class _RepaintSignal extends ChangeNotifier {
  void ping() => notifyListeners();
}
