import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';

class Exchange<T> {
  
  String? storageKey;
  String? title;
  List<ExchangeCoinI> coins = [];
  List<T> tx = [];
  Function getCoins;
  Function rate;
  Function swap;
  T? instance;

  Exchange({
    required this.storageKey,
    required this.title, 
    required this.getCoins, 
    this.coins = const [], 
    required this.rate,
    required this.swap,
    required this.instance
  });

}