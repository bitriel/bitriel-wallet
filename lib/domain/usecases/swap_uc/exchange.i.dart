import 'package:bitriel_wallet/index.dart';

abstract class ExchangeCoinI {

  String? code;
  String? coinName;
  String? network;
  String? networkName;
  String? shortName;
  String? icon;
  
  Future<List<ExchangeCoinI>> getCoins();

  Future<String> rate(ExchangeCoinI coin1, ExchangeCoinI coin2, SwapModel swapModel);

}

abstract class ExChangeTxI {

  String? id;
  String? coinFrom;
  String? coinFromNetwork;
  String? coinFromNetworkName;
  String? coinFromIcon;

  String? coinTo;
  String? coinToNetwork;
  String? coinToNetworkName;
  String? coinToIcon;

  String? depositAddr;
  String? depositAmt;
  String? withdrawalAddress;
  String? createdAt;
  ValueNotifier<String>? status;
  String? withdrawalAmount;
  
}