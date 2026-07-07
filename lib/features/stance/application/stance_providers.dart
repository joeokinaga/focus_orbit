import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/features/stance/domain/sensor_gateway.dart';
import 'package:focus_orbit/features/stance/domain/stance_thresholds.dart';

/// data実装(Phase 1: SensorsPlusGateway)をapp/di.dartで束縛する。
final sensorGatewayProvider = Provider<SensorGateway>(
  (_) => throw UnimplementedError('app/di.dart の buildOverrides で束縛してください'),
);

/// T3 RISKS対応: 実機キャリブレーション後にoverrideで差し替え可能な注入点。
final stanceThresholdsProvider =
    Provider<StanceThresholds>((_) => StanceThresholds.defaults());

/// AD-4: Androidではベストエフォート値。
final sensorSamplingPeriodProvider =
    Provider<Duration>((_) => const Duration(milliseconds: 50));
