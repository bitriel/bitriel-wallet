import 'package:bitriel_wallet/index.dart';

class ImportWalletImpl implements ImportWalletUsecases {

  BuildContext? _context;

  TextEditingController seedController = TextEditingController();
  
  /// For Import Wallet
  ValueNotifier<bool> isSeedValid = ValueNotifier(false);

  SDKProvider? sdkProvider;
  
  final AccountManagementImpl _accountManagementImpl = AccountManagementImpl();

  bool? isMultiAcc = false;

  set setContext(BuildContext ctx) {
    _context = ctx;
    sdkProvider = Provider.of<SDKProvider>(ctx, listen: false);
  }
  
  /* ----------Import Account Functional---------- */
  
  @override
  void changeState(String seed){
    if (seed.split(" ").toList().length == 12 && seed.split(" ").toList().last != ""){
      isSeedValid.value = true;
    } else if (isSeedValid.value) {
      isSeedValid.value = false;
    }
  }

  @override
  void resetState(){
    isSeedValid.value = false;
  }

  @override
  Future<void> addAndImport(String pin) async {
    try {

      await _accountManagementImpl.addAndImport(sdkProvider!, _context!, seedController.text, pin);

      await _accountManagementImpl.verifyLaterData(sdkProvider, true);

      await _accountManagementImpl.accNavigation(_context!, isMultiAcc!);

      // if (isMultiAcc == true) {
      //   Navigator.popUntil(_context!, ModalRoute.withName("/${BitrielRouter.multiAccRoute}"));
      // }
      // else {
      //   Navigator.pushNamedAndRemoveUntil(_context!, "/${BitrielRouter.homeRoute}", (route) => false);
      // }

    } catch (e) {
      print("Error addAndImport $e");
    }

  }

}