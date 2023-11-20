import 'package:bitriel_wallet/domain/model/exchange.model/exchange.m.dart';
import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/exchange/confirm_swap.dart';

class ExchangeUcImpl<T> {

  ExchangeCoinI? coin1;
  ExchangeCoinI? coin2;
  ValueNotifier<bool> isCoin1 = ValueNotifier(false);
  ValueNotifier<bool> isCoin2 = ValueNotifier(false);

  List<ExchangeCoinI>? searched;
  ValueNotifier<bool> isSearching = ValueNotifier(false);

  // Notifier Field
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<bool> isExchangeStateReady = ValueNotifier(false);
  ValueNotifier<int> tabBarIndex = ValueNotifier(0);
  
  ValueNotifier<bool> isReady = ValueNotifier(false);
  ValueNotifier<bool> isBtn = ValueNotifier(false);

  ValueNotifier<bool> statusNotifier = ValueNotifier(false);
  ValueNotifier<bool> isReceiveAmt = ValueNotifier(false);

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
      Exchange(title: 'Exolix', confirmSwap: confirmSwap, instance: exolicUCImpl, storageKey: DbKey.lstExolicTxIds_key, getCoins: exolicUCImpl.getCoins, rate: exolicUCImpl.rate, swap: exolicUCImpl.exolixSwap, getStatus: exolicUCImpl.getStatus),
      Exchange(title: 'LetsExchange', confirmSwap: confirmSwap, instance: letsExchangeUCImpl, storageKey: DbKey.lstLetsExchangeTxIds, getCoins: letsExchangeUCImpl.getCoins, rate: letsExchangeUCImpl.rate, swap: letsExchangeUCImpl.letsExchangeSwap, getStatus: letsExchangeUCImpl.getStatus) 
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

    if (exchanges![tabBarIndex.value].tx.isEmpty){

      await _secureStorageImpl.readSecure(exchanges![tabBarIndex.value].storageKey!)!.then( (localLstTx){

        if (localLstTx.isNotEmpty){

          exchanges![tabBarIndex.value].tx = List<T>.from(json.decode(localLstTx)).map((e) {
            return exchanges![tabBarIndex.value].instance.fromJson(e);
          }).toList();
        }

      });
      
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      tabBarIndex.notifyListeners();
    }
  }

  void queryEstimateAmt() {

    if (isReceiveAmt.value == false && swapModel.withdrawAmt!.value.isNotEmpty && coin1 != null && coin2 != null) isReceiveAmt.value = true;

    EasyDebounce.debounce("queryEstimateAmt", const Duration(milliseconds: 800), () async {

      if (swapModel.withdrawAmt!.value.isNotEmpty && coin1 != null && coin2 != null){

        try {

          swapModel.depositAmt = (await exchanges![currentIndex.value].rate(coin1!, coin2!, swapModel)).toString();

          isReceiveAmt.value = false;

        } catch (e){
          isReceiveAmt.value = false;
        }
        
      }

      if (Validator.swapValidator(swapModel.from!, swapModel.to!, swapModel.withdrawAmt!.value) == true){
        isBtn.value = true;
      } else if (isReady.value == true){
        isBtn.value = false;
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
          coin2: coin2,
          exchangeUcImpl: this
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

        } else {

          coin2 = exchanges![currentIndex.value].coins[res];
          swapModel.to = coin2!.code;
          swapModel.networkTo = coin2!.network;

          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          isCoin2.notifyListeners();
        }

        queryEstimateAmt();
        
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

    final formattedValue = formatCurrencyText(swapModel.withdrawAmt!.value);

    swapModel.withdrawAmt!.value = formattedValue;

    if (swapModel.withdrawAmt!.value.isNotEmpty) {
      swapModel.withdrawAmt!.value = swapModel.withdrawAmt!.value.substring(0, swapModel.withdrawAmt!.value.length - 1);
    }

  }

  String formatCurrencyText(String value) {
    return value;
  }

  void formatDouble(String value) {

    if (swapModel.withdrawAmt!.value.replaceAll(".", "").length < 10){
      // Value Equal Empty & Not Contains "."
      if (value.contains(".") && !(swapModel.withdrawAmt!.value.contains(".")) && swapModel.withdrawAmt!.value.isEmpty){

        swapModel.withdrawAmt!.value = "0.";

      } 
      // Prevent Add "." Multiple Time.
      // Reject Input "." Evertime
      else if ( !(value.contains("."))) {

        swapModel.withdrawAmt!.value = swapModel.withdrawAmt!.value + value;

      }
      // Add "." For Only one time.
      else if ( !(swapModel.withdrawAmt!.value.contains(".")) ){

        swapModel.withdrawAmt!.value = swapModel.withdrawAmt!.value + value;
      
      }

      queryEstimateAmt();

    }

  }

  Future<void> swap() async {

    print("swap");

    try {

      dialogLoading(_context!);

      swapModel.withdrawalAddr = Provider.of<SDKProvider>(_context!, listen: false).getSdkImpl.evmAddress;

      await exchanges![currentIndex.value].swap(swapModel).then( (ExChangeTxI res){
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

  Future<void> confirmSwap(int indx) async {

    index = indx;
    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => ConfirmSwapExchange(
        exchangeName: exchanges![tabBarIndex.value].title!,
        index: indx,
        statusNotifier: statusNotifier, 
        exChangeTxI: exchanges![tabBarIndex.value].tx[indx], 
        confirmSwap: swapping, 
        getStatus: exchanges![tabBarIndex.value].getStatus
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

  Future<void> swapping(ExChangeTxI tx) async {
    
    print("swapping");
    
    int index = Provider.of<WalletProvider>(_context!, listen: false).sortListContract!.indexWhere((model) {
      
      if ( tx.coinFrom!.toLowerCase() == model.symbol!.toLowerCase() ){
        return true;
      }

      return false;

    });

    if (index != -1){

      await Navigator.pushReplacement(
        _context!,
        MaterialPageRoute(builder: (context) => TokenPayment(index: index, address: tx.depositAddr, amt: tx.withdrawalAmount,))
      );
      
    } else {
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.warning,
        showCancelBtn: true,
        cancelBtnText: "Close",
        cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
        text: '${tx.coinFrom} (${tx.coinFromNetwork}) is not found. Please add contract token !',
        confirmBtnText: 'Add Contract',
        onConfirmBtnTap: (){
          Navigator.pushReplacement(
            _context!, 
            MaterialPageRoute(builder: (context) => const AddAsset())
          );
        }
      );

    }
  }

  String? onSearched(String? value){

    print("onSearched $value");

    // EasyDebounce.debounce("search", const Duration(milliseconds: 600), () {
      
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      // isSearching.value = true;
      
      // searched = exchanges![currentIndex.value].coins.map((element) {
      //   if (value!.toLowerCase() == element.code!.toLowerCase()) return element;
      // }).cast<ExchangeCoinI>().toList();
      exchanges![currentIndex.value].coins.every((element) {

          print("value!.toLowerCase() ${value!.toLowerCase()}");
          print("element.code!.toLowerCase() ${element.code!.toLowerCase()}");
        if (value!.toLowerCase() == element.code!.toLowerCase()) {
          print("value!.toLowerCase() ${value.toLowerCase()}");
          print("element.code!.toLowerCase() ${element.code!.toLowerCase()}");
        }
        return false;
      });
      
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      // isSearching.value = false;
      
    // });

    return value;
  }

  void resetState() {

    if (swapModel.withdrawAmt!.value.isNotEmpty) {
      swapModel.withdrawAmt!.value = '';
      swapModel.depositAmt = '';
      
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