import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

import 'package:focus_orbit/features/stance/domain/motion_sample.dart';
import 'package:focus_orbit/features/stance/domain/sensor_gateway.dart';

/// AD-4: sensors_plus 7系の2系統ストリームを MotionSample に融合する data 層実装。
/// - accelerometerEventStream    : 重力込み(姿勢判定用 gravity*)
/// - userAccelerometerEventStream: 重力除去(振動RMS用 user*)
///
/// 【契約遵守(SensorGateway)】
/// (1) 非broadcast: 呼び出しごとに独立した単一購読ストリームを返す
/// (2) センサー非搭載・権限拒否などのネイティブエラーは SensorFailure に翻訳し
///     Streamエラーとして流す(生の PlatformException を上層に漏らさない)
/// (3) samplingPeriod はベストエフォートで両系統に指定
///
/// 【ライフサイクル】購読ペア:
///   _graviySub/_userSub : onListen で生成 / onCancel で解放(リーク経路なし)
///
/// 【D20】時刻は注入(既定 DateTime.now)。StanceDetector はサンプルの
/// timestamp のみを時間根拠にするため、ここが唯一の実時間の入口。
final class SensorsPlusGateway implements SensorGateway {
  SensorsPlusGateway({DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  @override
  Stream<MotionSample> motionSamples({required Duration samplingPeriod}) {
    late final StreamController<MotionSample> controller;
    StreamSubscription<AccelerometerEvent>? gravitySub;
    StreamSubscription<UserAccelerometerEvent>? userSub;

    AccelerometerEvent? latestGravity;

    void forwardError(Object error, StackTrace stackTrace) {
      // 契約(2): ネイティブ層の失敗は SensorFailure に正規化。
      // (Android実機でセンサー欠品時に onError が来る — sensors_plus README)
      if (!controller.isClosed) {
        controller.addError(const SensorUnavailable(), stackTrace);
      }
    }

    // 発火は user(振動)系を駆動源にする: RMS窓の鮮度が判定精度を支配するため。
    void onUser(UserAccelerometerEvent e) {
      final g = latestGravity;
      if (g == null || controller.isClosed) return; // 両系統が揃うまで沈黙
      controller.add(MotionSample(
        gravityX: g.x,
        gravityY: g.y,
        gravityZ: g.z,
        userX: e.x,
        userY: e.y,
        userZ: e.z,
        timestamp: _now(),
      ));
    }

    controller = StreamController<MotionSample>(
      onListen: () {
        gravitySub = accelerometerEventStream(samplingPeriod: samplingPeriod)
            .listen((e) => latestGravity = e, onError: forwardError);
        userSub = userAccelerometerEventStream(samplingPeriod: samplingPeriod)
            .listen(onUser, onError: forwardError);
      },
      onPause: () {
        gravitySub?.pause();
        userSub?.pause();
      },
      onResume: () {
        gravitySub?.resume();
        userSub?.resume();
      },
      onCancel: () async {
        // 生成の逆順で解放
        await userSub?.cancel();
        userSub = null;
        await gravitySub?.cancel();
        gravitySub = null;
      },
    );
    return controller.stream;
  }
}
