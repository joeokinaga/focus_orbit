/// 全ドメイン失敗型の基底マーカー。
/// 各featureのsealed失敗型(SensorFailure / StorageFailure /
/// PresenceFailure / EconomyFailure)がimplementsし、
/// 横断的なエラー表示・ロギングの接点を1つにする。
abstract interface class AppFailure {}
