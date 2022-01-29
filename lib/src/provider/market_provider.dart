import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';
import 'package:wallet_apps/src/provider/transaction_p.dart';

import '../../index.dart';

class MarketProvider with ChangeNotifier {

  List<String> id = [
    'kiwigo',
    'ethereum',
    'binancecoin',
    'polkadot',
    'bitcoin',
    'attendant',
    'selendra',
  ];

  List<Map<String, dynamic>> sortDataMarket = [];

  Market? parseMarketData(List<Map<String, dynamic>> responseBody) {
    Market? data;

    for (var i in responseBody) {
      data = Market.fromJson(i);
    }
    return data;
  }

  Future<List<List<double>>?> fetchLineChartData(String id) async {
    List<List<double>>? prices;
    final res = await http.get(Uri.parse( 'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=1'));

    if (res.statusCode == 200) {
      final data = await jsonDecode(res.body);

      CryptoData mData = CryptoData.fromJson(data);

      prices = mData.prices;
    }

    return prices ?? null;
  }

  Future? findMarketPrice(String asset) async {
    String? marketPrice;
    final contract = ContractProvider();
    switch (asset) {
      case 'KGO':
        marketPrice = contract.listContract[2].marketPrice;
        break;
      case 'ETH':
        marketPrice = contract.listContract[3].marketPrice;
        break;
      case 'BNB':
        marketPrice = contract.listContract[4].marketPrice;
        break;
      case 'BTC':
        marketPrice = contract.listContract[6].marketPrice;
        break;
    }
    return marketPrice;
  }

  Future<void> fetchTokenMarketPrice(BuildContext context) async {

    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);
    sortDataMarket.clear();

    for (int i = 0; i < id.length; i++) {
      try {

        final response = await http.get(Uri.parse('${AppConfig.coingeckoBaseUrl}${id[i]}'));

        dynamic jsonResponse = await List<Map<String, dynamic>>.from(await json.decode(response.body));
        print("index $i");
        print("${id[i]} ${response.body.toString()}");
        if (response.statusCode == 200 && jsonResponse.isNotEmpty) {
          // sortDataMarket.addAll({jsonResponse[0]});

          final lineChartData = await fetchLineChartData(id[i]);
          
          final res = parseMarketData(jsonResponse);

          if (i == 0) {
            contract.setkiwigoMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 1) {
            contract.setEtherMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 2) {
            contract.setBnbMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h'].toStringAsFixed(2).toString(),
            );
          } else if (i == 3) {
            contract.setDotMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h'].toStringAsFixed(2).toString(),
            );
          } else if (i == 4) {
            await api.setBtcMarket(
              res!,
              lineChartData!,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h'].toStringAsFixed(2).toString(),
              context: context
            );
          }
        }

        notifyListeners();
      } catch (e) {
        print("error market $e");
      }
    }
    
    Provider.of<TrxProvider>(context, listen: false).totalAssetValue(context: context);

    // Sort Market Price
    // Map<String, dynamic> tmp = {};
    // for (int i = 0; i < sortDataMarket.length; i++) {
    //   for (int j = i + 1; j < sortDataMarket.length; j++) {
    //     tmp = sortDataMarket[i];
    //     if (sortDataMarket[j]['market_cap_rank'] < tmp['market_cap_rank']) {
    //       sortDataMarket[i] = sortDataMarket[j];
    //       sortDataMarket[j] = tmp;
    //     }
    //   }
    // }

    notifyListeners();
  }
}
