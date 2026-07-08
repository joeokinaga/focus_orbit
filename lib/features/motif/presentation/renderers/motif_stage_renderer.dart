import 'dart:ui';

import 'package:focus_orbit/features/motif/domain/render_params.dart';
import 'package:focus_orbit/features/motif/presentation/stage/stage_simulation.dart';

/// モチーフ描画の抽象(P4-V1)。
///
/// 【契約】
/// - [sim] は読み取り専用。レンダラが sim を変異させることは禁止
///   (物理の真実は StageSimulation、描画はその写像 — DOC/CODE同型)。
/// - 色は必ず [params](= 装備モチーフの RenderParams)から取る。
///   モチーフが画面の色を支配する、という fo_theme の方針の延長。
/// - paint 内でのアロケーションは Paint/Path 数個まで。
///   粒子ごとの Paint 生成は禁止(1個を使い回して色だけ変える)。
abstract class MotifStageRenderer {
  const MotifStageRenderer();

  void paint(Canvas canvas, Size size, StageSimulation sim, RenderParams params);
}
