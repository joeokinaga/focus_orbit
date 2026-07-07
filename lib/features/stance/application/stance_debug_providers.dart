import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/features/stance/application/stance_providers.dart';
import 'package:focus_orbit/features/stance/domain/device_stance.dart';
import 'package:focus_orbit/features/stance/domain/motion_sample.dart';
import 'package:focus_orbit/features/stance/domain/stance_detector.dart';

/// 【デバッグ専用】生の MotionSample を画面に流す。
/// autoDispose: デバッグ画面を閉じたらセンサー購読も止まる(電池保護)。
/// 本番セッション経路(SessionController)はこれを使わない。
final motionSampleDebugProvider =
    StreamProvider.autoDispose<MotionSample>((ref) {
  final gateway = ref.watch(sensorGatewayProvider);
  final period = ref.watch(sensorSamplingPeriodProvider);
  return gateway.motionSamples(samplingPeriod: period);
});

/// 【デバッグ専用】確定済み DeviceStance(ヒステリシス通過後)を画面に流す。
/// 生サンプルとは独立した購読(SensorGateway契約(1): 呼び出しごとに独立ストリーム)。
final stanceDebugProvider = StreamProvider.autoDispose<DeviceStance>((ref) {
  final gateway = ref.watch(sensorGatewayProvider);
  final period = ref.watch(sensorSamplingPeriodProvider);
  final detector =
      StanceDetector(thresholds: ref.watch(stanceThresholdsProvider));
  return detector.bind(gateway.motionSamples(samplingPeriod: period));
});
