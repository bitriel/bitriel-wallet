import 'package:bitriel_wallet/domain/model/exolix_ex_coin_m.dart';
import 'package:bitriel_wallet/index.dart';

abstract class ExolixExchangeRepository {
  Future<List<ExolixExchangeCoin>> getExolixExchangeCoin();
  Future<Response> getExolixExStatusByTxId(String txId);
  Future<Response> exolixTwoCoinInfo(Map<String, dynamic> jsn);
  Future<Response> exolixSwap(Map<String, dynamic> mapData);
}