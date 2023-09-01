import 'package:bitriel_wallet/index.dart';

abstract class LetsExchangeRepository {
  Future<List<LetsExchangeCoin>> getLetsExchangeCoin();
  Future<Response> getLetsExStatusByTxId(String txId);
  Future<Response> twoCoinInfo(Map<String, dynamic> jsn);
  Future<Response> swap(Map<String, dynamic> mapData);
}