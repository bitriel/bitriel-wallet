import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';

class Exchange {

  String? title;
  List<ExchangeCoinI> coins = [];
  Function getCoins;
  Function rate;

  Exchange({required this.title, required this.getCoins, this.coins = const [], required this.rate});

}

abstract class ExchangeCoin<T> {

  String? code;
  String? coinName;
  List<T>? network;
  String? icons;

}