import 'package:bitriel_wallet/index.dart';

abstract class LetsExchangeUseCases {
  Future<void> getLetsExchangeCoin();
  Future<void> swap();
  Future<void> confirmSwap(int index);
  Future<void> swapping(SwapResModel swapResModel);
}