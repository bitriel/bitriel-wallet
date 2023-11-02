import 'dart:async';

import 'package:bitriel_wallet/domain/model/network_m.dart';
import 'package:bitriel_wallet/index.dart';
// ignore: depend_on_referenced_packages
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_bitcoin/flutter_bitcoin.dart';

class BitrielSDKImpl implements BitrielSDKUseCase{
  
  final SdkRepoImpl sdkRepoImpl = SdkRepoImpl();

  final Web3RepoImpl _web3repoImpl = Web3RepoImpl();

  String get getSELAddress => sdkRepoImpl.getKeyring.current.address!;

  Keyring get getKeyring => sdkRepoImpl.getKeyring;
  WalletSDK get getWalletSdk => sdkRepoImpl.getWalletSdk;

  Web3Client get getBscClient => _web3repoImpl.getBscClient;
  Web3Client get getEthClient => _web3repoImpl.getEthClient;

  DeployedContract? bscDeployedContract;
  DeployedContract? etherDeployedContract;

  // Map<String, List<String>> lstSelendraNetwork = {};

  int networkIndex = 0;
  int connectedIndex = 0;

  List<NetworkModel> lstSelendraNetwork = [];
  
  final SecureStorageImpl _storageImpl = SecureStorageImpl();

  String? jsFile;

  BuildContext? context;

  set setBuildContext(BuildContext ctx) => context = ctx;

  set setIsMainnet(bool value){
    sdkRepoImpl.setIsMainnet = value;
    _web3repoImpl.setIsMainnet = value;
  }

  //
  //
  // ///////////////////////////////////////////////////////////////////////////
  /* ---------------------------------- Substrate ------------------------------ */
  // ///////////////////////////////////////////////////////////////////////////
  //
  //

  /// 1.
  @override
  Future<void> fetchNetwork() async {

    try {

      lstSelendraNetwork.clear();

      /// 1.1 Check Selendra Network
      await _storageImpl.isKeyAvailable(DbKey.sldNetwork).then((value) async {

        if (value == true){

          lstSelendraNetwork = NetworkModel().fromJson( Map<String, List<dynamic>>.from(json.decode( (await _storageImpl.readSecure(DbKey.sldNetwork))!) ));
        
        } else {

          await HttpRequestImpl().fetchSelendraEndpoint().then((value) async {
            
            lstSelendraNetwork = NetworkModel().fromJson( value );

            await _storageImpl.writeSecure(DbKey.sldNetwork, json.encode(value));

          });

        }
      });

      /// 1.2 Check Connected Network
      await _storageImpl.readSecure(DbKey.connectedIndex)!.then((value) {
        if (value.isNotEmpty){
          connectedIndex = json.decode(value);
        }
      });

    } catch (e){
      print("Error fetchNetwork $e");
    }
    
  }
  
  /// 2 
  @override
  Future<void> initBitrielSDK({required String jsFilePath}) async {

    await setNetworkParam(lstSelendraNetwork[networkIndex].lstNetwork![connectedIndex], networkIndex, connectedIndex);

    await rootBundle.loadString(jsFilePath).then((js) async {

      jsFile = js;
      // 2.1. Init Keyring
      await sdkRepoImpl.initBitrielSDK(jsCode: js);
    });
    
    await _web3repoImpl.web3Init();
    
  }

  /// Change Network Perform From Sdk Provider
  /// ep => endpoint
  @override
  Future<void> setNetworkParam(String network, int nwIndex, int epIndex) async {
    
    // Set Network Param with New Network Selected
    sdkRepoImpl.setNetworkParam(network: lstSelendraNetwork[nwIndex].lstNetwork![epIndex]);

    // Check If Current Index Selected
    if ( (connectedIndex != epIndex && networkIndex == nwIndex) || connectedIndex != nwIndex ){

      await sdkRepoImpl.connectNode(jsCode: jsFile!);

    }

  }

  @override
  Future<bool> validateMnemonic(String seed) async { 
    return await sdkRepoImpl.getWalletSdk.api.keyring.checkMnemonicValid(seed);
  }

  /// 3. Import and Add Account
  /// 
  /// Return Type Of List<dynamic> will return value
  /// 
  /// Index 0 = json data of seeds with pin and user name.
  /// 
  /// Index 1 = KeyPairData
  @override
  Future<List<dynamic>> importSeed(String seed, {KeyType keyType = KeyType.mnemonic, String? name = "Username", required String? pin}) async {

    // 3.1
    final jsn = await sdkRepoImpl.getWalletSdk.api.keyring.importAccount(
      sdkRepoImpl.getKeyring, 
      keyType: keyType, 
      key: seed, 
      name: name!, 
      password: pin!
    );

    // 3.2
    final keyPair = await sdkRepoImpl.getWalletSdk.api.keyring.addAccount(
      sdkRepoImpl.getKeyring, 
      keyType: keyType, 
      acc: jsn!, 
      password: pin
    );

    return [jsn, keyPair];

  }
  
  @override
  /// 4. Get Private Key
  /// 
  /// 4.1 We use private to backup seeds.
  Future<SeedBackupData?> getDecrypedSeed(KeyPairData keyPair, String pin) async {
    return await sdkRepoImpl.getWalletSdk.api.keyring.getDecryptedSeed(
      sdkRepoImpl.getKeyring, 
      sdkRepoImpl.getKeyring.current, 
      pin
    );
  }

  /// 5. Query Address from
  /// 5.1 BSC, BTC
  Future<void> queryAddress(String seed, String pk, String pin) async {
    // ignore: use_build_context_synchronously
    // await Provider.of<ContractProvider>(context, listen: false).extractAddress(_pk!);
    await extractEvmAddress(pk);
    await queryBtcData(seed, pin);

  }
  
  @override
  Future<String> generateSeed() async {
    return ( await sdkRepoImpl.getWalletSdk.api.keyring.generateMnemonic(sdkRepoImpl.getKeyring.ss58!) ).mnemonic!;
  }

  Future<void> deleteAccount(BuildContext? context) async {

    dialogLoading(context!);

    // final api = Provider.of<ApiProvider>(context, listen: false);
    
    try {

      for( KeyPairData e in sdkRepoImpl.getKeyring.allAccounts){
        await sdkRepoImpl.getWalletSdk.api.keyring.deleteAccount(
          sdkRepoImpl.getKeyring,
          e,
        );
      }

      await SecureStorage.deleteAll();

      // final mode = await StorageServices.fetchData(DbKey.themeMode);
      // final sldNW = await StorageServices.fetchData(DbKey.sldNetwork);

      // await StorageServices.clearStorage();

      // // Re-Save Them Mode
      // await StorageServices.storeData(mode, DbKey.themeMode);
      // await StorageServices.storeData(sldNW, DbKey.sldNetwork);

      // await StorageServices.clearSecure();
      
      // Provider.of<ContractProvider>(context, listen: false).resetConObject();
      // ignore: use_build_context_synchronously
      Provider.of<WalletProvider>(context, listen: false).initState();
      
      await Future.delayed(const Duration(seconds: 2), () {});
      
      // Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      // Navigator.pushAndRemoveUntil(
      //   context, 
      //   RouteAnimation(enterPage: const Onboarding()), ModalRoute.withName('/')
      // );

      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context, 
        "/${BitrielRouter.welcomeRoute}", 
        (route) => false
      );

    } catch (e) {

      if (kDebugMode) {
        print("Error delete account $e");
      }
      // await dialog(context, e.toString(), 'Opps');
    }
  }
  
  // 
  // 
  // ///////////////////////////////////////////////////////////////////////////
  /* ------------------------------------ Web3 ------------------------------ */
  // ///////////////////////////////////////////////////////////////////////////
  // 
  // 
  
  String? evmAddress;
  String? btcAddress;

  /// Extract Evm Address 0xa..
  @override
  Future<void> extractEvmAddress(String pk) async {
    final EthPrivateKey privateKey = EthPrivateKey.fromHex(pk);
    evmAddress = privateKey.address.toString();
  }
  

  // Extract BTC Address 13..
  Future<void> queryBtcData(String seeds, String pin) async {
    
    try {
      final seed = bip39.mnemonicToSeed(seeds);
      final hdWallet = HDWallet.fromSeed(seed);
      
      btcAddress = hdWallet.address!;
      
      final keyPair = ECPair.fromWIF(hdWallet.wif!);

      final bech32Address = P2WPKH(data: PaymentData(pubkey: keyPair.publicKey), network: bitcoin).data.address;
      
      await SecureStorage.writeData(key: DbKey.bech32, encodeValue: bech32Address);
      await SecureStorage.writeData(key: DbKey.hdWallet, encodeValue: hdWallet.address);

      final res = await encryptPrivateKey(hdWallet.wif!, pin);

      await SecureStorage.writeData(key: DbKey.btcwif, encodeValue: res);

    //   // Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain', context: context);

    //   // setBtcAddr(bech32Address!);
    //   // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
    //   // await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(context: context);

    //   contractPro.notifyListeners();

    } catch (e) {
      // await customDialog(context, 'Oops', e.toString());
    }
  }

  Future<EtherAmount> getBep20Balance(Web3Client client, EthereumAddress addr) async {
    return await client.getBalance(addr);
    // return EtherAmount.zero();

  }

  Future<EtherAmount> getErc20Balance(Web3Client client, EthereumAddress addr) async {
    return await client.getBalance(addr);
    // return EtherAmount.zero();

  }

  Future<EtherAmount> getEvmBalance(Web3Client client, EthereumAddress addr) async {
    return await client.getBalance(addr);

  }

  /// 1.
  /// For EVM no need to set contract Name
  Future<DeployedContract> deployContract(String abiPath, String contractAddr, {String? contractName}) async {
    final String contractJson = await rootBundle.loadString(abiPath);
    return DeployedContract(
      ContractAbi.fromJson(contractJson, contractName ?? 'contract'),
      EthereumAddress.fromHex(contractAddr),
    );

  }
  
  /// 2.
  /// e.g contract = contract.function('balanceOf')
  Future<List<dynamic>> callWeb3ContractFunc(Web3Client client, DeployedContract contract, String function, { List params = const [] }) async {
    
    try {
      
      return await _web3repoImpl.callWeb3ContractFunc(client, contract, contract.function(function), params: params);
    } catch (e) {
      print("Error callWeb3ContractFunc $e");
      throw Exception(e);
    }
  }

  Future<bool> validateWeb3Address(String addr) async {
    return await sdkRepoImpl.validateWeb3Address(addr);

  }

  EthPrivateKey getPrivateKey(String hex) {
    return EthPrivateKey.fromHex(hex);
  }

  Future<String?> encryptPrivateKey(String privateKey, String pin) async {
    final key = Encrypt.passwordToEncryptKey(pin);
    return await FlutterAesEcbPkcs5.encryptString(privateKey, key);

  }

  Future<String?> decryptPrivateKey({String? privateKey, String? pin}) async {
    final key = Encrypt.passwordToEncryptKey(pin!);
    return await FlutterAesEcbPkcs5.decryptString(privateKey!, key);

  }
}