import 'package:bitriel_wallet/data/api/post_api.dart';
import 'package:bitriel_wallet/index.dart';

class LetsExchangeRepoImpl implements LetsExchangeRepository {

  @override
  Future<List<Map<String, dynamic>>> getLetsExchangeCoin() async{
    
    return await GetRequest.getLetsExchangeCoin().then((value) {
      return List<Map<String, dynamic>>.from(jsonDecode(value.body));
    });

    // return lstLECoin;

  }

  // Post Request
  @override
  Future<Response> swap(Map<String, dynamic> mapData) async {

    return await PostRequest().swap(mapData);
  }

  @override
  Future<Response> getLetsExStatusByTxId(String txId) async {
    return await GetRequest.getLetsExStatusByTxId(txId);
  }

  @override
  Future<Response> twoCoinInfo(Map<String, dynamic> jsn) async {
    return await PostRequest().twoCoinInfo(jsn);
  }

}