import 'package:bitriel_wallet/index.dart';

abstract class ExolixExchangeUseCases {
  
  Future<void> getExolixExchangeCoin();
  Future<void> exolixSwap(SwapModel swapModel);
  Future<void> exolixConfirmSwap(int index);
  Future<void> exolixSwapping(ExolixSwapResModel swapResModel);
  
}