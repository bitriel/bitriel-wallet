import 'package:bitriel_wallet/index.dart';

abstract class ExolixExchangeUseCases {
  Future<void> getExolixExchangeCoin();
  void onDeleteTxt();
  void formatDouble(String value);
  Future<void> exolixSwap();
  Future<void> exolixConfirmSwap(int index);
  Future<void> exolixSwapping(ExolixSwapResModel swapResModel);
}