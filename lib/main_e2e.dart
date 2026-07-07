import 'package:focus_orbit/app/bootstrap.dart';
import 'package:focus_orbit/features/session/application/session_controller.dart';

/// E2E検証用エントリポイント(P3-T2)。第三の Composition Root。
///
/// 本番との差分は「報酬ポリシーのみ x100」(1分=100コイン)。
/// これによりショップ解放旅程(hourglass=120コイン)が2セッションで実行可能になる。
/// 実装型への参照はゼロ(§13 疎結合ゲート非該当) — 結線は bootstrap に委譲し、
/// ポリシー provider だけを extraOverrides で差し替える。
///
/// 【必読】このビルドで書き込んだ DB(x100コイン)は本番挙動の観測を汚すため、
/// E2E 完了後は必ずアプリをアンインストールしてから通常 main で再インストールする
/// (E2E チェックリスト項目 E1)。
Future<void> main() => bootstrap(
      extraOverrides: [
        rewardPolicyProvider.overrideWithValue((d) => d.inMinutes * 100),
      ],
    );
