import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';
import 'package:bitriel_wallet/index.dart';

class LetsExchangeUCImpl<T> implements LetsExchangeUseCases, ExchangeCoinI, ExChangeTxI {

  BuildContext? _context;

  List<Map<String, dynamic>> defaultLstCoins = [];

  final LetsExchangeRepoImpl _letsExchangeRepoImpl = LetsExchangeRepoImpl();

  final PaymentUcImpl _paymentUcImpl = PaymentUcImpl();

  List<Map<String, dynamic>>? lstTx = [];
  
  ValueNotifier<bool> statusNotifier = ValueNotifier(false);

  List<ExchangeCoinI> filteredCoins = [];

  int? index;

  set setContext(BuildContext ctx){
    _context = ctx;
    _paymentUcImpl.setBuildContext = ctx;
  }

  @override
  String? code, coinName, network, networkName, shortName, icon;
  LetsExchangeUCImpl();
  LetsExchangeUCImpl.mapping({this.code, this.coinName, this.network, this.networkName, this.icon, this.shortName});

  @override
  String? id, coinFrom ,coinFromNetwork ,coinFromIcon, coinFromNetworkName ,coinTo, coinToNetworkName ,coinToNetwork ,coinToIcon ,depositAddr ,depositAmt ,withdrawalAddress ,createdAt ,withdrawalAmount;
  @override
  ValueNotifier<String>? status;
  LetsExchangeUCImpl.txMapping({
    required this.id,
    required this.coinFrom,
    required this.coinFromNetwork,
    required this.coinFromNetworkName,
    required this.coinFromIcon,

    required this.coinTo,
    required this.coinToNetwork,
    required this.coinToNetworkName,
    required this.coinToIcon,

    required this.depositAddr,
    required this.depositAmt,
    required this.withdrawalAddress,
    required this.createdAt,
    required this.status,
    required this.withdrawalAmount,
  });

  ExChangeTxI fromJson(Map<String, dynamic> jsn){
    return LetsExchangeUCImpl.txMapping(
      id: jsn['transaction_id'],

      coinFrom: jsn['coin_from'],
      coinFromNetwork: jsn['coin_from_network'],
      coinFromNetworkName: jsn['coin_from_name'],
      coinFromIcon: jsn['coin_from_icon'],

      coinTo: jsn['coin_to'],
      coinToNetwork: jsn['coin_to_network'],
      coinToNetworkName: jsn['coin_to_name'] ?? '',
      coinToIcon: jsn['coin_to_icon'],

      depositAddr: jsn['deposit'],
      depositAmt: jsn['deposit_amt'],

      status: ValueNotifier(jsn['status']),
      withdrawalAmount: jsn['withdrawal_amount'].toString(),

      withdrawalAddress: jsn['withdrawal'],
      createdAt: jsn['created_at'],

    );
  }

  @override
  Future<List<ExchangeCoinI>> getCoins() async {
    
    defaultLstCoins = await _letsExchangeRepoImpl.getLetsExchangeCoin();
    
    print("defaultLstCoins $defaultLstCoins");

    for (var element in defaultLstCoins) {

      filteredCoins.addAll(
        List<Map<String, dynamic>>.from(element['networks']).map((e) {
          return LetsExchangeUCImpl.mapping(
            code: element['code'], 
            coinName: element['name'], 
            icon: element['icon'],
            network: e['code'],
            networkName: e['name'],
            shortName: e['code']
          );
        })
      );
    }

    return filteredCoins;

  }

  @override
  Future<List<T>> getLetsExchangeCoin() async {

    defaultLstCoins = await _letsExchangeRepoImpl.getLetsExchangeCoin();

    return defaultLstCoins as List<T>;
    
  }

  @override
  Future<String> rate(ExchangeCoinI coin1, ExchangeCoinI coin2, SwapModel swapModel) async {

    return await _letsExchangeRepoImpl.twoCoinInfo({
      "from": coin1.code,
      "to": coin2.code,
      "amount": swapModel.amt!.value
    }).then((value) async {
      return (json.decode(value.body))['amount'];
    });

  }

  @override
  Future<ExChangeTxI> letsExchangeSwap(SwapModel swapModel) async {

    return await _letsExchangeRepoImpl.swap(swapModel.toJson()).then((value) async {
        
      if (value.statusCode == 401){
        throw json.decode(value.body)['error'];
      }
      // Unprocessable entity
      else if (value.statusCode == 422) {
        throw (json.decode(value.body)['error']['validation'].containsKey("coin_from") 
          ? "The selected first coin is not active." 
          : "The selected second coin is not active." 
        );
      }

      else if (value.statusCode == 200) {

        // tx = ExolixExchangeUCImpl.txMapping(
        //   id: jsn['transaction_id'],
        //   coinFrom: jsn['coin_from'],
        //   coinFromNetwork: jsn['coin_from_network'],
        //   coinFromIcon: jsn['coin_from_icon'],
        //   coinTo: jsn['coin_to'],
        //   coinToNetwork: jsn['coin_to_network'],
        //   coinToIcon: jsn['coin_to_icon'],
        //   deposit: jsn['deposit'],
        //   depositAmt: jsn['deposit_amt'],
        //   withdrawal: jsn['withdrawal'],
        //   createdAt: jsn['created_at'],
        //   status: ValueNotifier(jsn['status']),
        //   withdrawalAmount: jsn['withdrawal_amount'].toString(),
        // );

        // lstTx!.add(SwapResModel.fromJson(jsn));
        lstTx!.add(json.decode(value.body));
        
        await SecureStorageImpl().writeSecure(DbKey.lstTxIds, json.encode(lstTx!));

        await QuickAlert.show(
          context: _context!,
          type: QuickAlertType.success,
          showCancelBtn: true,
          cancelBtnText: "Close",
          cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
          confirmBtnText: "Confirm",
          text: 'Swap Successfully!',
          onConfirmBtnTap: () {
            confirmSwap(lstTx!.length - 1);
          },
        );

        return fromJson(json.decode(value.body));
        
      } else {
        throw json.decode(value.body);
      }
    });
    
  }

  // Index Of List
  Future<void> paySwap(int index) async {
    
    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => const PincodeScreen(title: '', label: PinCodeLabel.fromSendTx,))
    ).then((value) async {

      // _paymentUcImpl.recipientController.text = lstTx![index].deposit!;
      // _paymentUcImpl.amountController.text = lstTx![index].deposit_amount!;

      if (value != null){
        await _paymentUcImpl.sendBep20();
      }
    });

  }

  @override
  Future<void> confirmSwap(int indx) async {
    // index = indx;
    // Navigator.push(
    //   _context!,
    //   MaterialPageRoute(builder: (context) => ConfirmSwapExchange( statusNotifier: statusNotifier, swapResModel: lstTx![index!], confirmSwap: swapping, getStatus: getStatus))
    // );
  }

  @override
  Future<void> swapping(SwapResModel swapResModel) async {
    
    int index = Provider.of<WalletProvider>(_context!, listen: false).sortListContract!.indexWhere((model) {
      
      if ( swapResModel.coin_from!.toLowerCase() == model.symbol!.toLowerCase() ){
        return true;
      }

      return false;

    });

    if (index != -1){

      await Navigator.pushReplacement(
        _context!,
        MaterialPageRoute(builder: (context) => TokenPayment(index: index, address: swapResModel.withdrawal, amt: swapResModel.deposit_amount,))
      );
      
    } else {
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.warning,
        showCancelBtn: true,
        cancelBtnText: "Close",
        cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
        text: '${swapResModel.coin_from!} (${swapResModel.coin_from_network}) is not found. Please add contract token !',
        confirmBtnText: 'Add Contract',
        onConfirmBtnTap: (){
          Navigator.pushReplacement(
            _context!, 
            MaterialPageRoute(builder: (context) => AddAsset(index: swapResModel.coin_from_network == "BEP20" ? 0 : 1,))
          );
        }
      );

    }
  }

  /// This function for update status inside details
  Future<SwapResModel> getStatus() async {
    
    // dialogLoading(_context!, content: "Checking Status");

    // await _letsExchangeRepoImpl.getLetsExStatusByTxId(lstTx![index!].transaction_id!).then((value) {
      
    //   lstTx![index!] = SwapResModel.fromJson(jsn);

    // });

    // await SecureStorageImpl().writeSecure(DbKey.lstTxIds, json.encode(SwapResModel().toJson(lstTx!)));

    // // Close Dialog
    // Navigator.pop(_context!);

    // return lstTx![index!];
    return SwapResModel();
  }

}