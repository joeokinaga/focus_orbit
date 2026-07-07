// 結線層 smoke test(P3-T3 第1号)。
// 目的: buildOverrides(di.dart)→ProviderScope→FocusOrbitApp の結線が
// UnimplementedError なしに初回フレームへ到達することの固定。
// 注意: watch系ストリームは閉じないため pumpAndSettle は使わない(ハング要因)。

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:focus_orbit/app/di.dart';
import 'package:focus_orbit/app/presentation/focus_orbit_app.dart';
import 'package:focus_orbit/features/economy/data/drift/drift_preferences_repository.dart';
import 'package:focus_orbit/features/economy/data/drift/economy_database.dart';
import 'package:focus_orbit/features/presence/data/solo_room_repository.dart';
import 'package:focus_orbit/features/stance/domain/motion_sample.dart';
import 'package:focus_orbit/features/stance/domain/sensor_gateway.dart';

/// サンプルを一切流さない無音センサー(idle画面の描画に入力は不要)。
final class _SilentSensorGateway implements SensorGateway {
  @override
  Stream<MotionSample> motionSamples({required Duration samplingPeriod}) =>
      const Stream<MotionSample>.empty();
}

void main() {
  testWidgets('結線smoke: buildOverrides経由でFocusOrbitAppが初回フレームに到達する',
      (WidgetTester tester) async {
    final db = EconomyDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: buildOverrides(
          sensorGateway: _SilentSensorGateway(),
          preferences: DriftPreferencesRepository(db),
          roomRepository: SoloRoomRepository(),
        ),
        child: const FocusOrbitApp(),
      ),
    );
    // 初期非同期(初回起動のEconomyState.initial()射影など)を有限回だけ進める。
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(tester.takeException(), isNull); // UnimplementedError等が出ていない
  });
}