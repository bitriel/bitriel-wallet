// To parse this JSON data, do
//
// final letsExchangeCoin = letsExchangeCoinFromJson(jsonString);

import 'package:bitriel_wallet/index.dart';

class LetsExchangeCoin {
  
  final String? code;
  final int? disabled;
  final String? icon;
  final int? hasExtra;
  final dynamic extraName;
  final String? name;
  final String? minAmount;
  final List<LetsExchangeCoinNetwork>? networks;

  LetsExchangeCoin({
    this.code,
    this.disabled,
    this.icon,
    this.hasExtra,
    this.extraName,
    this.name,
    this.minAmount,
    this.networks,
  });

  factory LetsExchangeCoin.fromRawJson(String str) => LetsExchangeCoin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LetsExchangeCoin.fromJson(Map<String, dynamic> json) => LetsExchangeCoin(
    code: json["code"],
    disabled: json["disabled"],
    icon: json["icon"],
    hasExtra: json["has_extra"],
    extraName: json["extra_name"],
    name: json["name"],
    minAmount: json["min_amount"],
    networks: json["networks"] == null ? [] : List<LetsExchangeCoinNetwork>.from(json["networks"]!.map((x) => LetsExchangeCoinNetwork.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "disabled": disabled,
    "icon": icon,
    "has_extra": hasExtra,
    "extra_name": extraName,
    "name": name,
    "min_amount": minAmount,
    "networks": networks == null ? [] : List<dynamic>.from(networks!.map((x) => x.toJson())),
  };
}

class LetsExCoinByNetworkModel {
  
  bool? isActive = false;
  String? title = '';
  String? networkCode = '';
  String? subtitle = '';
  String? balance = '';
  String? network = '';
  Widget? image = const SizedBox();

  LetsExCoinByNetworkModel({this.networkCode, this.image, this.title, this.subtitle, this.balance, this.network, this.isActive});
}

class LetsExchangeCoinNetwork {

  final String? name;
  final String? code;
  final String? explorerUrl;
  final String? extraName;
  final int? hasExtra;
  final String? contractAddress;

  LetsExchangeCoinNetwork({
    this.name,
    this.code,
    this.explorerUrl,
    this.extraName,
    this.hasExtra,
    this.contractAddress,
  });

  factory LetsExchangeCoinNetwork.fromRawJson(String str) => LetsExchangeCoinNetwork.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LetsExchangeCoinNetwork.fromJson(Map<String, dynamic> json) => LetsExchangeCoinNetwork(
    name: json["name"],
    code: json["code"],
    explorerUrl: json["explorer_url"],
    extraName: json["extra_name"],
    hasExtra: json["has_extra"],
    contractAddress: json["contract_address"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "explorer_url": explorerUrl,
    "extra_name": extraName,
    "has_extra": hasExtra,
    "contract_address": contractAddress,
  };

}
