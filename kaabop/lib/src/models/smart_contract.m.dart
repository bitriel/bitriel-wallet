import 'package:wallet_apps/src/models/asset_m.dart';

class SmartContractModel {
  String id;
  String chainDecimal;
  String symbol;
  String balance;
  String logo;
  String type;
  String org;
  Market marketData;
  String marketPrice;
  String change24h;
  bool isContain;
  List<List<double>> lineChartData;

  SmartContractModel({
    this.id,
    this.chainDecimal,
    this.symbol,
    this.balance,
    this.logo,
    this.type,
    this.org,
    this.marketData,
    this.marketPrice,
    this.change24h,
    this.isContain,
    this.lineChartData,
  });
  
  void init(){
    
  }
}
