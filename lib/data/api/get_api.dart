import 'package:bitriel_wallet/index.dart';
import 'package:http/http.dart' as http;

class GetRequest {

  static String? _api;
  /// Http Requests Header
  static Map<String, String> conceteHeader({String? key, String? value}) { /* Concete More Content Of Header */
    return key != null 
    ? { /* if Parameter != Null = Concete Header With  */
      "Content-Type": "application/json; charset=utf-8", 
      'accept': 'application/json',
      key: value!
    }
    : { /* if Parameter Null = Don't integrate */
      "Content-Type": "application/json; charset=utf-8",
      'accept': 'application/json'
    };
  }

  static Future<http.Response> getSelendraEndpoint() async {
    return await http.get(Uri.parse(dotenv.get('SELENDRA_API_BITRIEL')));
  }

  static Future<http.Response> getContractAddress() async {
    return await http.get(Uri.parse(dotenv.get('SELENDRA_API_CONTRACT_ADDRESS')));
  }

  static Future<http.Response> getDeepLinkRoutes() async {
    return await http.get(Uri.parse(dotenv.get('SELENDRA_API_DEEPLINK')));
  }

  /*--------------- LETS EXCHANGE API FUNCTION ---------------*/
  static Future<http.Response> queryTrxStatus(String id) async {

    _api = dotenv.get('LETS_EXCHANGE_API');
    return await http.get(
      // Uri.parse("${dotenv.get('DOERS_API')}sessions/by-ticket-type"), // Old
      Uri.parse("$_api/v1/transaction/$id"),
      headers: conceteHeader()
    );
  }

  /// Token Info
  /// 
  static Future<http.Response> coins() async {
    _api ??= dotenv.get('LETS_EXCHANGE_API');

    return await http.get(
      Uri.parse("$_api/v2/coins"),
      headers: conceteHeader()
    );

  }

  // Convert Coin
  static Future<http.Response> convertCoin(String fromCoin, String toCoin, String amount) async {
    return await http.get(
      Uri.parse("https://api.coinconvert.net/convert/$fromCoin/$toCoin?amount=$amount"),
      headers: conceteHeader(),
    );

  }

  // Get News article
  static Future<http.Response> getNewsArticle() async {
    return await http.get(
      Uri.parse("https://min-api.cryptocompare.com/data/v2/news/?categories=Blockchain,Mining?lang=EN&api_key=${dotenv.get("CRYPTOCOMPARE_APIKEY")}"),
      headers: conceteHeader(),
    );
  }

  // Convert Coin
  static Future<http.Response> downloadFile(String fileName) async {
    return await http.get(
      Uri.parse("${dotenv.get('BITRIEL_ASSETS')}$fileName"),
      headers: conceteHeader(),
    );

  }

  static Future<http.Response> fetchAddrUxtoBTC(String btcAddr) async {
    return await http.get(
      Uri.parse("https://blockstream.info/api/address/$btcAddr/utxo"),
      headers: conceteHeader(),
    );

  }

  static Future<http.Response> getMarkets() async {
    var url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=100";
    var token = dotenv.get('COINMARKETCAP');
    return await http.get(Uri.parse(url),headers: {
      "X-CMC_PRO_API_KEY" : token
    });
  }

  /// Exam id: tether...
  static Future<http.Response> getContractById(String id) async {
    var url = "https://api.coingecko.com/api/v3/coins/$id";
    return await http.get(Uri.parse(url), headers: conceteHeader());
  }

  static Future<http.Response> getLetsExchangeCoin() async {
    var url = "https://api.letsexchange.io/api/v2/coins";
    var token = dotenv.get('LETS_EXCHANGE_TOKEN');
    return await http.get(Uri.parse(url),headers: {
      "Authorization" : "Bearer $token"
    });
  }

  static Future<http.Response> getLetsExStatusByTxId(String txId) async {
    var url = "https://api.letsexchange.io/api/v1/transaction/$txId";
    var token = dotenv.get('LETS_EXCHANGE_TOKEN');
    return await http.get(Uri.parse(url),headers: {
      "Authorization" : "Bearer $token"
    });
  }

    /*--------------- EXOLIX API FUNCTION ---------------*/
  static Future<http.Response> getExolixExStatusByTxId(String id) async {
    var url = dotenv.get('EXOLIX_URL');
    var api = dotenv.get('EXOLIX_API');
    var uri = Uri.parse("$url/$api/transactions/$id");
    
    return await http.get(
      uri,
      headers: conceteHeader()
    );
  }

  static Future<http.Response> getExolixExchangeCoin() async {
    var url = dotenv.get('EXOLIX_URL');
    var api = dotenv.get('EXOLIX_API');
    var uri = Uri.parse("$url/$api/currencies?all=true&withNetworks=true&networksList=BTC,BSC,ETH");

    return await http.get(
      uri,
      headers: conceteHeader()
    );
  }

  Future<http.Response> exolixTwoCoinInfo(Map<String, dynamic> queryParameters) async {
    var url = dotenv.get('EXOLIX_URL');
    var api = dotenv.get('EXOLIX_API');
    var token = dotenv.get('EXOLIX_TOKEN');
    queryParameters.addAll({ 'apiToken': token });
    var uri = Uri.parse("$url/$api/rate").replace(queryParameters: queryParameters);

    return await http.get(
      uri,
      headers: conceteHeader()
    );
  }
}
