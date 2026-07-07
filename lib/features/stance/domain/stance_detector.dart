import 'dart:math' as math;

import 'package:focus_orbit/features/stance/domain/device_stance.dart';
import 'package:focus_orbit/features/stance/domain/motion_sample.dart';
import 'package:focus_orbit/features/stance/domain/stance_thresholds.dart';

/// MotionSample列 → DeviceStance列への純粋変換。
/// 時間の根拠はサンプルのtimestampのみ(wall clock不使用=テスト決定的)。
/// SensorFailure(Streamエラー)は素通しし、呼び出し側(SessionController)が処理する。
class StanceDetector {
  StanceDetector({required this.thresholds});

  final StanceThresholds thresholds;

  Stream<DeviceStance> bind(Stream<MotionSample> samples) async* {
    final window = <MotionSample>[];
    DeviceStance? committed; // 確定済み状態
    DeviceStance? candidate; // 遷移候補
    DateTime? candidateSince; // 候補の観測開始時刻

    await for (final s in samples) {
      if (!_isFinite(s)) continue; // 破損サンプルは黙って捨てる

      // 1) 移動窓を更新しRMSを計算
      window.add(s);
      final cutoff = s.timestamp.subtract(thresholds.rmsWindow);
      window.removeWhere((e) => e.timestamp.isBefore(cutoff));
      final rms = _rms(window);

      // 2) 瞬時分類
      final instant = _classify(s, rms);

      // 3) commitDebounce持続で確定(ヒステリシス)
      if (instant.runtimeType != candidate.runtimeType) {
        candidate = instant;
        candidateSince = s.timestamp;
      }
      final sustained =
          s.timestamp.difference(candidateSince!) >= thresholds.commitDebounce;
      if (sustained && candidate.runtimeType != committed.runtimeType) {
        final next = candidate!;
        committed = next;
        yield next;
      }
    }
  }

  DeviceStance _classify(MotionSample s, double rms) {
    if (s.gravityZ < thresholds.faceUpGravityZMin) {
      return const DeviceStance.lifted(); // 傾き・持ち上げ
    }
    if (rms <= thresholds.stillRmsMax) {
      return const DeviceStance.faceUpStill();
    }
    if (rms <= thresholds.vibrationRmsMax) {
      return DeviceStance.microVibration(rms: rms);
    }
    return const DeviceStance.lifted(); // 上向きのまま激しく動く=離脱扱い
  }

  double _rms(List<MotionSample> w) {
    if (w.isEmpty) return 0;
    var sum = 0.0;
    for (final e in w) {
      sum += e.userX * e.userX + e.userY * e.userY + e.userZ * e.userZ;
    }
    return math.sqrt(sum / w.length);
  }

  bool _isFinite(MotionSample s) =>
      s.gravityZ.isFinite &&
      s.userX.isFinite &&
      s.userY.isFinite &&
      s.userZ.isFinite;
}
