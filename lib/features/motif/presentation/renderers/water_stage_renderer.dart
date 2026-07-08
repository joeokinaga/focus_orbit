import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:focus_orbit/app/presentation/fo_theme.dart';
import 'package:focus_orbit/features/motif/domain/render_params.dart';
import 'package:focus_orbit/features/motif/presentation/renderers/motif_stage_renderer.dart';
import 'package:focus_orbit/features/motif/presentation/stage/stage_simulation.dart';

/// モチーフ1「水(フラスコ/波紋)」の描画(P4-V1 プロトタイプ)。
///
/// 【構図】
///   画面下部: フラスコ。集中の進捗が水として溜まり、滴の着水で波紋が走る。
///   画面上部: 光の輪(オービット)。集中度で速度と輪の数が増す。
///   崩壊時: 輪のモートが FreedMote として飛散し、水面が激しくスロッシュする。
///
/// 【性能規約】paint 内の Paint はトップで確保して使い回す。
/// 粒子予算は sim 側で制限済み(§stage_simulation)。
final class WaterStageRenderer extends MotifStageRenderer {
  const WaterStageRenderer();

  @override
  void paint(
      Canvas canvas, Size size, StageSimulation sim, RenderParams params) {
    final primary = params.primaryColor;
    final secondary = params.secondaryColor;

    // ---- フラスコの配置(容器フレーム→px) --------------------------------
    final flaskW = math.min(size.width * 0.64, size.height * 0.46);
    final flaskH = size.height * 0.52;
    final flaskRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.68),
      width: flaskW,
      height: flaskH,
    );
    final flask = RRect.fromRectAndCorners(
      flaskRect,
      topLeft: Radius.circular(flaskW * 0.10),
      topRight: Radius.circular(flaskW * 0.10),
      bottomLeft: Radius.circular(flaskW * 0.30),
      bottomRight: Radius.circular(flaskW * 0.30),
    );

    // ---- アンビエントグロー(存在の重心を下に置く=重量感) ------------------
    final glowPaint = Paint()
      ..color = primary.withValues(
          alpha: 0.08 + 0.22 * params.ambientGlow * (0.4 + 0.6 * sim.intensity))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 42);
    canvas.drawCircle(flaskRect.center, flaskW * 0.62, glowPaint);

    // ---- 水体(クリップ内) ------------------------------------------------
    final heights = sim.surfaceHeights;
    final n = heights.length;
    final surfaceYPx = flaskRect.top + sim.surfaceLevelY * flaskH;
    final amp = flaskH * 0.16;

    canvas.save();
    canvas.clipRRect(flask);

    final waterPath = Path()
      ..moveTo(flaskRect.left, flaskRect.bottom + 2)
      ..lineTo(flaskRect.left, surfaceYPx + heights[0] * amp);
    for (var i = 1; i < n; i++) {
      waterPath.lineTo(
        flaskRect.left + flaskW * i / (n - 1),
        surfaceYPx + heights[i] * amp,
      );
    }
    waterPath
      ..lineTo(flaskRect.right, flaskRect.bottom + 2)
      ..close();

    final waterPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [secondary.withValues(alpha: 0.80), primary],
      ).createShader(Rect.fromLTRB(
        flaskRect.left,
        surfaceYPx - amp,
        flaskRect.right,
        flaskRect.bottom,
      ));
    canvas.drawPath(waterPath, waterPaint);

    // 水面のきらめき(本線+にじみの2度描き)
    final glintPath = Path()
      ..moveTo(flaskRect.left, surfaceYPx + heights[0] * amp);
    for (var i = 1; i < n; i++) {
      glintPath.lineTo(
        flaskRect.left + flaskW * i / (n - 1),
        surfaceYPx + heights[i] * amp,
      );
    }
    final glintBlur = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = secondary.withValues(alpha: 0.30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(glintPath, glintBlur);
    final glintCore = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = secondary.withValues(alpha: 0.85);
    canvas.drawPath(glintPath, glintCore);

    // 泡(Paint 1個を使い回す)
    final bubblePaint = Paint()..color = secondary.withValues(alpha: 0.28);
    for (final b in sim.bubbles) {
      final pos = Offset(
        flaskRect.left + b.x * flaskW,
        flaskRect.top + b.y * flaskH,
      );
      if (pos.dy <= surfaceYPx) continue; // 水面上には描かない
      canvas.drawCircle(pos, b.radius * flaskH, bubblePaint);
    }

    canvas.restore();

    // ---- 滴(クリップ外 — 注ぎの筋が容器上から見える) ----------------------
    final dropletPaint = Paint()..color = secondary.withValues(alpha: 0.9);
    for (final d in sim.droplets) {
      canvas.drawCircle(
        Offset(flaskRect.left + d.x * flaskW, flaskRect.top + d.y * flaskH),
        2.4,
        dropletPaint,
      );
    }

    // ---- ガラス ------------------------------------------------------------
    final glassPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0x1AFFFFFF);
    canvas.drawRRect(flask, glassPaint);
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0x0FFFFFFF);
    canvas.drawLine(
      Offset(flaskRect.left + flaskW * 0.12, flaskRect.top + flaskH * 0.12),
      Offset(flaskRect.left + flaskW * 0.12, flaskRect.bottom - flaskH * 0.18),
      highlightPaint,
    );

    // ---- オービット(オービットフレーム→px) ------------------------------
    final unit = size.shortestSide;
    final orbitCenter = Offset(
      size.width / 2,
      math.max(size.height * 0.14, flaskRect.top - size.height * 0.16),
    );

    final ringLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x0AFFFFFF);
    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = secondary.withValues(alpha: 0.18 + 0.20 * sim.intensity);
    final moteGlowPaint = Paint()
      ..color = secondary.withValues(alpha: 0.22 + 0.45 * sim.intensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);
    final moteCorePaint = Paint()..color = FoPalette.text;

    final trailSweep = 0.45 + 0.85 * sim.intensity;
    for (final ring in sim.rings) {
      final radiusPx = ring.radiusUnit * unit;
      canvas.drawCircle(orbitCenter, radiusPx, ringLinePaint);
      final arcRect = Rect.fromCircle(center: orbitCenter, radius: radiusPx);
      for (final angle in ring.moteAngles) {
        // 尾(進行方向の逆へ流れる)
        canvas.drawArc(
          arcRect,
          ring.speedSign > 0 ? angle - trailSweep : angle,
          trailSweep,
          false,
          trailPaint,
        );
        final pos = orbitCenter +
            Offset(math.cos(angle), math.sin(angle)) * radiusPx;
        canvas.drawCircle(pos, 6, moteGlowPaint);
        canvas.drawCircle(pos, 2.6, moteCorePaint);
      }
    }

    // ---- 解放粒子(崩壊の残響 — 寿命でフェード) ----------------------------
    final freedPaint = Paint();
    for (final m in sim.freedMotes) {
      final alpha = m.life.clamp(0.0, 1.0).toDouble();
      freedPaint.color = secondary.withValues(alpha: 0.7 * alpha);
      canvas.drawCircle(orbitCenter + m.position * unit, 2.2, freedPaint);
    }
  }
}
