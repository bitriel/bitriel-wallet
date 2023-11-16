import 'package:bitriel_wallet/index.dart';

abstract class LetsExchangeUseCases {
  Future<void> getLetsExchangeCoin();
  Future<void> letsExchangeSwap(SwapModel swapModel);
  Future<void> confirmSwap(int index);
  Future<void> swapping(SwapResModel swapResModel);
}