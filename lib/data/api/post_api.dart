import 'package:http/http.dart' as http;
import 'package:bitriel_wallet/index.dart';

class PostRequest {
  
  String? _api;
  
  Map<String, String> conceteHeader({String? key, String? value}) { /* Concete More Content Of Header */
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

  Future<http.Response> swap(Map<String, dynamic> mapData) async {

    _api ??= dotenv.get('LETS_EXCHANGE_API');
    
    var token = dotenv.get('LETS_EXCHANGE_TOKEN');

    return await http.post(
      Uri.parse("$_api/v1/transaction"),
      body: json.encode(mapData),
      headers: conceteHeader(key: "Authorization", value: "Bearer $token")
    );

    // Map<String, dynamic> data = {
    //   "is_float": false,
    //   "status": "wait",
    //   "coin_from": "BAT",
    //   "coin_to": "USDT",
    //   "deposit_amount": "360",
    //   "withdrawal": "0xe11175d356d20b70abcec858c6b82b226e988941",
    //   "withdrawal_extra_id": null,
    //   "return": "0xe11175d356d20b70abcec858c6b82b226e988941",
    //   "return_extra_id": null,
    //   "extra_fee_from": 0,
    //   "extra_fee_to": 0,
    //   "coin_from_network": "ERC20",
    //   "coin_to_network": "BEP20",
    //   "deposit": "0xae1F4085B8A5B0c4b9992926cdFfcCFE65896604",
    //   "deposit_extra_id": null,
    //   "withdrawal_amount": "99.02333403",
    //   "rate": "0.275064816750",
    //   "fee": "0",
    //   "revert": false,
    //   "transaction_id": "643e45813785c",
    //   "expired_at": 1681804425,
    //   "created_at": "2023-04-18 10:23:45",
    //   "execution_time": null,
    //   "is_available": true,
    //   "coin_from_explorer_url": "https:\/\/etherscan.io\/tx\/",
    //   "coin_to_explorer_url": "https:\/\/bscscan.com\/tx\/",
    //   "coin_from_icon": "https:\/\/letsexchange.s3.eu-central-1.amazonaws.com\/coins\/5651e7594769444e85f15aa097bd6327.svg",
    //   "coin_from_extra_name": null,
    //   "coin_to_icon": "https:\/\/letsexchange.s3.eu-central-1.amazonaws.com\/coins\/9a086127589d7c0279610e20bc0bfaac.svg",
    //   "coin_to_extra_name": null,
    //   "coin_from_name": "Basic Attention Token",
    //   "coin_to_name": "Tether USD",
    //   "need_confirmations": 0,
    //   "confirmations": 0,
    //   "email": null,
    //   "aml_error_signals": [],
    //   "bonus": 1.62
    // };

    // return http.Response(json.encode(data), 200);
  }

  Future<http.Response> twoCoinInfo(Map<String, dynamic> mapData) async {

    _api ??= dotenv.get('LETS_EXCHANGE_API');
    
    var token = dotenv.get('LETS_EXCHANGE_TOKEN');

    return await http.post(
      Uri.parse("$_api/v1/info"),
      body: json.encode(mapData),
      headers: conceteHeader(key: "Authorization", value: "Bearer $token")
    );
    // return http.Response(json.encode(data), 200);
  }

  Future<http.Response> exolixSwap(Map<String, dynamic> mapData) async {

    var url = dotenv.get('EXOLIX_URL');
    var api = dotenv.get('EXOLIX_API');
    var token = dotenv.get('EXOLIX_TOKEN');
    var uri = Uri.parse("$url/$api/transactions");

    return await http.post(
      uri,
      body: json.encode(mapData),
      headers: conceteHeader(key: "Authorization", value: "Bearer $token")
    );
  }
}