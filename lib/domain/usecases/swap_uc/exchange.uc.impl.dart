import 'package:bitriel_wallet/domain/model/exchange.model/exchange.m.dart';
import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/exchange/confirm_swap.dart';

class ExchangeUcImpl<T> {

  ExchangeCoinI? coin1;
  ExchangeCoinI? coin2;
  ValueNotifier<bool> isCoin1 = ValueNotifier(false);
  ValueNotifier<bool> isCoin2 = ValueNotifier(false);

  // Notifier Field
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<bool> isExchangeStateReady = ValueNotifier(false);
  ValueNotifier<int> tabBarIndex = ValueNotifier(0);
  
  ValueNotifier<bool> isReady = ValueNotifier(false);
  ValueNotifier<bool> isBtn = ValueNotifier(false);

  ValueNotifier<bool> statusNotifier = ValueNotifier(false);
  ValueNotifier<bool> isReceiveAmt = ValueNotifier(false);
  String receivedAmt = "";

  // Instance Variable
  List<Exchange>? exchanges;
  
  final ExolixExchangeUCImpl exolicUCImpl = ExolixExchangeUCImpl();
  
  final LetsExchangeUCImpl letsExchangeUCImpl = LetsExchangeUCImpl();

  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  BuildContext? _context;

  // defaultLstCoins
  List<ExchangeCoinI>? defaultLstCoins;

  SwapModel swapModel = SwapModel();

  int index = -1;

  set setContext(BuildContext ctx){
    exolicUCImpl.setContext = ctx;
    letsExchangeUCImpl.setContext = ctx;
    _context = ctx;
  }

  void initExchangeState() async {
    
    exchanges = [
      Exchange(title: 'Exolix', instance: exolicUCImpl, storageKey: DbKey.lstExolicTxIds_key, getCoins: exolicUCImpl.getCoins, rate: exolicUCImpl.rate, swap: exolicUCImpl.exolixSwap),
      Exchange(title: 'LetsExchange', instance: letsExchangeUCImpl, storageKey: DbKey.lstLetsExchangeTxIds, getCoins: letsExchangeUCImpl.getCoins, rate: letsExchangeUCImpl.rate, swap: letsExchangeUCImpl.letsExchangeSwap) 
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

  void onChangedTabBar(int index){

    tabBarIndex.value = index;

    getTrxHistory();
  }

  Future<void> getExchangeCoins() async {

    if (exchanges![currentIndex.value].coins.isEmpty){
      exchanges![currentIndex.value].coins = await exchanges![currentIndex.value].getCoins();
    }

    isReady.value = true;

  }

  Future<void> getTrxHistory() async {

    print("getTrxHistory");

  //   print("getTrxHistory");

    if (exchanges![tabBarIndex.value].tx.isEmpty){

    print(" ${exchanges![currentIndex.value].storageKey}");

      await _secureStorageImpl.readSecure(exchanges![tabBarIndex.value].storageKey!)!.then( (localLstTx){

        print("localLstTx $localLstTx");

        if (localLstTx.isNotEmpty){
          exchanges![tabBarIndex.value].tx = List<T>.from(json.decode(localLstTx)).map((e) {
            return exchanges![tabBarIndex.value].instance.fromJson(e);
          }).toList();
        }

      });

      exchanges![tabBarIndex.value].tx.forEach((element) {print(element.createdAt);});
      
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      tabBarIndex.notifyListeners();
    }
  }

  void queryEstimateAmt() {

    if (isReceiveAmt.value == false) isReceiveAmt.value = true;

    EasyDebounce.debounce("queryEstimateAmt", const Duration(milliseconds: 800), () async {

      if (coin1 != null && coin2 != null){

        try {
          receivedAmt = (await exchanges![currentIndex.value].rate(coin1!, coin2!, swapModel)).toString();

          isReceiveAmt.value = false;
        } catch (e){
          isReceiveAmt.value = false;
        }
        
      }
    });
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
          swapModel.from = coin1!.code;
          swapModel.networkFrom = coin1!.network;
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          isCoin1.notifyListeners();
        //   swapModel.coinFrom = coin1.value.title;
        //   swapModel.networkFrom = coin1.value.networkCode;

        } else {

          coin2 = exchanges![currentIndex.value].coins[res];
          swapModel.to = coin2!.code;
          swapModel.networkTo = coin2!.network;
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          isCoin2.notifyListeners();
        }
        
      }
    });
  }

  void switchExchange(int index) async {

    if (index != currentIndex.value){

      isReady.value = false;

      currentIndex.value = index;

      await getExchangeCoins();

    }
  }

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

      if (Validator.swapValidator(swapModel.from!, swapModel.to!, swapModel.amt!.value) == true){
        isBtn.value = true;
      } else if (isReady.value == true){
        isBtn.value = false;
      }

    }

  }

  Future<void> swap() async {

    print("swap");

    try {

      dialogLoading(_context!);

      swapModel.withdrawalAddr = Provider.of<SDKProvider>(_context!, listen: false).getSdkImpl.evmAddress;
      await exchanges![currentIndex.value].swap(swapModel).then( (ExChangeTxI res){
        print(res.id);
        exchanges![currentIndex.value].tx.add( res );
      });

      // Close Dialog
      Navigator.pop(_context!);

    } catch (e) {
      
      // Close Dialog
      Navigator.pop(_context!);
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.error,
        text: '$e',
      );
    }

  }

  // Index Of List
  // Future<void> paySwap(int index) async {
    
  //   Navigator.push(
  //     _context!,
  //     MaterialPageRoute(builder: (context) => const PincodeScreen(title: '', label: PinCodeLabel.fromSendTx,))
  //   ).then((value) async {

  //     _paymentUcImpl.recipientController.text = lstTx![index].deposit!;
  //     _paymentUcImpl.amountController.text = lstTx![index].deposit_amount!;

  //     if (value != null){
  //       await _paymentUcImpl.sendBep20();
  //     }
  //   });

  // }

  Future<void> confirmSwap(int indx) async {
    index = indx;
    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => ConfirmSwapExchange(
        statusNotifier: statusNotifier, 
        exChangeTxI: exchanges![tabBarIndex.value].tx[index], 
        confirmSwap: swapping, 
        getStatus: getStatus
      ))
    );
  }

  Future<void> paySwap(int index) async {
    
    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => const PincodeScreen(title: '', label: PinCodeLabel.fromSendTx,))
    ).then((value) async {

      // _paymentUcImpl.recipientController.text = lstTx![index].depositAddress!;
      // _paymentUcImpl.amountController.text = lstTx![index].amount!;

      if (value != null){
        // await _paymentUcImpl.sendBep20();
      }
    });

  }

  Future<void> swapping() async {
    
    int index = Provider.of<WalletProvider>(_context!, listen: false).sortListContract!.indexWhere((model) {
      
      if ( swapModel.from!.toLowerCase() == model.symbol!.toLowerCase() ){
        return true;
      }

      return false;

    });

    if (index != -1){

      await Navigator.pushReplacement(
        _context!,
        MaterialPageRoute(builder: (context) => TokenPayment(index: index, address: swapModel.withdrawalAddr, amt: swapModel.amt!.value,))
      );
      
    } else {
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.warning,
        showCancelBtn: true,
        cancelBtnText: "Close",
        cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
        text: '${swapModel.networkFrom} (${swapModel.networkTo}) is not found. Please add contract token !',
        confirmBtnText: 'Add Contract',
        onConfirmBtnTap: (){
          // Navigator.pushReplacement(
          //   _context!, 
          //   MaterialPageRoute(builder: (context) => AddAsset(index: swapResModel.coinFrom!.network == "BSC" ? 0 : 1,))
          // );
        }
      );

    }
  }

  Future<void> getStatus() async {

  }

  void resetState() {

    if (swapModel.amt!.value.isNotEmpty) {
      swapModel.amt!.value = '';
      receivedAmt = '';
      
      isBtn.value = false;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      isReceiveAmt.notifyListeners();
    }

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