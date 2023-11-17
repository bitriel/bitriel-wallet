// To parse this JSON data, do
//
// final exolixExchangeCoin = exolixExchangeCoinFromJson(jsonString);

import 'package:bitriel_wallet/index.dart';

class ExolixCoin {
  
  String? coinCode;
  String? coinName;
  String? network;
  String? networkName;
  String? networkShortName;
  String? icon;
  String? memoName;

  ExolixCoin({
    this.coinCode, 
    this.coinName, 
    this.network, 
    this.networkName, 
    this.networkShortName,
    this.icon,
    this.memoName,
  });

  ExolixCoin.fromJson(Map<String, dynamic> jsn){
    coinCode = jsn['coinCode'];
    coinName = jsn['coinName'];
    network = jsn['network'];
    networkName = jsn['networkName'];
    networkShortName = jsn['networkShortName'];
    icon = jsn['icon'];
    memoName = jsn['memoName'];
  }
  
}

class ExolixExchangeCoin {
  
  final String? code;
  final String? icon;
  final String? name;
  final List<ExolixExchangeCoinNetwork>? networks;

  ExolixExchangeCoin({
    this.code,
    this.icon,
    this.name,
    this.networks,
  });

  static String? exolixUrl = dotenv.get('EXOLIX_URL');

  factory ExolixExchangeCoin.fromRawJson(String str) => ExolixExchangeCoin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExolixExchangeCoin.fromJson(Map<String, dynamic> json) => ExolixExchangeCoin(
    code: json["code"],
    icon: exolixUrl! + json["icon"],
    name: json["name"],
    networks: json["networks"] == null ? [] : List<ExolixExchangeCoinNetwork>.from(json["networks"]!.map((x) => ExolixExchangeCoinNetwork.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "icon": icon,
    "name": name,
    "networks": networks == null ? [] : List<dynamic>.from(networks!.map((x) => x.toJson())),
  };
}

class ExolixExCoinByNetworkModel {
  
  bool? isActive = false;
  String? title = '';
  String? networkCode = '';
  String? subtitle = '';
  String? balance = '';
  String? network = '';
  Widget? image = const SizedBox();

  ExolixExCoinByNetworkModel({this.networkCode, this.image, this.title, this.subtitle, this.balance, this.network, this.isActive});
}

class ExolixExchangeCoinNetwork {

  final String? name;
  final String? network;
  final String? blockExplorer;
  final String? shortName;

  ExolixExchangeCoinNetwork({
    this.name,
    this.network,
    this.blockExplorer,
    this.shortName,
  });

  factory ExolixExchangeCoinNetwork.fromRawJson(String str) => ExolixExchangeCoinNetwork.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExolixExchangeCoinNetwork.fromJson(Map<String, dynamic> json) => ExolixExchangeCoinNetwork(
    name: json["name"],
    network: json["network"],
    blockExplorer: json["blockExplorer"],
    shortName: json["shortName"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "network": network,
    "blockExplorer": blockExplorer,
    "shortName": shortName,
  };

}
