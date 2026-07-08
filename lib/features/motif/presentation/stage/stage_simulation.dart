import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show Offset;

/// Phase 4 (P4-V1): モチーフステージの物理シミュレーション。
///
/// 【層規則】presentation 層の純 Dart クラス(Flutter Widget 非依存)。
/// 状態機械・台帳など「アプリの真実」には一切関与しない — これは
/// 表示用の擬似物理であり、入力(fill / intensity / pouring / shatter)は
/// すべて呼び出し側(MotifStageController 経由)から与えられる。
///
/// 【決定性】固定タイムステップ(1/60s)+シード付き乱数。同じシードに
/// 同じ呼び出し列を与えれば状態はビット単位で一致する(テストで固定)。
///
/// 【座標系(3フレーム・レンダラはこの規約で写像する)】
///  (a) 表面/容器フレーム: x∈[0,1]=容器内幅, y∈[0,1]=容器内高(y=0が上端)。
///      droplets / bubbles / surfaceHeights はこのフレーム。
///  (b) オービットフレーム: 原点=オービット中心の正方形単位系
///      (1.0 = 画面短辺相当)。rings の半径と freedMotes の位置はこちら。
///  (c) heights は「静止水面からの偏差」(容器内高=1.0 単位、±0.1 程度)。
class StageSimulation {
  StageSimulation({
    this.tuning = const StagePhysicsTuning(),
    int columnCount = 48,
    int seed = 1207,
  })  : assert(columnCount >= 8),
        _heights = Float64List(columnCount),
        _velocities = Float64List(columnCount),
        _rng = math.Random(seed) {
    _rings = [
      OrbitRing(threshold: 0.0, radiusUnit: 0.20, moteTarget: 10, speedSign: 1),
      OrbitRing(
          threshold: 0.35, radiusUnit: 0.27, moteTarget: 14, speedSign: -1),
      OrbitRing(threshold: 0.7, radiusUnit: 0.34, moteTarget: 18, speedSign: 1),
    ];
  }

  final StagePhysicsTuning tuning;
  final math.Random _rng;

  // ---- 固定タイムステップ制御 -------------------------------------------
  static const double _stepSeconds = 1 / 60;
  static const double _maxFrameDt = 0.1; // 復帰直後の巨大dtは捨てる(追い付き爆発防止)
  static const int _maxSubSteps = 6;
  Duration? _lastElapsed;
  double _accumulator = 0;
  double _simTime = 0;

  // ---- 粒子予算(混雑しても破綻しない) -----------------------------------
  static const int maxDroplets = 40;
  static const int maxBubbles = 60;
  static const int maxFreedMotes = 240;

  // ---- 蓄積(共通ルール1) --------------------------------------------------
  double _fill = 0;
  double _targetFill = 0;
  bool _pouring = false;
  double _dropletTimer = 0;
  double _bubbleTimer = 0;

  /// 蓄積量 0..1(セッション進捗の緩和追従値)
  double get fill => _fill;
  bool get pouring => _pouring;

  /// 静止水面の y 位置(容器フレーム・上端=0)。
  double get surfaceLevelY => 1.0 - (0.06 + 0.86 * _fill);

  // ---- 表面(1次元バネ格子) ------------------------------------------------
  final Float64List _heights;
  final Float64List _velocities;

  /// 静止面からの偏差(読み取り専用として扱うこと)
  List<double> get surfaceHeights => _heights;

  // ---- 粒子 ---------------------------------------------------------------
  final List<StageDroplet> _droplets = [];
  final List<StageBubble> _bubbles = [];
  List<StageDroplet> get droplets => _droplets;
  List<StageBubble> get bubbles => _bubbles;

  // ---- オービット(共通ルール2)と崩壊(共通ルール3) -----------------------
  late final List<OrbitRing> _rings;
  final List<FreedMote> _freedMotes = [];
  double _intensity = 0;

  List<OrbitRing> get rings => _rings;
  List<FreedMote> get freedMotes => _freedMotes;
  double get intensity => _intensity;
  int get totalMoteCount =>
      _rings.fold(0, (sum, r) => sum + r.moteAngles.length);

  // ==========================================================================
  // 入力(すべて呼び出し側の責務。sim は自分から状態を推測しない)
  // ==========================================================================

  /// セッション進捗(0..1)。範囲外はクランプ。
  void setTargetFill(double value) {
    _targetFill = value.clamp(0.0, 1.0).toDouble();
  }

  /// 集中度(0..1)。オービットの速度・輪の数を支配する。
  void setIntensity(double value) {
    _intensity = value.clamp(0.0, 1.0).toDouble();
  }

  /// running 中 true(滴が注がれる)。warning/idle では false。
  void setPouring(bool active) {
    _pouring = active;
  }

  /// 崩壊(共通ルール3): 溜まったものとオービットを物理的に粉砕する。
  /// [impulse] 1.0 = 標準の揺れ。将来は加速度センサの実測振幅を写像する。
  void shatter({double impulse = 1.0}) {
    final imp = impulse.clamp(0.2, 3.0).toDouble();

    // (1) オービットの全モートを解放粒子へ変換(接線速度+ジッタ+重力落下)
    for (final ring in _rings) {
      final speed = (0.35 + 0.55 * imp) * ring.speedSign;
      for (final angle in ring.moteAngles) {
        if (_freedMotes.length >= maxFreedMotes) break;
        final radial = Offset(math.cos(angle), math.sin(angle));
        final tangent = Offset(-radial.dy, radial.dx) * speed;
        final jitter = Offset(
          (_rng.nextDouble() - 0.5) * 0.3 * imp,
          (_rng.nextDouble() - 0.5) * 0.3 * imp,
        );
        _freedMotes.add(FreedMote(
          position: radial * ring.radiusUnit,
          velocity: tangent + jitter,
          life: 0.9 + _rng.nextDouble() * 0.6,
        ));
      }
      ring.moteAngles.clear();
      ring.respawnTimer = 0;
    }

    // (2) 水面へ衝撃(全列にランダム速度 — 激しいスロッシング)
    for (var i = 0; i < _velocities.length; i++) {
      _velocities[i] +=
          (_rng.nextDouble() * 2 - 1) * tuning.shatterSurfaceShock * imp;
    }

    // (3) 落下中の滴を横へ吹き飛ばす
    for (final d in _droplets) {
      d.vx += (_rng.nextDouble() - 0.5) * 1.2 * imp;
      d.vy -= _rng.nextDouble() * 0.4 * imp;
    }
  }

  /// 全状態を初期状態へ戻す(P4-V2: 新セッション開始時に呼ぶ)。
  /// 前セッションの蓄積・波・粒子・飛散モートを持ち越さないための命令。
  /// 【注意】乱数列は再シードしない — 同一シード・同一呼び出し列
  /// (reset を含む)に対する決定性は保たれる。時間基準(_lastElapsed)は
  /// null へ戻し、次の advance が新しい Ticker の基準点を確立する
  /// (アンマウント→再マウントで Ticker が作り直されても安全)。
  void reset() {
    _fill = 0;
    _targetFill = 0;
    _pouring = false;
    _intensity = 0;
    _dropletTimer = 0;
    _bubbleTimer = 0;
    for (var i = 0; i < _heights.length; i++) {
      _heights[i] = 0;
      _velocities[i] = 0;
    }
    _droplets.clear();
    _bubbles.clear();
    _freedMotes.clear();
    for (final ring in _rings) {
      ring.moteAngles.clear();
      ring.respawnTimer = 0;
    }
    _simTime = 0;
    _accumulator = 0;
    _lastElapsed = null;
  }

  // ==========================================================================
  // 時間発展
  // ==========================================================================

  /// Ticker の絶対経過時間を渡す。内部で固定ステップに分割する。
  void advance(Duration elapsed) {
    if (_lastElapsed == null) {
      _lastElapsed = elapsed;
      return;
    }
    var dt = (elapsed - _lastElapsed!).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    if (dt <= 0) return; // 単調でないTickは無視
    if (dt > _maxFrameDt) dt = _maxFrameDt;

    _accumulator += dt;
    var steps = 0;
    while (_accumulator >= _stepSeconds && steps < _maxSubSteps) {
      _step(_stepSeconds);
      _accumulator -= _stepSeconds;
      steps++;
    }
    if (steps == _maxSubSteps) _accumulator = 0; // 残債は捨てる(死のスパイラル防止)
  }

  void _step(double h) {
    _simTime += h;
    _stepFill(h);
    _stepSurface(h);
    _stepDroplets(h);
    _stepBubbles(h);
    _stepOrbit(h);
    _stepFreedMotes(h);
  }

  // ---- 蓄積: 進捗へゆっくり追従(「注がれて満ちていく」重量感) -------------
  void _stepFill(double h) {
    final rate = (tuning.fillEaseRate * h).clamp(0.0, 1.0).toDouble();
    _fill += (_targetFill - _fill) * rate;
    if ((_targetFill - _fill).abs() < 1e-4) _fill = _targetFill;
  }

  // ---- 表面: 半陰的オイラーのバネ格子(隣接伝播でさざ波が走る) -------------
  void _stepSurface(double h) {
    final n = _heights.length;
    for (var i = 0; i < n; i++) {
      final left = _heights[i > 0 ? i - 1 : i];
      final right = _heights[i < n - 1 ? i + 1 : i];
      final laplacian = left + right - 2 * _heights[i];
      final accel = -tuning.surfaceSpringK * _heights[i] +
          tuning.surfaceSpread * laplacian -
          tuning.surfaceDamping * _velocities[i];
      _velocities[i] += accel * h;
    }
    for (var i = 0; i < n; i++) {
      _heights[i] += _velocities[i] * h;
    }
  }

  // ---- 滴: 上から注がれ、着水で表面を叩く ---------------------------------
  void _stepDroplets(double h) {
    if (_pouring && _fill < 0.999) {
      _dropletTimer -= h;
      if (_dropletTimer <= 0 && _droplets.length < maxDroplets) {
        _dropletTimer = tuning.dropletBaseInterval /
            (0.6 + 0.8 * _intensity); // 集中が深いほど流量が増える
        _droplets.add(StageDroplet(
          x: 0.5 + (_rng.nextDouble() - 0.5) * 0.36,
          y: -0.06,
          vx: 0,
          vy: 0.15,
        ));
      }
    }

    final surfaceY = surfaceLevelY;
    for (var i = _droplets.length - 1; i >= 0; i--) {
      final d = _droplets[i];
      d.vy += tuning.dropletGravity * h;
      d.x += d.vx * h;
      d.y += d.vy * h;

      final outOfBounds = d.x < -0.2 || d.x > 1.2 || d.y > 1.2;
      if (d.y >= surfaceY && !outOfBounds) {
        _splashAt(d.x, d.vy);
        _droplets.removeAt(i);
      } else if (outOfBounds) {
        _droplets.removeAt(i);
      }
    }
  }

  /// 着水: 最寄り列を叩き下げ、隣列に半分伝える(質量感のある波紋の種)。
  void _splashAt(double x, double impactSpeed) {
    final n = _velocities.length;
    final idx = (x.clamp(0.0, 1.0) * (n - 1)).round();
    final kick = tuning.splashKick * impactSpeed;
    _velocities[idx] -= kick;
    if (idx > 0) _velocities[idx - 1] -= kick * 0.5;
    if (idx < n - 1) _velocities[idx + 1] -= kick * 0.5;

    // ときどき着水地点から泡が生まれる
    if (_bubbles.length < maxBubbles && _rng.nextDouble() < 0.35) {
      _spawnBubble(x: x);
    }
  }

  // ---- 泡: 浮力で立ち上り、水面で弾ける ------------------------------------
  void _stepBubbles(double h) {
    if (tuning.buoyancy > 0 && _fill > 0.12) {
      _bubbleTimer -= h;
      if (_bubbleTimer <= 0 && _bubbles.length < maxBubbles) {
        _bubbleTimer = 0.9 / (0.3 + _fill);
        _spawnBubble(x: _rng.nextDouble());
      }
    }

    final surfaceY = surfaceLevelY;
    for (var i = _bubbles.length - 1; i >= 0; i--) {
      final b = _bubbles[i];
      b.y -= b.speed * h;
      b.x += math.sin(b.wobblePhase + _simTime * 3.0) * 0.02 * h;

      if (b.y <= surfaceY + 0.01) {
        // 弾ける: 直上の列を小さく突き上げる
        final n = _velocities.length;
        final idx = (b.x.clamp(0.0, 1.0) * (n - 1)).round();
        _velocities[idx] += tuning.bubblePopKick;
        _bubbles.removeAt(i);
      }
    }
  }

  void _spawnBubble({required double x}) {
    _bubbles.add(StageBubble(
      x: x.clamp(0.02, 0.98).toDouble(),
      y: 0.97,
      radius: 0.006 + _rng.nextDouble() * 0.010,
      wobblePhase: _rng.nextDouble() * math.pi * 2,
      speed: tuning.buoyancy * (0.6 + 0.8 * _rng.nextDouble()),
    ));
  }

  // ---- オービット: 集中度が速度と輪の数を支配。崩壊後は徐々に再生する ------
  void _stepOrbit(double h) {
    final angularSpeed = math.pi *
        2 *
        tuning.orbitBaseRevPerSec *
        (0.35 + tuning.orbitIntensityGain * _intensity);

    for (final ring in _rings) {
      final active = _intensity >= ring.threshold;

      // 回転
      for (var i = 0; i < ring.moteAngles.length; i++) {
        ring.moteAngles[i] = (ring.moteAngles[i] +
                angularSpeed * ring.speedSign * (1 + 0.2 * ring.radiusUnit) * h)
            .remainder(math.pi * 2);
      }

      // 再生 / 減衰(1個ずつ — 「崩壊からの回復」を目に見せる)
      ring.respawnTimer -= h;
      if (ring.respawnTimer <= 0) {
        ring.respawnTimer = tuning.moteRespawnInterval;
        if (active && ring.moteAngles.length < ring.moteTarget) {
          ring.moteAngles.add(_rng.nextDouble() * math.pi * 2);
        } else if (!active && ring.moteAngles.isNotEmpty) {
          ring.moteAngles.removeLast();
        }
      }
    }
  }

  // ---- 解放粒子: 重力+抗力で散り、寿命で消える -----------------------------
  void _stepFreedMotes(double h) {
    for (var i = _freedMotes.length - 1; i >= 0; i--) {
      final m = _freedMotes[i];
      m.velocity = Offset(
        m.velocity.dx * (1 - tuning.freedDrag * h),
        m.velocity.dy * (1 - tuning.freedDrag * h) + tuning.freedGravity * h,
      );
      m.position += m.velocity * h;
      m.life -= h;
      if (m.life <= 0 || m.position.dy > 1.4) {
        _freedMotes.removeAt(i);
      }
    }
  }
}

// =============================================================================
// チューニング(モチーフ毎の物理個性はこの定数で表現する — P4-V3で登録簿化)
// =============================================================================

/// 表示用擬似物理のパラメータ。全て正の実数(半陰的オイラー・1/60s で安定)。
class StagePhysicsTuning {
  const StagePhysicsTuning({
    this.surfaceSpringK = 30,
    this.surfaceSpread = 30,
    this.surfaceDamping = 3.0,
    this.fillEaseRate = 0.6,
    this.dropletBaseInterval = 1.1,
    this.dropletGravity = 1.6,
    this.splashKick = 0.28,
    this.buoyancy = 0.10,
    this.bubblePopKick = 0.05,
    this.orbitBaseRevPerSec = 0.10,
    this.orbitIntensityGain = 2.4,
    this.moteRespawnInterval = 0.35,
    this.shatterSurfaceShock = 0.45,
    this.freedGravity = 0.5,
    this.freedDrag = 0.6,
  });

  final double surfaceSpringK; // 静止面へ引き戻すバネ
  final double surfaceSpread; // 隣接列への伝播(波の速さ)
  final double surfaceDamping; // 減衰(粘性)
  final double fillEaseRate; // 進捗への追従率(/s)
  final double dropletBaseInterval; // 滴の基本生成間隔(s)
  final double dropletGravity; // 滴の落下加速度(容器高/s^2)
  final double splashKick; // 着水の突き下げ係数
  final double buoyancy; // 泡の上昇速度基準(0=泡なしモチーフ)
  final double bubblePopKick; // 泡が弾ける突き上げ
  final double orbitBaseRevPerSec; // オービット基本回転数
  final double orbitIntensityGain; // 集中度→速度の利得
  final double moteRespawnInterval; // モート再生間隔(s)
  final double shatterSurfaceShock; // 崩壊時の水面衝撃
  final double freedGravity; // 解放粒子の重力
  final double freedDrag; // 解放粒子の空気抵抗
}

// =============================================================================
// 粒子・軌道のデータ(sim 内部で可変、レンダラは読み取りのみ)
// =============================================================================

/// 注がれる滴(容器フレーム)。
class StageDroplet {
  StageDroplet(
      {required this.x, required this.y, required this.vx, required this.vy});
  double x, y, vx, vy;
}

/// 水中の泡(容器フレーム)。
class StageBubble {
  StageBubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.wobblePhase,
    required this.speed,
  });
  double x, y;
  final double radius;
  final double wobblePhase;
  double speed;
}

/// 光の輪1本。moteAngles の各要素が輪上の光点。
class OrbitRing {
  OrbitRing({
    required this.threshold,
    required this.radiusUnit,
    required this.moteTarget,
    required this.speedSign,
  });

  /// この輪が現れる集中度のしきい値
  final double threshold;

  /// 半径(オービットフレーム・1.0=画面短辺)
  final double radiusUnit;

  /// 満員時のモート数
  final int moteTarget;

  /// 回転方向(+1 / -1)
  final int speedSign;

  final List<double> moteAngles = [];
  double respawnTimer = 0;
}

/// 崩壊で解放されたモート(オービットフレーム・中心原点)。
class FreedMote {
  FreedMote(
      {required this.position, required this.velocity, required this.life});
  Offset position;
  Offset velocity;
  double life;
}
