import 'package:bitriel_wallet/data/repository/exolix_ex_repo/exolix_ex_repo_impl.dart';
import 'package:bitriel_wallet/domain/model/exolix_ex_coin_m.dart';
import 'package:bitriel_wallet/domain/usecases/swap_uc/exolix_uc/exolix_ex_uc.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/swap_exolix_ex/select_swap_token_screen.dart' as exo_swap_screen;
import 'package:bitriel_wallet/presentation/screen/swap_exolix_ex/confirm_swap_ex.dart' as exo_confirm_swap;

Map map = {"id":"excbb7dadcd446","amount":0.028,"amountTo":0.21790163,"coinFrom":{"coinCode":"ETH","coinName":"Ethereum","network":"BSC","networkName":"BNB Smart Chain (BEP20)","networkShortName":"BEP20","icon":"https://exolix.com/icons/coins/ETH.png","memoName":""},"coinTo":{"coinCode":"BNB","coinName":"BNB","network":"BSC","networkName":"BNB Smart Chain (BEP20)","networkShortName":"BEP20","icon":"https://exolix.com/icons/coins/BNB.png","memoName":""},"comment":null,"createdAt":"2023-10-26T16:38:18.576Z","depositAddress":"0xF8Aa60E01dd625Ccc9Ce2DEb267ad91c9a8a80ad","depositExtraId":null,"withdrawalAddress":"0x8b8aa19ad5fa4e08980de2285e2038d50844f83a","withdrawalExtraId":null,"refundAddress":null,"refundExtraId":null,"hashIn":{"hash":null,"link":null},"hashOut":{"hash":null,"link":null},"rate":7.78220107,"rateType":"fixed","affiliateToken":null,"status":"wait","email":null};

class ExolixExchangeUCImpl implements ExolixExchangeUseCases {

  BuildContext? _context;

  ValueNotifier<ExolixExCoinByNetworkModel> coin1 = ValueNotifier(ExolixExCoinByNetworkModel());

  ValueNotifier<ExolixExCoinByNetworkModel> coin2 = ValueNotifier(ExolixExCoinByNetworkModel());
  
  ValueNotifier<bool> isLstCoinReady = ValueNotifier(false);

  ValueNotifier<String> receiveAmt = ValueNotifier("");

  final ExolixExchangeRepoImpl _exolixExchangeRepoImpl = ExolixExchangeRepoImpl();

  List<ExolixExchangeCoin> defaultLstCoins = [];

  Widget? imgConversion;

  ExolixSwapModel swapModel = ExolixSwapModel();

  final PaymentUcImpl _paymentUcImpl = PaymentUcImpl();

  ValueNotifier<List<ExolixExCoinByNetworkModel>> lstLECoin = ValueNotifier([]);

  ValueNotifier<List<ExolixSwapResModel?>> lstTx = ValueNotifier([null]);
  
  ValueNotifier<bool> isReady = ValueNotifier(false);

  int? index;

  set setContext(BuildContext ctx){
    _context = ctx;
    _paymentUcImpl.setBuildContext = ctx;
  }

  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  @override
  Future<void> getExolixExchangeCoin() async {

    print("getExolixExchangeCoin");
    
    if(defaultLstCoins.isEmpty){
      defaultLstCoins = await _exolixExchangeRepoImpl.getExolixExchangeCoin();
    }

    if (lstTx.value[0] == null){

      _secureStorageImpl.readSecure(DbKey.lstTxIds)!.then( (localLstTx){

        lstTx.value.clear();

        // ignore: unnecessary_null_comparison
        if (localLstTx.isNotEmpty){

          lstTx.value = List<Map<String, dynamic>>.from((json.decode(localLstTx))).map((e) {
            return ExolixSwapResModel.fromJson(e);
          }).toList();
        }

        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        lstTx.notifyListeners();

      });
    }

    lstCoinExtract();
    
  }
  
  void lstCoinExtract() {

    for(int i = 0; i < defaultLstCoins.length; i++){

      for (int j = 0; j < defaultLstCoins[i].networks!.length; j++){
        addCoinByIndex(i, j);
      }

    }

    isLstCoinReady.value = true;
    
  }

  void addCoinByIndex(int i, int j) {

    if (
      defaultLstCoins[i].networks![j].network == "BTC" ||
      defaultLstCoins[i].networks![j].network == "BSC" ||
      defaultLstCoins[i].networks![j].network == "ETH"
    ){

      lstLECoin.value.add(
        ExolixExCoinByNetworkModel(
          title: defaultLstCoins[i].code,
          subtitle: defaultLstCoins[i].name,
          image: Container(),//imgConversion!,
          network: defaultLstCoins[i].networks![j].name!,
          networkCode: defaultLstCoins[i].networks![j].network,
          balance: "0"//contractProvider!.sortListContract[i].balance,
          
        )
      );
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

  @override
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

      if (Validator.swapValidator(swapModel.coinFrom!, swapModel.coinTo!, swapModel.amt!.value) == true){
        isReady.value = true;
      } else if (isReady.value == true){
        isReady.value = false;
      }
    }

  }

  void queryEstimateAmt() {

    if (swapModel.coinFrom!.isNotEmpty && swapModel.coinTo!.isNotEmpty){
      EasyDebounce.debounce("tag", const Duration(milliseconds: 500), () async {
        await _exolixExchangeRepoImpl.exolixTwoCoinInfo({
          "coinFrom": swapModel.coinFrom,
          "coinTo": swapModel.coinTo,
          "coinFromNetwork": swapModel.networkFrom,
          "coinToNetwork": swapModel.networkTo,
          "amount": swapModel.amt!.value,
          "rateType": "fixed"
        }).then((value) {

          if (value.statusCode == 200) {
            receiveAmt.value = (json.decode(value.body))['toAmount'].toString();
          }
        });
      });
    }
  }

  void setCoin(BuildContext context, bool isFrom){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => exo_swap_screen.SelectSwapToken(itemLE: lstLECoin.value))
    ).then((res) {

      if (res != null){

        if (isFrom == true){

          coin1.value = lstLECoin.value[res];
          swapModel.coinFrom = coin1.value.title;
          swapModel.networkFrom = coin1.value.networkCode;

        } else {
          
          coin2.value = lstLECoin.value[res];
          swapModel.coinTo = coin2.value.title;
          swapModel.networkTo = coin2.value.networkCode;
        }

        swapModel.withdrawalAddress = Provider.of<SDKProvider>(context, listen: false).getSdkImpl.evmAddress;
        
        queryEstimateAmt();
        
        if (Validator.swapValidator(swapModel.coinFrom!, swapModel.coinTo!, swapModel.amt!.value) == true){
          isReady.value = true;
        } else if (isReady.value == false) {
          isReady.value = false;
        }
        
      }
    });
  }

  @override
  Future<void> exolixSwap() async {

    try {

      // Response value = Response(json.encode(map), 200);

      dialogLoading(_context!);

      await _exolixExchangeRepoImpl.exolixSwap(swapModel.toJson()).then((value) async {

        print("Value ${value.body}");
        
        if (value.statusCode == 401){
          throw json.decode(value.body)['error'];
        }
        // Unprocessable entity
        else if (value.statusCode == 422) {
          throw "Such exchange pair is not available"; 
        }

        else if (value.statusCode == 201) {

          lstTx.value.add(ExolixSwapResModel.fromJson(json.decode(value.body)));
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          lstTx.notifyListeners();
          
          await SecureStorageImpl().writeSecure(DbKey.lstTxIds, value.body);

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
            onConfirmBtnTap: () async {
              await exolixConfirmSwap(lstTx.value.length-1);
            },
          );
        } else {
          throw json.decode(value.body);
        }
      });

    } catch (e) {

      print(e);

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
  Future<void> paySwap(int index) async {
    
    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => const PincodeScreen(title: '', label: PinCodeLabel.fromSendTx,))
    ).then((value) async {

      _paymentUcImpl.recipientController.text = lstTx.value[index]!.depositAddress!;
      _paymentUcImpl.amountController.text = lstTx.value[index]!.amount!;

      if (value != null){
        await _paymentUcImpl.sendBep20();
      }
    });

  }

  @override
  Future<void> exolixConfirmSwap(int indx) async {
    index = indx;
    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => exo_confirm_swap.ConfirmSwapExchange(swapResModel: lstTx.value[indx], confirmSwap: exolixSwapping, getStatus: getStatus))
    );
  }

  @override
  Future<void> exolixSwapping(ExolixSwapResModel swapResModel) async {
    
    int index = Provider.of<WalletProvider>(_context!, listen: false).sortListContract!.indexWhere((model) {
      
      if ( swapResModel.coinFrom!.coinCode!.toLowerCase() == model.symbol!.toLowerCase() ){
        isReady.value = true;
        return true;
      }

      return false;

    });

    if (index != -1){

      await Navigator.pushReplacement(
        _context!,
        MaterialPageRoute(builder: (context) => TokenPayment(index: index, address: swapResModel.withdrawalAddress, amt: swapResModel.amount,))
      );
      
    } else {
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.warning,
        showCancelBtn: true,
        cancelBtnText: "Close",
        cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
        text: '${swapResModel.coinFrom!.coinCode!} (${swapResModel.coinFrom!.network}) is not found. Please add contract token !',
        confirmBtnText: 'Add Contract',
        onConfirmBtnTap: (){
          Navigator.pushReplacement(
            _context!, 
            MaterialPageRoute(builder: (context) => AddAsset(index: swapResModel.coinFrom!.network == "BSC" ? 0 : 1,))
          );
        }
      );

    }
  }

  /// This function for update status inside details
  Future<void> getStatus() async {
    
    dialogLoading(_context!, content: "Checking Status");

    await _exolixExchangeRepoImpl.getExolixExStatusByTxId(lstTx.value[index!]!.id!).then((value) {
      
      lstTx.value[index!] = ExolixSwapResModel.fromJson(json.decode(value.body));

    });

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    lstTx.notifyListeners();

    await SecureStorageImpl().writeSecure(DbKey.lstTxIds, json.encode(ExolixSwapResModel().toJson(lstTx.value)));

    // Close Dialog
    Navigator.pop(_context!);
  }

}