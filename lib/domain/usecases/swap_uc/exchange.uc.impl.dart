import 'package:bitriel_wallet/domain/model/exchange.model/exchange.m.dart';
import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';
import 'package:bitriel_wallet/index.dart';

class ExchangeUcImpl<T> {

  ExchangeCoinI? coin1;
  ExchangeCoinI? coin2;
  ValueNotifier<bool> isCoin1 = ValueNotifier(false);
  ValueNotifier<bool> isCoin2 = ValueNotifier(false);

  // Notifier Field
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<bool> isExchangeStateReady = ValueNotifier(false);
  
  ValueNotifier<bool> isReady = ValueNotifier(false);

  ValueNotifier<bool> statusNotifier = ValueNotifier(false);
  ValueNotifier<num> receivedAmt = ValueNotifier<num>(0);

  // Instance Variable
  List<Exchange>? exchanges;
  
  final ExolixExchangeUCImpl exolicUCImpl = ExolixExchangeUCImpl();
  
  final LetsExchangeUCImpl letsExchangeUCImpl = LetsExchangeUCImpl();
  
  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  // defaultLstCoins
  List<ExchangeCoinI>? defaultLstCoins;
  List<T>? lstTx;

  SwapModel swapModel = SwapModel();

  set setContext(BuildContext ctx){
    exolicUCImpl.setContext = ctx;
    letsExchangeUCImpl.setContext = ctx;
  }

  void initExchangeState() async {
    
    exchanges = [
      Exchange(title: 'Exolix', getCoins: exolicUCImpl.getCoins),
      Exchange(title: 'LetsExchange', getCoins: letsExchangeUCImpl.getCoins) 
    ];

    isExchangeStateReady.value = true;
    
    await getExchangeCoins();

  }

  void onDropDownChange(int? index) {

    currentIndex.value = index!;
    
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    isExchangeStateReady.notifyListeners();

    resetState();
  }

  Future<void> getExchangeCoins() async {

    exchanges![currentIndex.value].coins = await exchanges![currentIndex.value].getCoins();

    isReady.value = true;

  }

  Future<void> getTrxHistory() async {
    
    // if(defaultLstCoins == null){
    // }

    // if (lstTx == null){

    //   await _secureStorageImpl.readSecure(DbKey.lstExolicTxIds_key)!.then( (localLstTx){

    //     lstTx?.clear();

    //     // ignore: unnecessary_null_comparison
    //     if (localLstTx.isNotEmpty){

    //       // lstTx = List<Map<String, dynamic>>.from((json.decode(localLstTx))).map((e) {
    //       //   return ExolixSwapResModel.fromJson(e);
    //       // }).toList();
    //     }
        
    //     // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    //     isReady.value = true;

    //   });
    // }
    
  }

  void queryEstimateAmt() {

    // if (coin1 != null && coin2 != null){

    //   EasyDebounce.debounce("queryEstimateAmt", const Duration(milliseconds: 500), () async {

    //     await _exolixExchangeRepoImpl.exolixTwoCoinInfo({
    //       "coinFrom": swapModel.coinFrom,
    //       "coinTo": swapModel.coinTo,
    //       "coinFromNetwork": swapModel.networkFrom,
    //       "coinToNetwork": swapModel.networkTo,
    //       "amount": swapModel.amt!.value,
    //       "rateType": "fixed"
    //     }).then((value) {

    //       if (value.statusCode == 200) {
    //         // receivedAmt.value = (json.decode(value.body))['toAmount'].toString();
    //       }
    //     });
    //   });
      
    // }
  }

  void setCoin(BuildContext context, bool isFrom){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectSwapToken(
          coin: exchanges![currentIndex.value].coins,
          coin1: coin1,
          coin2: coin2
        ),
      )
    ).then((res) {

      if (res != null){

        if (isFrom == true){

          coin1 = exchanges![currentIndex.value].coins[res];
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          isCoin1.notifyListeners();
        //   swapModel.coinFrom = coin1.value.title;
        //   swapModel.networkFrom = coin1.value.networkCode;

        } else {

          coin2 = exchanges![currentIndex.value].coins[res];
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          isCoin2.notifyListeners();
          
        //   coin2.value = lstLECoin.value[res];
        //   swapModel.coinTo = coin2.value.title;
        //   swapModel.networkTo = coin2.value.networkCode;
        }

        // swapModel.withdrawalAddress = Provider.of<SDKProvider>(context, listen: false).getSdkImpl.evmAddress;
        
        // queryEstimateAmt();
        
        // if (Validator.swapValidator(swapModel.coinFrom!, swapModel.coinTo!, swapModel.amt!.value) == true){
        //   isReady.value = true;
        // } else if (isReady.value == false) {
        //   isReady.value = false;
        // }
        
      }
    });
  }

  void switchExchange(int index) async {

    if (index != currentIndex.value){

      currentIndex.value = index;

      await getExchangeCoins();

    }
  }

  @override 
  void onDeleteTxt() {

    final formattedValue = formatCurrencyText(swapModel.amt!.value);

    swapModel.amt!.value = formattedValue;

    if (swapModel.amt!.value.isNotEmpty) {
      swapModel.amt!.value = swapModel.amt!.value.substring(0, swapModel.amt!.value.length - 1);
    }

  }

  String formatCurrencyText(String value) {
    return value;
  }

  void formatDouble(String value) {

    if (swapModel.amt!.value.replaceAll(".", "").length < 10){
      // Value Equal Empty & Not Contains "."
      if (value.contains(".") && !(swapModel.amt!.value.contains(".")) && swapModel.amt!.value.isEmpty){

        swapModel.amt!.value = "0.";

      } 
      // Prevent Add "." Multiple Time.
      // Reject Input "." Evertime
      else if ( !(value.contains("."))) {

        swapModel.amt!.value = swapModel.amt!.value + value;

      }
      // Add "." For Only one time.
      else if ( !(swapModel.amt!.value.contains(".")) ){

        swapModel.amt!.value = swapModel.amt!.value + value;
      
      }

      queryEstimateAmt();

      // if (Validator.swapValidator(swapModel.coinFrom!, swapModel.coinTo!, swapModel.amt!.value) == true){
      //   isReady.value = true;
      // } else if (isReady.value == true){
      //   isReady.value = false;
      // }
    }

  }

  void resetState() {

    if (coin1 != null){

      coin1 = null;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      isCoin1.notifyListeners();

    }
    if (coin2 != null){

      coin2 = null;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      isCoin2.notifyListeners();
    }
  }

}