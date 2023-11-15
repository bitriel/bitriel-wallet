import 'package:bitriel_wallet/domain/model/exchange.model/exolix_ex_coin_m.dart';
import 'package:bitriel_wallet/index.dart';

abstract class ExolixExchangeRepository {
  Future<List<Map<String, dynamic>>> getExolixExchangeCoin();
  Future<Response> getExolixExStatusByTxId(String txId);
  Future<Response> exolixTwoCoinInfo(String headerConcrete);
  Future<Response> exolixSwap(Map<String, dynamic> mapData);
}