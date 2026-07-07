import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/app/presentation/fo_theme.dart';
import 'package:focus_orbit/features/stance/application/stance_providers.dart';
import 'package:focus_orbit/features/stance/data/sensors_plus_gateway.dart';
import 'package:focus_orbit/features/stance/presentation/sensor_debug_view.dart';

/// 【Phase 1 検証用エントリポイント】実機で:
///   flutter run -t lib/main_sensor_debug.dart
///
/// 本番の main.dart / bootstrap.dart には触れない。ここでは
/// sensorGatewayProvider のみを束縛する(preferences / roomRepository の
/// 実装が未着手でも起動できる最小構成 — デバッグ画面はそれらに依存しない)。
/// 注意: シミュレータには加速度計がないため、実機で実行すること。
void main() {
  runApp(
    ProviderScope(
      overrides: [
        sensorGatewayProvider.overrideWithValue(SensorsPlusGateway()),
      ],
      child: MaterialApp(
        title: 'Focus Orbit — Sensor Debug',
        theme: buildFocusOrbitTheme(),
        debugShowCheckedModeBanner: false,
        home: const SensorDebugView(),
      ),
    ),
  );
}
