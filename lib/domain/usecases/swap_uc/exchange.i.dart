abstract class ExchangeCoinI {

  // set setContext(BuildContext ctx);

  // void initExchangeState();

  // void onDropDownChange(int? index);

  // // void changeExchangeState();
  // Future<void> getExchangeCoins();

  // Future<void> getTrxHistory();

  String? code;
  String? coinName;
  String? network;
  String? networkName;
  String? shortName;
  String? icon;
  
  Future<List<ExchangeCoinI>> getCoins();

}