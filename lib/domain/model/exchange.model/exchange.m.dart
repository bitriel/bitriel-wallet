import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';

class Exchange {

  String? title;
  Function getCoins;
  List<ExchangeCoinI> coins = [];

  Exchange({required this.title, required this.getCoins, this.coins = const []});

}

abstract class ExchangeCoin<T> {

  String? code;
  String? coinName;
  List<T>? network;
  String? icons;

}