import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/app/presentation/fo_theme.dart';
import 'package:focus_orbit/features/stance/application/stance_debug_providers.dart';
import 'package:focus_orbit/features/stance/application/stance_providers.dart';
import 'package:focus_orbit/features/stance/domain/device_stance.dart';
import 'package:focus_orbit/features/stance/domain/motion_sample.dart';
import 'package:focus_orbit/features/stance/domain/sensor_gateway.dart';

/// 【Phase 1 検証用】センサー→MotionSample→DeviceStance の生値モニタ。
/// 実機チューニング(T3 RISKS: 閾値較正)のための観測窓であり、本番導線に含めない。
///
/// 【層規則】数値の解釈(RMS計算・分類)は一切行わない。
/// 表示するのは (a) 生サンプル (b) StanceDetector の確定出力 (c) 閾値の現在値 のみ。
class SensorDebugView extends ConsumerWidget {
  const SensorDebugView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleAsync = ref.watch(motionSampleDebugProvider);
    final stanceAsync = ref.watch(stanceDebugProvider);
    final thresholds = ref.watch(stanceThresholdsProvider);

    return Scaffold(
      backgroundColor: FoPalette.ink,
      appBar: AppBar(
        backgroundColor: FoPalette.ink,
        foregroundColor: FoPalette.text,
        title: const Text('センサーモニタ', style: TextStyle(fontSize: 16)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(FoSpace.md),
          children: [
            _StancePanel(stance: stanceAsync),
            const SizedBox(height: FoSpace.md),
            _SamplePanel(sample: sampleAsync),
            const SizedBox(height: FoSpace.md),
            _ThresholdPanel(
              stillRmsMax: thresholds.stillRmsMax,
              vibrationRmsMax: thresholds.vibrationRmsMax,
              faceUpGravityZMin: thresholds.faceUpGravityZMin,
              commitDebounce: thresholds.commitDebounce,
              rmsWindow: thresholds.rmsWindow,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 確定スタンス(ヒステリシス通過後)
// ---------------------------------------------------------------------------

class _StancePanel extends StatelessWidget {
  const _StancePanel({required this.stance});

  final AsyncValue<DeviceStance> stance;

  @override
  Widget build(BuildContext context) {
    final (String label, String detail, Color color) = switch (stance) {
      AsyncData(:final value) => switch (value) {
          FaceUpStill() => ('faceUpStill', '上向き・静止(集中OK)', const Color(0xFF6FCF9B)),
          MicroVibration(:final rms) =>
            ('microVibration', 'RMS ${rms.toStringAsFixed(3)} m/s²', FoPalette.caution),
          Lifted() => ('lifted', '持ち上げ・傾き・大きな動き', FoPalette.danger),
        },
      AsyncError(:final error) => (
          'エラー',
          error is SensorFailure ? 'センサー利用不可(SensorFailure)' : '$error',
          FoPalette.danger
        ),
      AsyncLoading() => ('確定待ち', 'commitDebounce経過待ち…', FoPalette.textDim),
    };

    return _Panel(
      title: '確定スタンス',
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10),
              ],
            ),
          ),
          const SizedBox(width: FoSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                Text(detail,
                    style: const TextStyle(
                        color: FoPalette.textDim, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 生サンプル
// ---------------------------------------------------------------------------

class _SamplePanel extends StatelessWidget {
  const _SamplePanel({required this.sample});

  final AsyncValue<MotionSample> sample;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: '生サンプル (MotionSample)',
      child: switch (sample) {
        AsyncData(:final value) => Column(
            children: [
              _ValueRow(
                  label: 'gravityZ(上向き判定軸)',
                  value: value.gravityZ,
                  unit: 'm/s²'),
              _ValueRow(label: 'gravityX', value: value.gravityX, unit: 'm/s²'),
              _ValueRow(label: 'gravityY', value: value.gravityY, unit: 'm/s²'),
              const Divider(),
              _ValueRow(
                  label: '|user|(重力除去・瞬時)',
                  value: math.sqrt(value.userX * value.userX +
                      value.userY * value.userY +
                      value.userZ * value.userZ),
                  unit: 'm/s²'),
              _ValueRow(label: 'userX', value: value.userX, unit: 'm/s²'),
              _ValueRow(label: 'userY', value: value.userY, unit: 'm/s²'),
              _ValueRow(label: 'userZ', value: value.userZ, unit: 'm/s²'),
            ],
          ),
        AsyncError(:final error) => Padding(
            padding: const EdgeInsets.symmetric(vertical: FoSpace.sm),
            child: Text(
              error is SensorFailure
                  ? 'センサーを利用できません。実機で起動しているか、権限を確認してください(シミュレータには加速度計がありません)'
                  : '取得エラー: $error',
              style: const TextStyle(color: FoPalette.danger, fontSize: 13),
            ),
          ),
        AsyncLoading() => const Padding(
            padding: EdgeInsets.symmetric(vertical: FoSpace.sm),
            child: Text('両系統(gravity/user)の初回サンプル待ち…',
                style: TextStyle(color: FoPalette.textDim, fontSize: 13)),
          ),
      },
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow(
      {required this.label, required this.value, required this.unit});

  final String label;
  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style:
                    const TextStyle(color: FoPalette.textDim, fontSize: 12)),
          ),
          Text(
            value.toStringAsFixed(3),
            style: const TextStyle(
              color: FoPalette.text,
              fontSize: 14,
              fontFeatures: foTabularFigures,
            ),
          ),
          const SizedBox(width: 4),
          Text(unit,
              style: const TextStyle(color: FoPalette.textDim, fontSize: 10)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 閾値の現在値(較正時に見比べる基準)
// ---------------------------------------------------------------------------

class _ThresholdPanel extends StatelessWidget {
  const _ThresholdPanel({
    required this.stillRmsMax,
    required this.vibrationRmsMax,
    required this.faceUpGravityZMin,
    required this.commitDebounce,
    required this.rmsWindow,
  });

  final double stillRmsMax;
  final double vibrationRmsMax;
  final double faceUpGravityZMin;
  final Duration commitDebounce;
  final Duration rmsWindow;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: '現在の閾値 (StanceThresholds.defaults — T3較正対象)',
      child: Column(
        children: [
          _ValueRow(label: 'stillRmsMax', value: stillRmsMax, unit: 'm/s²'),
          _ValueRow(
              label: 'vibrationRmsMax', value: vibrationRmsMax, unit: 'm/s²'),
          _ValueRow(
              label: 'faceUpGravityZMin',
              value: faceUpGravityZMin,
              unit: 'm/s²'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                const Expanded(
                  child: Text('commitDebounce / rmsWindow',
                      style:
                          TextStyle(color: FoPalette.textDim, fontSize: 12)),
                ),
                Text(
                  '${commitDebounce.inMilliseconds}ms / ${rmsWindow.inMilliseconds}ms',
                  style: const TextStyle(
                    color: FoPalette.text,
                    fontSize: 14,
                    fontFeatures: foTabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FoSpace.md),
      decoration: BoxDecoration(
        color: FoPalette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FoPalette.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: FoPalette.textDim,
                  fontSize: 11,
                  letterSpacing: 1.2)),
          const SizedBox(height: FoSpace.sm),
          child,
        ],
      ),
    );
  }
}
