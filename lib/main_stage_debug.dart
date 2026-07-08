import 'package:flutter/material.dart';

import 'package:focus_orbit/app/presentation/fo_theme.dart';
import 'package:focus_orbit/features/motif/domain/motif_catalog.dart';
import 'package:focus_orbit/features/motif/domain/motif_skin.dart';
import 'package:focus_orbit/features/motif/presentation/stage/motif_stage.dart';

/// 第四のComposition Root(P4-V1): モチーフステージ検証ハーネス。
///
/// main_sensor_debug.dart と同じ位置づけ — 本体の DI・セッション状態機械に
/// 一切触れず、ステージの物理挙動(蓄積/オービット/崩壊)だけを
/// 手動入力で観察する。releaseビルドの導線には現れない。
///
/// 実行: `flutter run -t lib/main_stage_debug.dart`
void main() {
  runApp(const StageDebugApp());
}

class StageDebugApp extends StatelessWidget {
  const StageDebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StageDebugScreen(),
    );
  }
}

class StageDebugScreen extends StatefulWidget {
  const StageDebugScreen({super.key});

  @override
  State<StageDebugScreen> createState() => _StageDebugScreenState();
}

class _StageDebugScreenState extends State<StageDebugScreen> {
  /// ライフサイクル監査: controller は内部リソースを持たない(dispose不要)。
  /// リセット時は新しいインスタンスへ差し替えるだけでよい。
  MotifStageController _controller = MotifStageController();

  MotifSkin _motif = MotifCatalog.all.first;
  double _progress = 0;
  double _intensity = 0.5;
  bool _pouring = false;

  void _reset() {
    setState(() {
      _controller = MotifStageController();
      _progress = 0;
      _pouring = false;
      _controller
        ..setIntensity(_intensity)
        ..setProgress(0)
        ..setPouring(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoPalette.ink,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MotifStage(controller: _controller, motif: _motif),
            ),
            _ControlPanel(
              motif: _motif,
              progress: _progress,
              intensity: _intensity,
              pouring: _pouring,
              onMotifChanged: (m) => setState(() => _motif = m),
              onProgressChanged: (v) {
                setState(() => _progress = v);
                _controller.setProgress(v);
              },
              onIntensityChanged: (v) {
                setState(() => _intensity = v);
                _controller.setIntensity(v);
              },
              onPouringToggled: () {
                setState(() => _pouring = !_pouring);
                _controller.setPouring(_pouring);
              },
              onShatter: () => _controller.shatter(),
              onReset: _reset,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.motif,
    required this.progress,
    required this.intensity,
    required this.pouring,
    required this.onMotifChanged,
    required this.onProgressChanged,
    required this.onIntensityChanged,
    required this.onPouringToggled,
    required this.onShatter,
    required this.onReset,
  });

  final MotifSkin motif;
  final double progress;
  final double intensity;
  final bool pouring;
  final ValueChanged<MotifSkin> onMotifChanged;
  final ValueChanged<double> onProgressChanged;
  final ValueChanged<double> onIntensityChanged;
  final VoidCallback onPouringToggled;
  final VoidCallback onShatter;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FoPalette.surface,
      padding: const EdgeInsets.all(FoSpace.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: FoSpace.sm,
            children: [
              for (final m in MotifCatalog.all)
                ChoiceChip(
                  label: Text(m.id.value,
                      style: const TextStyle(fontSize: 12)),
                  selected: m.id == motif.id,
                  onSelected: (_) => onMotifChanged(m),
                ),
            ],
          ),
          _LabeledSlider(
            label: '進捗(蓄積)',
            value: progress,
            onChanged: onProgressChanged,
          ),
          _LabeledSlider(
            label: '集中度(オービット)',
            value: intensity,
            onChanged: onIntensityChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton.icon(
                onPressed: onPouringToggled,
                icon: Icon(pouring ? Icons.pause : Icons.play_arrow),
                label: Text(pouring ? '注入停止' : '注入開始'),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: FoPalette.danger),
                onPressed: onShatter,
                icon: const Icon(Icons.vibration),
                label: const Text('揺れ!'),
              ),
              OutlinedButton(
                onPressed: onReset,
                child: const Text('リセット'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label,
              style:
                  const TextStyle(color: FoPalette.textDim, fontSize: 12)),
        ),
        Expanded(
          child: Slider(value: value, onChanged: onChanged),
        ),
      ],
    );
  }
}
