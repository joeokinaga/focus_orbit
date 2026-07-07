/// ゼロコストの型付きID(Dart 3.3+ extension type)。
/// 素のStringの取り違えをコンパイルエラーにする。
extension type const SessionId(String value) {}

extension type const MotifId(String value) {}

/// v1.1(T8): マルチ同期の部屋ID。D19: Phase 0では部屋=モチーフ単位。
extension type const RoomId(String value) {}
