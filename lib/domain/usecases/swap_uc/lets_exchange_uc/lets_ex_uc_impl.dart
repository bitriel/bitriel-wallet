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

  List<SwapResModel>? lstTx;
  
  ValueNotifier<bool> statusNotifier = ValueNotifier(false);

  List<ExchangeCoinI> filteredCoins = [];

  int? index;

  ValueNotifier<bool> isReady = ValueNotifier(false);

  set setContext(BuildContext ctx){
    _context = ctx;
    _paymentUcImpl.setBuildContext = ctx;
  }

  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  SwapModel swapModel = SwapModel();
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
    
    // if(defaultLstCoins.isEmpty){
    //   defaultLstCoins = await _letsExchangeRepoImpl.getLetsExchangeCoin();
    // }

    // if (lstTx == null){
    //   _secureStorageImpl.readSecure(DbKey.lstTxIds)!.then( (localLstTx){

    //     lstTx = [];
        
    //     print("localLstTx $localLstTx");

    //     // ignore: unnecessary_null_comparison
    //     if (localLstTx.isNotEmpty){

    //       lstTx = List<Map<String, dynamic>>.from((json.decode(localLstTx))).map((e) {
    //         return SwapResModel.fromJson(e);
    //       }).toList();
          
    //     }

    //     // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    //     isReady.value = true;

    //   });
    // }

    // lstCoinExtract();
    
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
  void onDeleteTxt() {

    // final formattedValue = formatCurrencyText(swapModel.amt!.value);

    // swapModel.amt!.value = formattedValue;

    // if (swapModel.amt!.value.isNotEmpty) {
    //   swapModel.amt!.value = swapModel.amt!.value.substring(0, swapModel.amt!.value.length - 1);
    // }

  }

  String formatCurrencyText(String value) {
    return value;
  }

  @override
  void formatDouble(String value) {

    // if (swapModel.amt!.value.replaceAll(".", "").length < 10){
    //   // Value Equal Empty & Not Contains "."
    //   if (value.contains(".") && !(swapModel.amt!.value.contains(".")) && swapModel.amt!.value.isEmpty){

    //     swapModel.amt!.value = "0.";

    //   } 
    //   // Prevent Add "." Multiple Time.
    //   // Reject Input "." Evertime
    //   else if ( !(value.contains("."))) {

    //     swapModel.amt!.value = swapModel.amt!.value + value;

    //   }
    //   // Add "." For Only one time.
    //   else if ( !(swapModel.amt!.value.contains(".")) ){

    //     swapModel.amt!.value = swapModel.amt!.value + value;
      
    //   }

    //   queryEstimateAmt();

    //   if (Validator.swapValidator(swapModel.from!, swapModel.to!, swapModel.amt!.value) == true){
    //     isReady.value = true;
    //   } else if (isReady.value == true){
    //   isReady.value = false;
    //   }
    // }

  }

  @override
  Future<Map<String, dynamic>> rate(ExchangeCoinI coin1, ExchangeCoinI coin2, SwapModel swapModel) {

    // if (swapModel.from!.isNotEmpty && swapModel.to!.isNotEmpty){
    //   EasyDebounce.debounce("tag", const Duration(milliseconds: 500), () async {
    //     await _letsExchangeRepoImpl.twoCoinInfo({
    //       "from": swapModel.from,
    //       "to": swapModel.to,
    //       "network_from": swapModel.networkFrom,
    //       "network_to": swapModel.networkTo,
    //       "amount": swapModel.amt!.value
    //     }).then((value) {

    //       if (value.statusCode == 200) {
    //         receiveAmt.value = (json.decode(value.body))['amount'].toString();
    //       }
    //     });
    //   });
    // }
    return Future.delayed(const Duration(seconds: 2));
  }

  void setCoin(BuildContext context, bool isFrom){

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SelectSwapToken(itemLE: lstLECoin.value))
    // ).then((res) {

    //   if (res != null){

    //     if (isFrom == true){

    //       coin1.value = lstLECoin.value[res];
    //       swapModel.from = coin1.value.title;
    //       swapModel.networkFrom = coin1.value.networkCode;

    //     } else {
          
    //       coin2.value = lstLECoin.value[res];
    //       swapModel.to = coin2.value.title;
    //       swapModel.networkTo = coin2.value.networkCode;
    //     }

    //     swapModel.withdrawal = Provider.of<SDKProvider>(context, listen: false).getSdkImpl.evmAddress;
        
    //     queryEstimateAmt();
        
    //     if (Validator.swapValidator(swapModel.from!, swapModel.to!, swapModel.amt!.value) == true){
    //       isReady.value = true;
    //     } else if (isReady.value == false) {
    //       isReady.value = false;
    //     }
        
    //   }
    // });
  }

  @override
  Future<void> swap() async {
    
    // try {

    //   dialogLoading(_context!);

    //   await _letsExchangeRepoImpl.swap(swapModel.toJson()).then((value) async {
        
    //     if (value.statusCode == 401){
    //       throw json.decode(value.body)['error'];
    //     }
    //     // Unprocessable entity
    //     else if (value.statusCode == 422) {
    //       throw (json.decode(value.body)['error']['validation'].containsKey("coin_from") 
    //         ? "The selected first coin is not active." 
    //         : "The selected second coin is not active." 
    //       );
    //     }

    //     else if (value.statusCode == 200) {

    //       lstTx!.add(SwapResModel.fromJson(json.decode(value.body)));
          
    //       await SecureStorageImpl().writeSecure(DbKey.lstTxIds, json.encode(SwapResModel().toJson(lstTx!)));

    //       // Close Dialog
    //       Navigator.pop(_context!);

    //       await QuickAlert.show(
    //         context: _context!,
    //         type: QuickAlertType.success,
    //         showCancelBtn: true,
    //         cancelBtnText: "Close",
    //         cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
    //         confirmBtnText: "Confirm",
    //         text: 'Swap Successfully!',
    //         onConfirmBtnTap: () {
    //           confirmSwap(lstTx!.length - 1);
    //         },
    //       );
    //     } else {
    //       throw json.decode(value.body);
    //     }
    //   });

    // } catch (e) {

    //   print(e);

    //   // Close Dialog
    //   Navigator.pop(_context!);
      
    //   await QuickAlert.show(
    //     context: _context!,
    //     type: QuickAlertType.error,
    //     text: '$e',
    //   );
    // }
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