import 'dart:async';
import 'package:bitriel_wallet/domain/model/network_m.dart';
import 'package:bitriel_wallet/index.dart';

class SDKProvider with ChangeNotifier {

  final BitrielSDKImpl _sdkImpl = BitrielSDKImpl();

  BitrielSDKImpl get getSdkImpl => _sdkImpl;
  
  bool isConnected = false;

  bool connectFailed = false;

  final AccountManagementImpl accountManagementImpl = AccountManagementImpl();

  String? dirPath;

  List<UnverifySeed> get getUnverifyAcc => accountManagementImpl.unVerifyAccount;

  ValueNotifier<bool> isMainnet = ValueNotifier(true);

  int currentAccIndex = -1;

  // get bool getIsMainNet => _sdkImpl.

  set setBuildContext(BuildContext ctx) {

    _sdkImpl.setBuildContext = ctx;

    getApplicationDocumentsDirectory().then((value) {
      dirPath = value.path;
      notifyListeners();
    });
  }

  set setIsMainnet(bool value){

    isMainnet.value = value;
    _sdkImpl.setIsMainnet = value;

  }

  set setEvmAddress(String value){

    _sdkImpl.evmAddress = value;
    notifyListeners();

  }

  set setBtcAddress(String value){

    _sdkImpl.btcAddress = value;
    notifyListeners();
    
  }

  List<NetworkModel> get getLstSelNetwork => _sdkImpl.lstSelendraNetwork;

  /// 1.
  void connectNetwork() async {

    await _sdkImpl.fetchNetwork();

    // 1.1. Set Paramter Network

    // 1.2. Connect Network after setup param.
    await _sdkImpl.initBitrielSDK(jsFilePath: "assets/js/main.js");

    isConnected = true;

    notifyListeners();
    
  }

  /// Change Network
  Future<void> setNetworkParamState(NetworkModel nwModel, int nwIndex, int epIndex, Function modalBottomSetState) async {

    if ( (_sdkImpl.networkIndex == nwIndex && _sdkImpl.connectedIndex != epIndex) || _sdkImpl.networkIndex != nwIndex ){

      dialogLoading(_sdkImpl.context!);

      isConnected = false;

      await _sdkImpl.setNetworkParam(nwModel.network == Network.Mainnet ? "Mainnet" : "Testnet", nwIndex, epIndex);
    }
  }

  /// Terminator Function If Can't connection Network in 13seconds.
  /// 
  /// connectionTerminator not inside sdk_uc because we need to use notifyListeners of Sdk Provider.
  /// 
  // void connectionTerminator(bool isSuccess, Function changeModalBottomState) async {

  //   // Close Dialog Loading
  //   // ignore: use_build_context_synchronously
  //   Navigator.pop(_sdkImpl.context!);
  //   // Close modalBottomDialog
  //   Navigator.pop(_sdkImpl.context!);
    
  //   if (isSuccess == true) {
      
  //     changeModalBottomState(() {});

  //     _sdkImpl.networkIndex = _sdkImpl.networkIndex == 0 ? 1 : 0;
  //     _sdkImpl.connectedIndex = _sdkImpl.connectedIndex == 0 ? 1 : 0;
      
  //     isConnected = true;

  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(_sdkImpl.context!).showSnackBar(
  //       const SnackBar(content: Text("Connection Success"))
  //     );
        
  //     // Store Index of new Network connect successful.
  //     await SecureStorage.writeData(key: DbKey.connectedIndex, encodeValue: json.encode(_sdkImpl.connectedIndex));
  //   }

  //   // Connection Failed
  //   else {

  //     // In this connect failed:
  //     // Reset Set Param To previous Network sdk_uc_impl.dart file line 83
  //     _sdkImpl.setNetworkParam(_sdkImpl.lstSelendraNetwork[_sdkImpl.networkIndex].lstNetwork![_sdkImpl.connectedIndex], _sdkImpl.networkIndex, _sdkImpl.connectedIndex);

  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(_sdkImpl.context!).showSnackBar(
  //       const SnackBar(content: Text("Connect RP1 failed"))
  //     );

  //     await _sdkImpl.sdkRepoImpl.connectNode(jsCode: _sdkImpl.jsFile!);
      
  //   }

  //   connectFailed = isSuccess;
    
  //   notifyListeners();
  // }
  
  Future<List<dynamic>> importSeed(String seed, String pwd) async {
    return await _sdkImpl.importSeed(seed, pin: pwd);
  }
  
  /// Fetch accounts (Import & Create New) from Local Storage
  /// To Identify status verify at Wallet screen.
  /// And Setup Evm and BTC Address 
  Future<void> fetchAllAccount() async {
    
    if (currentAccIndex == -1){
      await accountManagementImpl.fetchAccount();

      currentAccIndex = _sdkImpl.getKeyring.allAccounts.indexWhere((element) {
        
        if (_sdkImpl.getKeyring.current.address == element.address) return true;

        return false;
      });

      setEvmAddress = getUnverifyAcc[currentAccIndex].ethAddress!;
      
      setBtcAddress = getUnverifyAcc[currentAccIndex].btcAddress!;
    }

  }

  Future<void> disconnect() async {
    await _sdkImpl.sdkRepoImpl.disconnectNode();
  }

  void updateWalletNameData() {
    // Update the data that the widget depends on
    notifyListeners(); // Notify listeners to rebuild widgets that depend on this provider
  }

}