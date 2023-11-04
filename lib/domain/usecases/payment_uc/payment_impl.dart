import 'dart:math';
import 'package:bitriel_wallet/domain/model/tx_history_m.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:get/utils.dart';
import 'package:pinput/pinput.dart';

class PaymentUcImpl implements PaymentUsecases {

  TextEditingController recipientController = TextEditingController();
  
  TextEditingController amountController = TextEditingController();

  WalletProvider? walletProvider;

  SDKProvider? _sdkProvider;
  BuildContext? context;

  ValueNotifier<int> index = ValueNotifier(0);

  ServiceTx get serviceTx => _sdkProvider!.getSdkImpl.getWalletSdk.api.service.tx;

  List<SmartContractModel> get lstContractDropDown => walletProvider!.sortListContract!;
  
  ValueNotifier<String> trxMessage = ValueNotifier("");

  ValueNotifier<bool> isReady = ValueNotifier(false);
  
  FocusNode addrNode = FocusNode();
  FocusNode amtNode = FocusNode();

  String urlLauncher = "";
  
  String? _pk;

  String? hash;
  
  TxHistoryModel? txHistoryModel;

  set setBuildContext(BuildContext ctx){
    context = ctx;
    walletProvider = Provider.of<WalletProvider>(ctx, listen: false);
    _sdkProvider = Provider.of<SDKProvider>(ctx, listen: false);
  }


  void assetChanged(int value){
    index.value = value;
  }

  void onChanged(String? value){

    if (addrNode.hasFocus){
      addressOnchanged(value);
    } else {
      amtOnchanged(value);
    }
  }
  
  void addressOnchanged(String? value){

    if (value!.isNotEmpty && value.length >= 2){
      if (value.toLowerCase().contains("0x") || (value[0] == "s" && value[1] == "e")){

        // If Not Yet Set False
        if (isReady.value == false){

          mainValidator();
        }

      // Prevent Rebuild When remove Text
      } else if (isReady.value == true) {

        isReady.value = false;
      }

    } else if (isReady.value == true) {

      isReady.value = false;
    }
  }

  void amtOnchanged(String? value){
    if (value!.isNotEmpty){
      mainValidator();
    } else if ( isReady.value == true ){
      isReady.value = false;
    }
  }

  String? addressValidator(String? value) {

    if (addrNode.hasFocus){

      if ( value!.isEmpty) {
        return "Field cannot emplty";
      }
      else if ( recipientController.length < 2 ){
        return "Invalid address";
      }
      else if ( !(value.toLowerCase().contains("0x")) && (value[0] != "s" && value[1] != "e") ){
        // If Not Yet Set False
        return "Invalid address";
      }

    }
    // Prevent Rebuild When remove Text
    return null;
  }

  String? amtValidator(String? value) {
    
    if (amtNode.hasFocus){
      if (value!.isEmpty){
      
        return "Field cannot emplty";
      }
    }
    return null;
  }

  void mainValidator() {
    if (amountController.text.isNotEmpty && recipientController.text.isNotEmpty) isReady.value = true;
  }
  Future<String?> _getPrivateKey(String pin) async {

    return await _sdkProvider!.getSdkImpl.decryptPrivateKey(privateKey: (await SecureStorageImpl().readSecure(DbKey.private)), pin: pin);
  }

  Future<void> submitTrx() async {

    try {
 
      String? pin = await Navigator.push(
        context!, 
        MaterialPageRoute(
          builder: (context) => const PincodeScreen(title: "PIN", label: PinCodeLabel.fromSendTx,)
        )
      );
      
      if (pin != null){
      
        dialogLoading(context!);

        print("walletProvider!.sortListContract![index.value].isNative ${walletProvider!.sortListContract![index.value].isNative}");

        // Catch Wrong Pin 
        // And throw To Main Error Handler
        try {
          
          _pk = await _getPrivateKey(pin);

          print("_pk $_pk");

        } catch (e) {
          throw "Wrong pin";
        }

        // Check Input Not Equal 0
        // Check Input Not Less than Existing coin's balance
        if ( amountController.text.isNotEmpty && double.parse(amountController.text) <= double.parse(lstContractDropDown[index.value].balance!) ){
          
          txHistoryModel = TxHistoryModel(
            from: walletProvider!.sortListContract![index.value].address,
            to: recipientController.text,
            amt: amountController.text
          );

          if (walletProvider!.sortListContract![index.value].isBep20 == true) {
            // if (checkFeeAndTrxAmount(double.parse(walletProvider!.listEvmNative![0].balance!), network: "BNB") == true) {

              urlLauncher = "https://testnet.bscscan.com/tx/";
              
              await sendBep20();

              addTrxHistory();

            // }
          }
          else if (walletProvider!.sortListContract![index.value].isErc20 == true){
            // if (checkFeeAndTrxAmount(double.parse(walletProvider!.listEvmNative![1].balance!), network: "Ethereum") == true) {

              urlLauncher = "https://goerli.etherscan.io/tx/";

              await sendErc20();

              addTrxHistory();

            // }
          }
          else if (walletProvider!.sortListContract![index.value].isBSC == true){

            urlLauncher = "https://testnet.bscscan.com/tx/";

            await sendBsc();

            addTrxHistory();

          }
          else if (walletProvider!.sortListContract![index.value].isEther == true){
            
            urlLauncher = "https://goerli.etherscan.io/tx/";
            
            await sendEther();

            addTrxHistory();
          }
          else {
            
            await sendNative();

            addTrxHistory();
          }
          
          // Save Trx Into Local Storage
          await walletProvider!.storeAssets();

          // Close Dialog Loading
          Navigator.pop(context!);

          await QuickAlert.show(
            context: context!,
            type: QuickAlertType.success,
            showCancelBtn: true,
            cancelBtnText: "View Transaction",
            cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
            text: 'Transaction Completed Successfully!',
            onCancelBtnTap: () async {
              await launchUrl(
                Uri.parse("$urlLauncher$hash"),
                mode: LaunchMode.externalApplication,
              );
            }
          );

          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          walletProvider!.notifyListeners();

        } else if (trxMessage.value.isEmpty) {

          // Close Dialog
          Navigator.pop(context!);
          
          trxMessage.value = "Balance must greater than 0";

          await QuickAlert.show(
            context: context!,
            type: QuickAlertType.warning,
            text: "Balance must greater than 0",
          );
        }
      }

    } catch (e) {

      // Close Dialog Loading
      Navigator.pop(context!);
      
      await QuickAlert.show(
        context: context!,
        type: QuickAlertType.error,
        text: '$e',
      );
    }
    
  }

  /// Send Token: BTC, SEL...
  Future<void> sendNative() async {
    print("sendNative");
    print(recipientController.text.toLowerCase().contains("se"));
    if (recipientController.text.toLowerCase().contains("se")){

      // Send SEL

      // 1. Assign Sender indentity.
      final sender = TxSenderData(
        _sdkProvider!.getSdkImpl.getKeyring.current.address,
        _sdkProvider!.getSdkImpl.getKeyring.current.pubKey
      );

      final txInfo = TxInfoData('balances', 'transfer', sender);

      // 2. Estimate Gas Fee
      // final fee = await serviceTx.estimateFees(
      //   txInfo.toJson(),
      //   jsonEncode([
      //     recipientController.text,
      //     Fmt.tokenInt(
      //       amountController.text,
      //       18,
      //     ).toString(),
      //   ]),
      // );

      // 3. Start Sign And Send Transaction
      await serviceTx.signAndSend(
        txInfo.toJson(), 
        jsonEncode([
          recipientController.text,
          Fmt.tokenInt(
            amountController.text,
            18,
          ).toString(),
        ]), 
        "111111", 
        (p0) => null
      ).then((value) {
        print("Value $value");
      });

    }
    else {
      // Send BTC
    }
  }

  bool checkFeeAndTrxAmount(double networkFee, {String network = ""}) {
    if (
      networkFee.isGreaterThan(0.0005)
    ){
      if ( double.parse(amountController.text) > double.parse(lstContractDropDown[index.value].balance!) ){
        trxMessage.value = "Input amount greater than your existing balance";
      }
      trxMessage.value = "Low gas fee of $network to make transaction";
      return false;
    }
    return true;
  }

  /// Sen Any Bep20 contract
  Future<void> sendBep20() async {
    print('sendBep20');
    try {
      
      // String encryptKey = (await SecureStorage.readData(key: DbKey.private))!;

      EthPrivateKey pkKey = _sdkProvider!.getSdkImpl.getPrivateKey(_pk!);

      _sdkProvider!.getSdkImpl.bscDeployedContract = await _sdkProvider!.getSdkImpl.deployContract("assets/json/abi/bep20.json", lstContractDropDown[index.value].contract!);

      // transaction fee 5 gwei, which is about $0.0005
      // 2
      BigInt networkGas = (await _sdkProvider!.getSdkImpl.getBscClient.estimateGas(
        sender: pkKey.address, //EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.evmAddress!),
        // to: EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.bscDeployedContract.address!),
        to: EthereumAddress.fromHex(lstContractDropDown[index.value].contract!),
        data: _sdkProvider!.getSdkImpl.bscDeployedContract!.function('transfer').encodeCall(
          [
            EthereumAddress.fromHex(recipientController.text),
            BigInt.from( double.parse(amountController.text) * pow(10, lstContractDropDown[index.value].chainDecimal!) )
          ],
        ),
      ));

      hash = await _sdkProvider!.getSdkImpl.getBscClient.sendTransaction(
        pkKey,
        Transaction.callContract(
          contract: _sdkProvider!.getSdkImpl.bscDeployedContract!,
          // gasPrice: gasPrice,
          maxGas: networkGas.toInt(),
          function: _sdkProvider!.getSdkImpl.bscDeployedContract!.function('transfer'), 
          parameters: [
            EthereumAddress.fromHex(recipientController.text),
            BigInt.from( double.parse(amountController.text) * pow(10, lstContractDropDown[index.value].chainDecimal!) )
          ],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
    } catch (e) {
    }
  }

  /// Send Any Erc20 contract
  Future<void> sendErc20() async {
    try {

      EthPrivateKey pkKey = _sdkProvider!.getSdkImpl.getPrivateKey(_pk!);

      _sdkProvider!.getSdkImpl.etherDeployedContract = await _sdkProvider!.getSdkImpl.deployContract("assets/json/abi/erc20.json", lstContractDropDown[index.value].contract!);

      // transaction fee 5 gwei, which is about $0.0005
      // 2
      BigInt networkGas = (await _sdkProvider!.getSdkImpl.getEthClient.estimateGas(
        sender: pkKey.address, //EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.evmAddress!),
        // to: EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.bscDeployedContract.address!),
        to: EthereumAddress.fromHex(lstContractDropDown[index.value].contract!),
        data: _sdkProvider!.getSdkImpl.etherDeployedContract!.function('transfer').encodeCall(
          [
            EthereumAddress.fromHex(recipientController.text),
            BigInt.from( double.parse(amountController.text) * pow(10, lstContractDropDown[index.value].chainDecimal!) )
          ],
        ),
      ));

      hash = await _sdkProvider!.getSdkImpl.getEthClient.sendTransaction(
        pkKey,
        Transaction.callContract(
          contract: _sdkProvider!.getSdkImpl.etherDeployedContract!,
          // gasPrice: gasPrice,
          maxGas: networkGas.toInt(),
          function: _sdkProvider!.getSdkImpl.etherDeployedContract!.function('transfer'), 
          parameters: [
            EthereumAddress.fromHex(recipientController.text),
            BigInt.from( double.parse(amountController.text) * pow(10, lstContractDropDown[index.value].chainDecimal!) )
          ],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
    } catch (e) {
      print("error sendErc20 ${e}");
    }
  }

  /// Send BNB
  Future<void> sendBsc() async {
    try {
      
      // 1

      EthPrivateKey pkKey = _sdkProvider!.getSdkImpl.getPrivateKey(_pk!);

      // transaction fee 5 gwei, which is about $0.0005
      // 2
      BigInt networkGas = (await _sdkProvider!.getSdkImpl.getBscClient.estimateGas(
        sender: pkKey.address, //EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.evmAddress!),
        // to: EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.bscDeployedContract.address!),
        to: EthereumAddress.fromHex(recipientController.text),
        value: EtherAmount.inWei(BigInt.from( double.parse(amountController.text) * pow(10, 18) )),
      ));

      hash = await _sdkProvider!.getSdkImpl.getBscClient.sendTransaction(
        pkKey,
        Transaction(
          // gasPrice: gasPrice,
          maxGas: networkGas.toInt(),
          to: EthereumAddress.fromHex(recipientController.text),
          value: EtherAmount.inWei(BigInt.from( double.parse(amountController.text) * pow(10, 18) )),
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
    } catch (e) {
      print("error sendBsc ${e}");
    }
  }

  /// Send Ethereum
  Future<void> sendEther() async {

    print('sendEther');
    try {
      
      // 1
      
      // String encryptKey = (await SecureStorage.readData(key: DbKey.private))!;

      EthPrivateKey pkKey = _sdkProvider!.getSdkImpl.getPrivateKey(_pk!);

      // transaction fee 5 gwei, which is about $0.0005
      // 2
      BigInt networkGas = (await _sdkProvider!.getSdkImpl.getEthClient.estimateGas(
        sender: pkKey.address, //EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.evmAddress!),
        // to: EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.bscDeployedContract.address!),
        to: EthereumAddress.fromHex(recipientController.text),
        value: EtherAmount.inWei(BigInt.from( double.parse(amountController.text) * pow(10, 18) )),
      ));

      hash = await _sdkProvider!.getSdkImpl.getEthClient.sendTransaction(
        pkKey,
        Transaction(
          // gasPrice: gasPrice,
          maxGas: networkGas.toInt(),
          to: EthereumAddress.fromHex(recipientController.text),
          value: EtherAmount.inWei(BigInt.from( double.parse(amountController.text) * pow(10, 18) )),
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
    } catch (e) {
      print("error sendEther ${e}");
    }

  }

  void addTrxHistory() async {

    // Assign Launcher Explorer
    txHistoryModel!.networkHash = "$urlLauncher$hash";

    // This add tx histroy also effect to [ DefaultListContract Or AddedContract ] Object.
    walletProvider!.sortListContract![index.value].trxHistory!.add(txHistoryModel!);
    
  }

  Future<void> submitSwap() async {
    
  }

}