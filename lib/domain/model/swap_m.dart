import 'package:bitriel_wallet/domain/model/exolix_ex_coin_m.dart';
import 'package:bitriel_wallet/index.dart';

class SwapModel {
  
  String? from;
  String? to;
  String? networkFrom;
  String? withdrawal;
  String? networkTo;
  ValueNotifier<String>? amt;
  String? affiliateId;

  SwapModel(){
    from = "";
    to = "";
    networkFrom = "";
    networkTo = "";
    amt = ValueNotifier("");
    affiliateId = "DCNVjpI0Txr1Sw2w";
  }

  // Return Encode Json
  Map<String, dynamic> toJson(){
    
    return {
      "coin_from": from,
      "coin_to": to,
      "deposit_amount": amt!.value,
      "withdrawal": withdrawal,
      "return": withdrawal,
      "network_from": networkFrom,
      "network_to": networkTo,
      "withdrawal_extra_id": null,
      "affiliate_id": affiliateId,
    };
  }
}

class ExolixSwapModel {
  
  String? coinFrom;
  String? coinTo;
  String? networkFrom;
  String? networkTo;
  String? withdrawalAddress;
  ValueNotifier<String>? amt;

  ExolixSwapModel(){
    coinFrom = "";
    coinTo = "";
    networkFrom = "";
    networkTo = "";
    amt = ValueNotifier("");
  }

  // Return Encode Json
  Map<String, dynamic> toJson(){
    
    return {
      "coinFrom": coinFrom,
      "coinTo": coinTo,
      "networkFrom": networkFrom,
      "networkTo": networkTo,
      "amount": amt!.value,
      "withdrawalAddress": withdrawalAddress,
    };
  }
}

class SwapResModel {

  bool? is_float;
  String? status;
  String? coin_from;
  String? coin_to;
  String? deposit_amount;
  String? withdrawal;
  String? withdrawal_extra_id;
  String? _return;
  String? return_extra_id;
  String? final_amount;
  String? extra_fee_from;
  String? extra_fee_to;
  String? coin_from_network;
  String? coin_to_network;
  String? deposit;
  String? deposit_extra_id;
  String? withdrawal_amount;
  String? rate;
  String? fee;
  bool? revert;
  String? transaction_id;
  int? expired_at;
  String? created_at;
  String? execution_time;
  bool? is_available;
  String? coin_from_explorer_url;
  String? coin_to_explorer_url;
  String? coin_from_icon;
  String? coin_from_extra_name;
  String? coin_to_icon;
  String? coin_to_extra_name;
  String? coin_from_name;
  String? coin_to_name;
  int? need_confirmations;
  int? confirmations;
  String? email;
  List<dynamic>? aml_error_signals;
  
  SwapResModel();

  SwapResModel.fromJson(Map<String, dynamic> jsn){

    if (jsn['revert'].runtimeType.toString() == "int"){
      jsn['revert'] = jsn['revert'] == 0 ? false : true;
    }

    is_float = jsn['is_float'] == 1 ? true : false;
    status = jsn['status'];
    coin_from = jsn['coin_from'];
    coin_to = jsn['coin_to'];
    deposit_amount = jsn['deposit_amount'];
    withdrawal = jsn['withdrawal'];
    withdrawal_extra_id = jsn['withdrawal_extra_id'];
    final_amount = jsn['final_amount'];
    _return = jsn['return'];
    return_extra_id = jsn['return_extra_id'];
    extra_fee_from = jsn['extra_fee_from'].toString();
    extra_fee_to = jsn['extra_fee_to'].toString();
    coin_from_network = jsn['coin_from_network'];
    coin_to_network = jsn['coin_to_network'];
    deposit = jsn['deposit'];
    deposit_extra_id = jsn['deposit_extra_id'];
    withdrawal_amount = jsn['withdrawal_amount'];
    rate = jsn['rate'];
    fee = jsn['fee'].toString();
    revert = jsn['revert'];
    transaction_id = jsn['transaction_id'];
    expired_at = jsn['expired_at'];
    created_at = jsn['created_at'];
    execution_time = jsn['execution_time'];
    is_available = jsn['is_available'];
    coin_from_explorer_url = jsn['coin_from_explorer_url'];
    coin_to_explorer_url = jsn['coin_to_explorer_url'];
    coin_from_icon = jsn['coin_from_icon'];
    coin_from_extra_name = jsn['coin_from_extra_name'];
    coin_to_icon = jsn['coin_to_icon'];
    coin_to_extra_name = jsn['coin_to_extra_name'];
    coin_from_name = jsn['coin_from_name'];
    coin_to_name = jsn['coin_to_name'];
    need_confirmations = jsn['need_confirmations'];
    confirmations = jsn['confirmations'];
    email = jsn['email'];
    aml_error_signals = jsn['aml_error_signals'];
  }

  List<Map<String, dynamic>> toJson(List<SwapResModel?> lstSwapRes){

    return lstSwapRes.map((e) => {
      'is_float': e!.is_float,
      'status': e.status,
      'coin_from': e.coin_from,
      'coin_to': e.coin_to,
      'deposit_amount': e.deposit_amount,
      'withdrawal': e.withdrawal,
      'withdrawal_extra_id': e.withdrawal_extra_id,
      'final_amount': e.final_amount,
      'return': e._return,
      'return_extra_id': e.return_extra_id,
      'extra_fee_from': e.extra_fee_from,
      'extra_fee_to': e.extra_fee_to,
      'coin_from_network': e.coin_from_network,
      'coin_to_network': e.coin_to_network,
      'deposit': e.deposit,
      'deposit_extra_id': e.deposit_extra_id,
      'withdrawal_amount': e.withdrawal_amount,
      'rate': e.rate,
      'fee': e.fee,
      'revert': e.revert,
      'transaction_id': e.transaction_id,
      'expired_at': e.expired_at,
      'created_at': e.created_at,
      'execution_time': e.execution_time,
      'is_available': e.is_available,
      'coin_from_explorer_url': e.coin_from_explorer_url,
      'coin_to_explorer_url': e.coin_to_explorer_url,
      'coin_from_icon': e.coin_from_icon,
      'coin_from_extra_name': e.coin_from_extra_name,
      'coin_to_icon': e.coin_to_icon,
      'coin_to_extra_name': e.coin_to_extra_name,
      'coin_from_name': e.coin_from_name,
      'coin_to_name': e.coin_to_name,
      'need_confirmations': e.need_confirmations,
      'confirmations': e.confirmations,
      'email': e.email,
      'aml_error_signals': e.aml_error_signals
    }).toList();
    
  }
  
}

class ExolixSwapResModel {

  String? id;
  String?  amount;
  String? amountTo;
  ExolixCoin? coinFrom;
  ExolixCoin? coinTo;
  String? comment;
  String? createdAt;
  String? depositAddress;
  String? depositExtraId;
  String? withdrawalAddress;
  String? withdrawalExtraId;
  String? refundAddress;
  String? refundExtraId;
  dynamic rate;
  String? rateType;
  String? status;
  String? email;
  
  ExolixSwapResModel();

  ExolixSwapResModel.fromJson(Map<String, dynamic> jsn){
    id = jsn['id'];
    status = jsn['status'];
    coinFrom = ExolixCoin.fromJson(jsn['coinFrom']);
    coinTo = ExolixCoin.fromJson(jsn['coinTo']);
    comment = jsn['comment'];
    createdAt = jsn['createdAt'];
    amount = jsn['amount'].toString();
    amountTo = jsn['amountTo'].toString();
    depositAddress = jsn['depositAddress'];
    depositExtraId = jsn['depositExtraId'];
    withdrawalAddress = jsn['withdrawalAddress'];
    withdrawalExtraId = jsn['withdrawalExtraId'];
    refundAddress = jsn['refundAddress'];
    refundExtraId = jsn['refundExtraId'];
    rate = jsn['rate'];
    rateType = jsn['rateType'];
    email = jsn['email'];
  }

  List<Map<String, dynamic>> toJson(List<ExolixSwapResModel?> lstSwapRes){

    return lstSwapRes.map((e) => {
      "id": e!.id,
      "status": e.status,
      "coinFrom": e.coinFrom,
      "coinTo": e.coinTo,
      "comment": e.comment,
      "createdAt": e.createdAt,
      "amount": e.amount,
      "amountTo": e.amountTo,
      "depositAddress": e.depositAddress,
      "depositExtraId": e.depositExtraId,
      "withdrawalAddress": e.withdrawalAddress,
      "withdrawalExtraId": e.withdrawalExtraId,
      "refundAddress": e.refundAddress,
      "refundExtraId": e.refundExtraId,
      "rate": e.rate,
      "rateType": e.rateType,
      "email": e.email,
    }).toList();
    
  }
  
}