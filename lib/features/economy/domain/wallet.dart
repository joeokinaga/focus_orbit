import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';

@freezed
abstract class Wallet with _$Wallet {
  const Wallet._();

  @Assert('balance >= 0', '負残高は構築不可能(最終防衛線)')
  const factory Wallet({required int balance}) = _Wallet;

  factory Wallet.empty() => const Wallet(balance: 0);

  bool canAfford(int amount) => balance >= amount;
}
