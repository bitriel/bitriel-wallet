import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';

class Exchange {

  String? title;
  List<ExchangeCoinI> coins = [];
  List<ExChangeTxI> tx = [];
  Function getCoins;
  Function rate;
  Function swap;

  Exchange({
    required this.title, 
    required this.getCoins, 
    this.coins = const [], 
    required this.rate,
    required this.swap
  });

}