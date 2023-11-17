import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';
import 'package:bitriel_wallet/index.dart';

class LetsExchangeUCImpl<T> implements LetsExchangeUseCases, ExchangeCoinI {

  BuildContext? _context;
  
  /// Data Of Coin 1
  ValueNotifier<LetsExCoinByNetworkModel> coin1 = ValueNotifier(LetsExCoinByNetworkModel());
  /// Data Of Coin 2
  ValueNotifier<LetsExCoinByNetworkModel> coin2 = ValueNotifier(LetsExCoinByNetworkModel());
  
  ValueNotifier<bool> isLstCoinReady = ValueNotifier(false);

  ValueNotifier<String> receiveAmt = ValueNotifier("");

  final LetsExchangeRepoImpl _letsExchangeRepoImpl = LetsExchangeRepoImpl();

  List<Map<String, dynamic>> defaultLstCoins = [];

  Widget? imgConversion;

  final PaymentUcImpl _paymentUcImpl = PaymentUcImpl();

  ValueNotifier<List<LetsExCoinByNetworkModel>> lstLECoin = ValueNotifier([]);

  List<SwapResModel>? lstTx = [];
  
  ValueNotifier<bool> statusNotifier = ValueNotifier(false);

  List<ExchangeCoinI> filteredCoins = [];

  int? index;

  ValueNotifier<bool> isReady = ValueNotifier(false);

  set setContext(BuildContext ctx){
    _context = ctx;
    _paymentUcImpl.setBuildContext = ctx;
  }

  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  // SwapModel swapModel = SwapModel();
  @override
  String? code, coinName, network, networkName, shortName, icon;
  
  LetsExchangeUCImpl();
  
  LetsExchangeUCImpl.mapping({this.code, this.coinName, this.network, this.networkName, this.icon, this.shortName});

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
      
      // List<Map<String, dynamic>>.from(element['networks']).every((e) {

      //   code = element['code'];
      //   coinName = element['name'];
      //   icon = element['icon'];
      //   network = e['network'];
      //   networkName = e['name'];

      //   filteredCoins.add(this);

      //   return true;
        
      // });
    }

    for (var element in filteredCoins) {
      print("Element ${element.coinName}");
    }

    return filteredCoins;

  }

  @override
  Future<List<T>> getLetsExchangeCoin() async {

    defaultLstCoins = await _letsExchangeRepoImpl.getLetsExchangeCoin();

    lstCoinExtract();

    return defaultLstCoins as List<T>;
    
  }
  
  void lstCoinExtract() {

    // for(int i = 0; i < defaultLstCoins.length; i++){

    //   for (int j = 0; j < defaultLstCoins[i].networks!.length; j++){
    //     addCoinByIndex(i, j);
    //   }

    // }

    // isLstCoinReady.value = true;
    
  }

  void addCoinByIndex(int i, int j) {

    if (defaultLstCoins[i]['icon'] != null){

    //   if (lstCoins![i]['icon'].contains('svg')){
    //     imgConversion = SvgPicture.network(lstCoins![i]['icon'], width: 10);
    //   } else if (lstCoins![i]['icon'] != null){
    //     imgConversion = Image.network(lstCoins![i]['icon'], width: 10);
    //   }
    // }
    // // Null 
    // else {
    //   imgConversion = CircleAvatar(child: Container(width: 10, height: 10, color: Colors.green,),);
    }

    if (
      defaultLstCoins[i]['network']![j].code == "BTC" ||
      defaultLstCoins[i]['network']![j].code == "BEP20" ||
      defaultLstCoins[i]['network']![j].code == "ERC20" ||
      defaultLstCoins[i]['network']![j].code == "Ethereum" ||
      defaultLstCoins[i]['network']![j].code == "Binance Chain"
    ){
      
      // ExolixExchangeUCImpl.mapping({this.code, this.coinName, this.network, this.networkName, this.icon, this.shortName});

      // lstLECoin.value.add(
      //   LetsExCoinByNetworkModel(
      //     title: defaultLstCoins[i]['code'],
      //     subtitle: defaultLstCoins[i]['name'],
      //     // isActive: index2 == i ? true : false,
      //     image: Container(),//imgConversion!,
      //     network: defaultLstCoins[i]['network'][j].name!,
      //     networkCode: defaultLstCoins[i]['network'][j].code,
      //     balance: "0"//contractProvider!.sortListContract[i].balance,
          
      //   )
      // );
    }

  }

  @override
  Future<String> rate(ExchangeCoinI coin1, ExchangeCoinI coin2, SwapModel swapModel) async {

    // print({
    //   "from": swapModel.from,
    //   "to": swapModel.to,
    //   "network_from": swapModel.networkFrom,
    //   "network_to": swapModel.networkTo,
    //   "amount": swapModel.amt!.value
    // });

    return await _letsExchangeRepoImpl.twoCoinInfo({
      "from": coin1.code,
      "to": coin2.code,
      "amount": swapModel.amt!.value
    }).then((value) async {
      return (json.decode(value.body))['amount'];
    });

  }

  @override
  Future<void> letsExchangeSwap(SwapModel swapModel) async {
    print("swapModel.toJson() ${swapModel.toJson()}");

    await _letsExchangeRepoImpl.swap(swapModel.toJson()).then((value) async {

      print("statusCode ${value.statusCode}");
      print("value ${value.body}");
        
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

        lstTx!.add(SwapResModel.fromJson(json.decode(value.body)));
        
        await SecureStorageImpl().writeSecure(DbKey.lstTxIds, json.encode(SwapResModel().toJson(lstTx!)));

        // Close Dialog
        Navigator.pop(_context!);

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

      _paymentUcImpl.recipientController.text = lstTx![index].deposit!;
      _paymentUcImpl.amountController.text = lstTx![index].deposit_amount!;

      if (value != null){
        await _paymentUcImpl.sendBep20();
      }
    });

  }

  @override
  Future<void> confirmSwap(int indx) async {
    index = indx;
    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => ConfirmSwapExchange( statusNotifier: statusNotifier, swapResModel: lstTx![index!], confirmSwap: swapping, getStatus: getStatus))
    );
  }

  @override
  Future<void> swapping(SwapResModel swapResModel) async {
    
    int index = Provider.of<WalletProvider>(_context!, listen: false).sortListContract!.indexWhere((model) {
      
      if ( swapResModel.coin_from!.toLowerCase() == model.symbol!.toLowerCase() ){
        isReady.value = true;
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
    
    dialogLoading(_context!, content: "Checking Status");

    await _letsExchangeRepoImpl.getLetsExStatusByTxId(lstTx![index!].transaction_id!).then((value) {
      
      lstTx![index!] = SwapResModel.fromJson(json.decode(value.body));

    });

    await SecureStorageImpl().writeSecure(DbKey.lstTxIds, json.encode(SwapResModel().toJson(lstTx!)));

    // Close Dialog
    Navigator.pop(_context!);

    return lstTx![index!];
  }

}