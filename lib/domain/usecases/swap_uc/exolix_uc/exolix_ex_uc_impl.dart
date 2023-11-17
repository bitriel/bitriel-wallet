import 'package:bitriel_wallet/data/repository/exolix_ex_repo/exolix_ex_repo_impl.dart';
import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';
import 'package:bitriel_wallet/domain/usecases/swap_uc/exolix_uc/exolix_ex_uc.dart';
import 'package:bitriel_wallet/index.dart';

Map map = {"id":"ex5ec4c12c76d7","amount":1,"amountTo":752.47824881,"coinFrom":{"coinCode":"ETH","coinName":"Ethereum","network":"ETH","networkName":"Ethereum","networkShortName":"ERC20","icon":"https://exolix.com/icons/coins/ETH.png","memoName":""},"coinTo":{"coinCode":"CAKE","coinName":"PancakeSwap","network":"BSC","networkName":"BNB Smart Chain (BEP20)","networkShortName":"BEP20","icon":"https://exolix.com/icons/coins/CAKE.png","memoName":""},"comment":null,"createdAt":"2023-11-16T07:41:32.682Z","depositAddress":"0xC1AA43D509ea7f840DDeC6721f6601E552a3803b","depositExtraId":null,"withdrawalAddress":"0xe11175d356d20b70abcec858c6b82b226e988941","withdrawalExtraId":null,"refundAddress":"0xe11175d356d20b70abcec858c6b82b226e988941","refundExtraId":null,"hashIn":{"hash":null,"link":null},"hashOut":{"hash":null,"link":null},"rate":752.47824881,"rateType":"fixed","affiliateToken":null,"status":"wait","source":"api","email":null};

class ExolixExchangeUCImpl<T> implements ExolixExchangeUseCases, ExchangeCoinI, ExChangeTxI {

  final ExolixExchangeRepoImpl _exolixExchangeRepoImpl = ExolixExchangeRepoImpl();

  List<Map<String, dynamic>> defaultLstCoins = [];

  ExolixSwapModel swapModel = ExolixSwapModel();

  final PaymentUcImpl _paymentUcImpl = PaymentUcImpl();

  // List<ExolixSwapResModel>? lstTx = [];
  List<Map<String, dynamic>>? lstTx = [];

  BuildContext? _context;

  int? index;
  
  List<ExchangeCoinI> filteredCoins = [];
  ExChangeTxI? tx;

  @override
  String? code, coinName, network, networkName, shortName, icon;
  ExolixExchangeUCImpl();
  ExolixExchangeUCImpl.mapping({this.code, this.coinName, this.network, this.networkName, this.icon, this.shortName});

  @override
  String? id, coinFrom ,coinFromNetwork ,coinFromIcon, coinFromNetworkName ,coinTo, coinToNetworkName ,coinToNetwork ,coinToIcon ,depositAddr ,depositAmt ,withdrawalAddress ,createdAt ,withdrawalAmount;
  @override
  ValueNotifier<String>? status;
  ExolixExchangeUCImpl.txMapping({
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
    return ExolixExchangeUCImpl.txMapping(
      id: jsn['id'],

      coinFrom: jsn['coinFrom']['coinCode'],
      coinFromNetwork: jsn['coinFromNetwork'],
      coinFromNetworkName: jsn['coinFrom']['networkName'],
      coinFromIcon: jsn['coinFrom']['icon'],

      coinTo: jsn['coinTo']['coinCode'],
      coinToNetwork: jsn['coinTo']['networkShortName'],
      coinToNetworkName: jsn['coinTo']['networkShortName'],
      coinToIcon: jsn['coinTo']['icon'],

      depositAddr: jsn['depositAddress'],
      depositAmt: jsn['amountTo'].toString(),

      withdrawalAddress: jsn['withdrawalAddress'],
      withdrawalAmount: jsn['amount'].toString(),

      createdAt: jsn['createdAt'],
      status: ValueNotifier(jsn['status']),

    );
  }

  @override
  Future<List<ExchangeCoinI>> getCoins() async {

    defaultLstCoins = await _exolixExchangeRepoImpl.getExolixExchangeCoin();
    
    for (var element in defaultLstCoins) {
      
      filteredCoins.addAll(List<Map<String, dynamic>>.from(element['networks']).map((e) {
        
        return ExolixExchangeUCImpl.mapping(
          code: element['code'], 
          coinName: element['name'], 
          icon: element['icon'],
          network: e['network'],
          networkName: e['name'],
          shortName: e['shortName'].toString().isEmpty ? null : e['shortName']
        );
        
      }));

    }
    
    return filteredCoins;
    
  }

  set setContext(BuildContext ctx){
    _context = ctx;
    _paymentUcImpl.setBuildContext = ctx;
  }

  @override
  Future<List<T>> getExolixExchangeCoin() async {

    defaultLstCoins = await _exolixExchangeRepoImpl.getExolixExchangeCoin();

    return defaultLstCoins as List<T>;
    
  }

  @override
  Future<String> rate(ExchangeCoinI coin1, ExchangeCoinI coin2, SwapModel swapModel) async {

    return await _exolixExchangeRepoImpl.exolixTwoCoinInfo(
      "coinFrom=${coin1.code}&networkFrom=${coin1.network}&coinTo=${coin2.code}&networkTo=${coin2.network}&amount=${swapModel.amt!.value}&rateType=fixed"
    ).then((value) => json.decode(value.body)['toAmount'].toString());

  }

  @override
  Future<ExChangeTxI> exolixSwap(SwapModel swapModel) async {

    Map<String, dynamic> body = {
      "coinFrom": swapModel.from,
      "coinTo": swapModel.to,
      "networkFrom": swapModel.networkFrom,
      "networkTo": swapModel.networkTo,
      "amount": swapModel.amt!.value,
      "withdrawalAddress": Provider.of<SDKProvider>(_context!, listen: false).getSdkImpl.evmAddress,
      "refundAddress": Provider.of<SDKProvider>(_context!, listen: false).getSdkImpl.evmAddress
    };

    Response value = Response(json.encode(map), 201);

    // return await _exolixExchangeRepoImpl.exolixSwap(body).then((value) async {
    return await Future.delayed(const Duration(seconds: 1), () async {
      
      if (value.statusCode == 401){
        throw json.decode(value.body)['error'];
      }
      // Unprocessable entity
      else if (value.statusCode == 422) {
        throw "Such exchange pair is not available"; 
      }

      else if (value.statusCode == 201) {

        lstTx!.add(json.decode(value.body));
        
        await SecureStorageImpl().writeSecure(DbKey.lstExolicTxIds_key, json.encode(lstTx));

        await QuickAlert.show(
          context: _context!,
          type: QuickAlertType.success,
          showCancelBtn: true,
          cancelBtnText: "Close",
          cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
          confirmBtnText: "Confirm",
          text: 'Swap Successfully!',
          onConfirmBtnTap: () async {
            await exolixConfirmSwap(lstTx!.length - 1);
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
    
    // Navigator.push(
    //   _context!,
    //   MaterialPageRoute(builder: (context) => const PincodeScreen(title: '', label: PinCodeLabel.fromSendTx,))
    // ).then((value) async {

    //   _paymentUcImpl.recipientController.text = lstTx![index].depositAddress!;
    //   _paymentUcImpl.amountController.text = lstTx![index].amount!;

    //   if (value != null){
    //     await _paymentUcImpl.sendBep20();
    //   }
    // });

  }

  @override
  Future<void> exolixConfirmSwap(int indx) async {
    
    // index = indx;
    // Navigator.push(
    //   _context!,
    //   MaterialPageRoute(builder: (context) => exo_confirm_swap.ConfirmSwapExchange(statusNotifier: statusNotifier, swapResModel: lstTx?[indx], confirmSwap: exolixSwapping, getStatus: getStatus))
    // );
  }

  @override
  Future<void> exolixSwapping(ExolixSwapResModel swapResModel) async {
    
    int index = Provider.of<WalletProvider>(_context!, listen: false).sortListContract!.indexWhere((model) {
      
      if ( swapResModel.coinFrom!.coinCode!.toLowerCase() == model.symbol!.toLowerCase() ){
        return true;
      }

      return false;

    });

    if (index != -1){

      await Navigator.pushReplacement(
        _context!,
        MaterialPageRoute(builder: (context) => TokenPayment(index: index, address: swapResModel.depositAddress, amt: swapResModel.amount,))
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
  Future<ExolixSwapResModel> getStatus() async {

    // dialogLoading(_context!, content: "Checking Status");

    // await _exolixExchangeRepoImpl.getExolixExStatusByTxId(lstTx![index!].id!).then((value) {
      
    //   print("value ${json.decode(value.body)['status']}");
    //   lstTx?[index!] = ExolixSwapResModel.fromJson(json.decode(value.body));

    //   print("getStatus ${lstTx?[index!].status}");

    // });

    // await SecureStorageImpl().writeSecure(DbKey.lstExolicTxIds_key, json.encode(ExolixSwapResModel().toJson(lstTx!)));

    // // Close Dialog
    // Navigator.pop(_context!);

    // return lstTx![index!];
    return ExolixSwapResModel();
  }

}