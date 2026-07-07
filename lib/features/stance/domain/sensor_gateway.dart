import 'package:focus_orbit/core/domain/app_failure.dart';
import 'package:focus_orbit/features/stance/domain/motion_sample.dart';

/// センサーへの抽象窓口。実装(data層, Phase 1)がsensors_plusをこの契約に翻訳する。
/// 契約:
/// - broadcastでなくてよい(購読者は状態管理層の1本のみ)
/// - センサー非搭載/権限拒否は SensorFailure をStreamエラーとして流す
/// - samplingPeriodはベストエフォート(AD-4: Androidは保証なし)
abstract interface class SensorGateway {
  Stream<MotionSample> motionSamples({required Duration samplingPeriod});
}

sealed class SensorFailure implements AppFailure, Exception {
  const SensorFailure();
}

final class SensorUnavailable extends SensorFailure {
  const SensorUnavailable();
}

final class SensorPermissionDenied extends SensorFailure {
  const SensorPermissionDenied();
}
