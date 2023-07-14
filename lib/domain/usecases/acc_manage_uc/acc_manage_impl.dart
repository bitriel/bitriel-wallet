import 'package:bitriel_wallet/index.dart';

class AccountManagementImpl extends AccountMangementUC {

  /// Index 0 = json data of seeds with pin and user name.
  /// 
  /// Index 1 = KeyPairData
  List<dynamic>? importData;

  SeedBackupData? _pk;

  List<UnverifySeed> unverifyList = [];

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> addAndImport(SDKProvier sdkProvider, BuildContext context, String seed, String pin) async {

    dialogLoading(context);

    try {

      // 1. Import And Add Account
      importData = await sdkProvider.importSeed(seed, pin);
      
      // Extract private from seed
      _pk = await sdkProvider.getSdkProvider.getPrivateKeyFromSeeds(importData![1], pin);

      // Use Seed to query EVM address
      // And Use PrivateKey to extract BTC native address.
      await sdkProvider.getSdkProvider.queryAddress(seed, _pk!.seed!, pin);

    }catch (e) {
      
      // Close Dialog Loading
      Navigator.pop(context);
      debugPrint("Error addAndImport $e");
    }
  }

  @override
  Future<void> verifyLaterData(SDKProvier? sdkProvider, bool status) async {

    await SecureStorageImpl().readSecure(DbKey.privateList)!.then((value) async {

      if(value.isNotEmpty){
        unverifyList = UnverifySeed().fromJsonDb(List<Map<String, dynamic>>.from(jsonDecode(value)));
      }

    });

    unverifyList.add(UnverifySeed.init(
      address: sdkProvider!.getSdkProvider.getSELAddress,
      status: status, 
      ethAddress: sdkProvider.getSdkProvider.evmAddress,
      btcAddress: sdkProvider.getSdkProvider.btcAddress// conProvider!.listContract[_apiProvider!.btcIndex].address
    ));

    await SecureStorageImpl().writeSecureList(DbKey.privateList, jsonEncode(UnverifySeed().unverifyListToJson(unverifyList)));
  }
  
}