# P4-V3 設計メモ(ARCHITECTURE.md v3.0 同期待ち・P4-V6でマージ)

## モチーフ最終選定(REPLAN)
Phase 4 起動時のブレインストーム(マグマ・錬金釜・デジタルグリッドキューブ)から、
実装対象を以下5モチーフへ最終確定する:
水(既存)/ 盆栽(既存)/ 砂時計(既存)/ **焚き火(新)** / **天球儀(新)**。
water/bonsai/hourglass は domain 層に既存(motif_catalog.dart)。
bonfire/celestial の MotifSkin 追加(価格・BGM資産)は P4-V4 でオーナー確認の上実施。

## domain昇格判断(P4-V3タスクの結審)
**判断: 昇格しない。PhysicsTuning / AccumulationBehavior は presentation 層に留める。**
理由: StageSimulation 本体(D25)と同じく、これは表示用の擬似物理でありアプリの
真実(状態機械・経済台帳)ではない。domain へ上げると「チューニング値がゲームプレイ
仕様である」という誤ったシグナルになる。

## 決定ログ追補(D27)
**D27(P4-V3)**: 蓄積(Rule1)を AccumulationBehavior としてモチーフ毎の Strategy に
切り出す。オービット(Rule2)・崩壊(Rule3)は StageSimulation host に残ったまま
全モチーフ共有(D23継承・変更なし)。唯一の例外として Hourglass の
AccumulationBehavior だけが共有 rings(List<OrbitRing>)から直接モートを引き抜き、
StageTransferChannel 経由で下段の砂山へ移送する(上ステージ→下ステージの物理的
連結)。この結合は Hourglass 専用であり、他モチーフは rings 引数を無視してよい。
専用の「ステージ間接続」サブシステムは新設しない — 移送というドメイン知識は
完全に Hourglass 側にカプセル化される。

## 移行計画(P4-V4)
- `WaterAccumulationBehavior` を `StageSimulation` host へ実配線し、
  `stage_simulation_test.dart` の既存17件を本クラス直接テストへ移設
  (アサーション内容は変えない・呼び出し経路のみ変更)。
- `HourglassAccumulationBehavior` を配線し、専用レンダラを実装。
- Bonsai/Bonfire/Celestial の AccumulationBehavior 実装(P4-V3では
  PhysicsTuning のみ確定・State/Behaviorは未実装 — 未登録の間は
  MotifPhysicsCatalog が水へフォールバックする設計のため安全に段階導入できる)。

## タスクグラフ更新
| id | task | done-criterion | depends |
|---|---|---|---|
| P4-V3a | 本設計のレビュー承認 | Joe承認 | V2 |
| P4-V3b | StageSimulation host への実配線(Water/Hourglassのみ) | 既存152件+新規9件=161件 GREEN | V3a |
| P4-V4 | Bonsai/Bonfire/Celestial 実装 + domain MotifSkin追加 + 専用レンダラ | 5モチーフ全て専用描画で動作 | V3b |
