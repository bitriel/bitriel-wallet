import 'package:bitriel_wallet/data/api/post_api.dart';
import 'package:bitriel_wallet/data/repository/exolix_ex_repo/exolix_ex_repo.dart';
import 'package:bitriel_wallet/index.dart';

class ExolixExchangeRepoImpl implements ExolixExchangeRepository {

  // List<ExolixExchangeCoin> lstExoCoin = [];

  @override
  Future<List<Map<String, dynamic>>> getExolixExchangeCoin() async {
    
    // print(jsonDecode((await GetRequest.getExolixExchangeCoin()).body)['data']);
    return List<Map<String, dynamic>>.from(jsonDecode((await GetRequest.getExolixExchangeCoin()).body)['data']);
    // .then((value) {

    //   if (value.statusCode == 200) {

    //     List<dynamic> json = jsonDecode(value.body)['data'];

    //     // for (dynamic jsonExoCoin in json){
          
    //     //   lstExoCoin.add(ExolixExchangeCoin.fromJson(jsonExoCoin));
    //     // }
    //   }
    // });

    // return lstExoCoin;

  }

  @override
  Future<Response> exolixSwap(Map<String, dynamic> mapData) async {
    return await PostRequest().exolixSwap(mapData);
  }

  @override
  Future<Response> exolixTwoCoinInfo(Map<String, dynamic> jsn) async {
    return await PostRequest().twoCoinInfo(jsn);
  }

  @override
  Future<Response> getExolixExStatusByTxId(String txId) async {
    return await GetRequest.getExolixExStatusByTxId(txId);
  }
}