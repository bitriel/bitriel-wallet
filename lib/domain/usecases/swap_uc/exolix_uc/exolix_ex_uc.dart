import 'package:bitriel_wallet/index.dart';

abstract class ExolixExchangeUseCases {
  
  Future<void> getExolixExchangeCoin();
  Future<void> exolixSwap(SwapModel swapModel, Function confirmSwap);
  // Future<void> exolixSwapping(ExolixSwapResModel swapResModel);
  
}