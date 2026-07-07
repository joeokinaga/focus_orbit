import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:focus_orbit/features/stance/domain/device_stance.dart';
import 'package:focus_orbit/features/stance/domain/motion_sample.dart';
import 'package:focus_orbit/features/stance/domain/sensor_gateway.dart';
import 'package:focus_orbit/features/stance/domain/stance_detector.dart';
import 'package:focus_orbit/features/stance/domain/stance_thresholds.dart';

/// P1-T6: StanceDetector 境界値・ヒステリシス・異常系テスト。
///
/// 【設計原則】
/// - 境界の真実は StanceThresholds.defaults()(0.06 / 0.9 / 8.5 / 400ms / 250ms)。
///   テスト内の数値は全て defaults から導出し、値のハードコード二重管理をしない。
/// - RMS は「窓内 |user|² 平均の平方根」なので、|user| を一定値 m にすれば
///   窓が同種サンプルで満ちた時点で RMS == m(浮動小数の丸めを除く)。
///   丸めによるフレークを避けるため境界は ±eps(1e-6) の両側から攻める。
/// - 時間の根拠はサンプルの timestamp のみ(実時間・タイマー不使用=完全決定的)。
void main() {
  final t = StanceThresholds.defaults();
  const eps = 1e-6;
  const stepMs = 50;
  final epoch = DateTime.utc(2026, 1, 1);

  /// |user| = u, gravityZ = gz のサンプルを ms 時点に置く。
  MotionSample at(int ms, {double u = 0, double gz = 9.81}) => MotionSample(
        gravityX: 0,
        gravityY: 0,
        gravityZ: gz,
        userX: u,
        userY: 0,
        userZ: 0,
        timestamp: epoch.add(Duration(milliseconds: ms)),
      );

  /// fromMs から stepMs 刻みで count 個の等質サンプル列。
  List<MotionSample> run(int fromMs, int count,
          {double u = 0, double gz = 9.81}) =>
      [for (var i = 0; i < count; i++) at(fromMs + i * stepMs, u: u, gz: gz)];

  Future<List<DeviceStance>> detect(Iterable<MotionSample> samples) =>
      StanceDetector(thresholds: t)
          .bind(Stream.fromIterable(samples))
          .toList();

  // 窓(400ms)が同種サンプルで満ち、かつデバウンス(250ms)を確実に超える長さ。
  final longRun = ((t.rmsWindow + t.commitDebounce).inMilliseconds ~/ stepMs) +
      4; // 400+250=650ms → 13 + 余裕 = 17サンプル

  group('確定タイミング(commitDebounce 境界)', () {
    test('候補が ちょうど 250ms 持続した瞬間に確定する(>= は境界を含む)', () async {
      // t=0..250ms の6サンプル: 最後のサンプルで diff==commitDebounce ちょうど。
      final n = t.commitDebounce.inMilliseconds ~/ stepMs + 1;
      final out = await detect(run(0, n));
      expect(out, [const DeviceStance.faceUpStill()]);
    });

    test('持続が 250ms 未満なら何も確定しない', () async {
      final n = t.commitDebounce.inMilliseconds ~/ stepMs; // 0..200ms
      final out = await detect(run(0, n));
      expect(out, isEmpty);
    });

    test('100ms ごとに 上向き/傾き が反転し続けると永遠に確定しない(デバウンスのチャタリング耐性)', () async {
      // 傾き(gravityZ)判定は RMS 窓を経由しない瞬時分類なので、
      // デバウンス層そのものを単離して検証できる。
      final samples = <MotionSample>[
        for (var i = 0; i < 30; i++)
          at(i * 100, gz: i.isEven ? 9.81 : 8.0),
      ];
      final out = await detect(samples);
      expect(out, isEmpty);
    });

    test('高速な振幅反転(100ms周期)は RMS 窓に平滑化され、安定した microVibration 1回に確定する(窓平滑化=第1層の仕様)', () async {
      // 半分が0・半分が0.5の窓 → RMS ≈ 0.5/√2 ≈ 0.354(実測FAILで確認済みの機序)。
      // 瞬時分類は揺れず、耐チャタリングは「窓」と「デバウンス」の二層構造で成立する。
      final samples = <MotionSample>[
        for (var i = 0; i < 30; i++)
          at(i * 100, u: i.isEven ? 0.0 : 0.5),
      ];
      final out = await detect(samples);
      expect(out, hasLength(1));
      expect(
        out.single,
        isA<MicroVibration>().having(
          (m) => m.rms,
          'rms',
          allOf(greaterThan(t.stillRmsMax),
              lessThanOrEqualTo(t.vibrationRmsMax)),
        ),
      );
    });

    test('同一状態が続く限り再放出しない(2秒静止で放出はちょうど1回)', () async {
      final out = await detect(run(0, 41)); // 0..2000ms
      expect(out, hasLength(1));
      expect(out.single, const DeviceStance.faceUpStill());
    });
  });

  group('境界値: stillRmsMax (${'0.06'})', () {
    test('RMS = stillRmsMax - eps → faceUpStill(静止側)', () async {
      final out = await detect(run(0, longRun, u: t.stillRmsMax - eps));
      expect(out.last, const DeviceStance.faceUpStill());
    });

    test('RMS = stillRmsMax + eps → microVibration(振動側)', () async {
      final out = await detect(run(0, longRun, u: t.stillRmsMax + eps));
      expect(out.last, isA<MicroVibration>());
    });

    test('二進表現が正確な 0.0625 (> 0.06) は microVibration(丸め非依存の健全性確認)',
        () async {
      final out = await detect(run(0, longRun, u: 0.0625));
      expect(out.last, isA<MicroVibration>());
    });
  });

  group('境界値: vibrationRmsMax (${'0.9'})', () {
    test('RMS = vibrationRmsMax - eps → microVibration(<= は境界を含む設計)', () async {
      final out = await detect(run(0, longRun, u: t.vibrationRmsMax - eps));
      expect(out.last, isA<MicroVibration>());
    });

    test('RMS = vibrationRmsMax + eps → lifted(上向きのままでも激しい動きは離脱)', () async {
      final out = await detect(run(0, longRun, u: t.vibrationRmsMax + eps));
      expect(out.last, const DeviceStance.lifted());
    });

    test('microVibration の rms ペイロードは印加した振幅に一致する(窓充填後)', () async {
      const m = 0.5;
      final out = await detect(run(0, longRun, u: m));
      final micro = out.whereType<MicroVibration>().last;
      expect(micro.rms, closeTo(m, 1e-9));
      expect(micro.rms, lessThanOrEqualTo(t.vibrationRmsMax));
      expect(micro.rms, greaterThan(t.stillRmsMax));
    });
  });

  group('境界値: faceUpGravityZMin (${'8.5'})', () {
    test('gravityZ = 8.5 ちょうど → 上向き扱い(条件は < なので境界は非lifted)', () async {
      final out =
          await detect(run(0, longRun, gz: t.faceUpGravityZMin));
      expect(out.last, const DeviceStance.faceUpStill());
    });

    test('gravityZ = 8.5 - eps → lifted(傾き検知)', () async {
      final out =
          await detect(run(0, longRun, gz: t.faceUpGravityZMin - eps));
      expect(out.last, const DeviceStance.lifted());
    });

    test('傾き判定は RMS 判定より優先される(傾き+完全静止でも lifted)', () async {
      final out = await detect(run(0, longRun, u: 0, gz: 8.0));
      expect(out, [const DeviceStance.lifted()]);
    });
  });

  group('状態遷移とRMS移動窓(400ms)の減衰', () {
    test('microVibration → 振動停止 → 窓の入替とデバウンスを経て faceUpStill', () async {
      final vib = run(0, longRun, u: 0.5);
      final quietStart = longRun * stepMs;
      // 窓400ms + デバウンス250ms + 余裕 = 1秒の静寂
      final quiet = run(quietStart, 20, u: 0);
      final out = await detect([...vib, ...quiet]);
      expect(
        out.map((e) => e.runtimeType).toList(),
        [MicroVibration, FaceUpStill],
      );
    });

    test('lifted(持ち上げ) → 置き直し → faceUpStill に復帰する(warning復帰経路の土台)', () async {
      final lifted = run(0, longRun, gz: 5.0);
      final backStart = longRun * stepMs;
      final back = run(backStart, 20, u: 0, gz: 9.81);
      final out = await detect([...lifted, ...back]);
      expect(
        out.map((e) => e.runtimeType).toList(),
        [Lifted, FaceUpStill],
      );
    });

    test('デバウンス未満(150ms)の傾きの突発では committed が揺れない(瞬時分類の突発耐性)', () async {
      // 振幅バーストは入力停止後も RMS 窓に約400ms残留し、分類逸脱が
      // 150+400ms > commitDebounce(250ms) となって micro 確定するのが仕様。
      // よってデバウンス層の突発耐性は、窓を経由しない傾きで検証する。
      final still1 = run(0, longRun, u: 0);
      final burstStart = longRun * stepMs;
      const burstCount = 4; // 8.0でのspan = 150ms < 250ms
      final burst = run(burstStart, burstCount, gz: 8.0);
      final still2 = run(burstStart + burstCount * stepMs, 20, u: 0);
      final out = await detect([...still1, ...burst, ...still2]);
      expect(out, [const DeviceStance.faceUpStill()]); // 揺れ=放出1回のみ
    });

    test('単発の小スパイク(1サンプル, |user|=0.15)は RMS 窓に吸収され、瞬時分類すら揺らさない', () async {
      // 窓内 RMS = 0.15·√(1/n) ≈ 0.05 <= stillRmsMax(0.06):
      // 振幅チャタリングへの第1層防御(窓平滑化)の下限側の検証。
      final still1 = run(0, longRun, u: 0);
      final spikeTs = longRun * stepMs;
      final spike = at(spikeTs, u: 0.15);
      final still2 = run(spikeTs + stepMs, 20, u: 0);
      final out = await detect([...still1, spike, ...still2]);
      expect(out, [const DeviceStance.faceUpStill()]);
    });
  });

  group('異常系', () {
    test('非有限(NaN)サンプルは黙って捨てられ、判定を汚染しない', () async {
      final good = run(0, longRun, u: 0);
      final poisoned = <MotionSample>[
        ...good.take(3),
        at(3 * stepMs + 1, u: double.nan),
        at(3 * stepMs + 2, gz: double.infinity),
        ...good.skip(3),
      ];
      final out = await detect(poisoned);
      expect(out, [const DeviceStance.faceUpStill()]);
    });

    test('SensorFailure はストリームエラーとして素通しされる(契約: 検出器は握りつぶさない)',
        () async {
      final controller = StreamController<MotionSample>();
      final stream = StanceDetector(thresholds: t).bind(controller.stream);

      final expectation = expectLater(
        stream,
        emitsInOrder([
          const DeviceStance.faceUpStill(),
          emitsError(isA<SensorFailure>()),
          emitsDone,
        ]),
      );

      for (final s in run(0, longRun, u: 0)) {
        controller.add(s);
      }
      controller.addError(const SensorUnavailable());
      await controller.close();
      await expectation;
    });
  });

  group('StanceThresholds 不変条件(@Assert が factory 側で生成されている回帰確認)', () {
    test('stillRmsMax >= vibrationRmsMax は構築時に AssertionError', () {
      expect(
        () => StanceThresholds(
          faceUpGravityZMin: 8.5,
          stillRmsMax: 1.0,
          vibrationRmsMax: 0.5,
          rmsWindow: const Duration(milliseconds: 400),
          commitDebounce: const Duration(milliseconds: 250),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('faceUpGravityZMin <= 0 は構築時に AssertionError', () {
      expect(
        () => StanceThresholds(
          faceUpGravityZMin: 0,
          stillRmsMax: 0.06,
          vibrationRmsMax: 0.9,
          rmsWindow: const Duration(milliseconds: 400),
          commitDebounce: const Duration(milliseconds: 250),
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
