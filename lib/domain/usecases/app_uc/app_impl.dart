import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/auth_screen.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class AppUsecasesImpl implements AppUsecases {

  final LocalAuthentication _localAuth = LocalAuthentication();
  
  BuildContext? _context;
  SDKProvider? sdkProvider;

  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);

  int? accIndex;

  String? oldPin;
  String? newPin;

  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  set setBuildContext(BuildContext ctx){
    _context = ctx;
    sdkProvider = Provider.of<SDKProvider>(ctx, listen: true);
  }
    
  @override
  Future<bool> authenticateBiometric() async {
    // Trigger Authentication By Finger Print or PIN
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        options: const AuthenticationOptions(useErrorDialogs: false),
      );
      return didAuthenticate;  // Return the authentication result
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Add handling of no hardware here.
        await QuickAlert.show(
          context: _context!,
          type: QuickAlertType.error,
          text: "Authentication not available",
        );
      } else if (e.code == auth_error.notEnrolled) {
        await QuickAlert.show(
          context: _context!,
          type: QuickAlertType.error,
          text: "Authentication not yet enrolled",
        );
      } else {
        // ...
      }
      return false;  // Return false in case of any exception
    }
  }

  @override
  Future<void> authPopup(BuildContext context) async {
    
    await authenticateBiometric().then((value) {
      if(value == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false 
        );
      }
    });
  }

  // Called in privacy and splash screen
  @override
  Future<void> readBio(BuildContext context, {bool isPrivacy = false}) async{
    
    if (await SecureStorage.isContain(DbKey.bio)){

      await SecureStorage.readData(key: DbKey.bio).then((value) async {
      
        isAuthenticated.value = bool.parse(value!);

        // If False Means Navigation Occure Only For Splash Screen

        // Splash Screen
        if (isPrivacy == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false 
          );
        }

      });

    } else if (isPrivacy == false) {
      checkAccountExist();
    }

  }

  @override
  Future<void> enableBiometric(bool switchValue) async {

    await authenticateBiometric().then((values) async {

      if(values == true) {

        isAuthenticated.value = switchValue;

        if (isAuthenticated.value) {
          // Save local storage key
          await SecureStorage.writeBio(key: DbKey.bio, encodeValue: isAuthenticated.value); 

        } else {
          // Remove local storage key
          await SecureStorage.deleteKey(DbKey.bio);

        }

      }
    });

  }
  
  @override
  Future<void> checkAccountExist() async {
    
    if (sdkProvider!.getSdkImpl.getKeyring.allAccounts.isNotEmpty){
      await Future.delayed(const Duration(milliseconds: 200), (){

        Navigator.pushAndRemoveUntil(
          _context!, 
          MaterialPageRoute(builder: (context) => MainScreen()), 
          (route) => false
        );
      });
    } else {

      await Future.delayed(const Duration(milliseconds: 200), (){
        Navigator.pushAndRemoveUntil(
          _context!, 
          MaterialPageRoute(builder: (context) => const Welcome()), 
          (route) => false
        );

      });

    }
    
  }


  @override
  Future<void> changePin() async {

    final oldPinRes = await Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => const PincodeScreen(title: "Current PIN", label: PinCodeLabel.fromChangePin,))
    );

    if(oldPinRes != null) {

      dialogLoading(_context!);

      oldPin = oldPinRes;

      final isCheckPw = await sdkProvider!.getSdkImpl.getWalletSdk.api.keyring.checkPassword(
        sdkProvider!.getSdkImpl.getKeyring.current, 
        oldPin!
      );
      

      if(isCheckPw == true) {

        // Close dialog
        Navigator.pop(_context!);

        final newPinRes = await Navigator.push(
          _context!,
          MaterialPageRoute(builder: (context) => const PincodeScreen(title: "New PIN", label: PinCodeLabel.fromChangePin,))
        );
        
        if(newPinRes == null) return;

        dialogLoading(_context!, content: "Updating PIN Code");

        newPin = newPinRes;
        
        await sdkProvider!.getSdkImpl.getWalletSdk.api.keyring.changePassword(
          sdkProvider!.getSdkImpl.getKeyring, 
          sdkProvider!.getSdkImpl.getKeyring.current, 
          oldPin!, 
          newPin!
        );

        await updatePkWithnewPin();

        // Close dialog
        Navigator.pop(_context!);
        
        await QuickAlert.show(
          context: _context!,
          type: QuickAlertType.success,
          text: "Your PIN has been changed.",
          barrierDismissible: false
        );
      }
      else {

        Navigator.pop(_context!);
    
        await QuickAlert.show(
          context: _context!,
          type: QuickAlertType.error,
          text: "Your entered incorrect PIN Code.",
          barrierDismissible: false
        );

      }

    }

  }

  Future<void> updatePkWithnewPin() async {
    try {

      // Get Seeds From Decrypt
      final seeds = await KeyringPrivateStore(
        [sdkProvider!.getSdkImpl.sdkRepoImpl.nodes[0].ss58!]
      ).getDecryptedSeed(
        sdkProvider!.getSdkImpl.getKeyring.current.pubKey, 
        oldPin
      );

      // Get Private Key _resPk
      await sdkProvider!.getSdkImpl.getWalletSdk.webView!.evalJavascript("wallets.getPrivateKey('${seeds!["seed"]}')").then((privateKey) async {

        // Re-Encrypt Private Key
        final encrypt = await sdkProvider!.getSdkImpl.encryptPrivateKey(privateKey, newPin!);
        
        await _secureStorageImpl.writeSecure(DbKey.private, encrypt!);

        await _secureStorageImpl.writeSecure(DbKey.pin, newPin!);

        // 1
        sdkProvider!.getUnverifyAcc[sdkProvider!.currentAccIndex].pubKey = encrypt; 

        await _secureStorageImpl.writeSecure(DbKey.privateList, jsonEncode(UnverifySeed().unverifyListToJson(sdkProvider!.getUnverifyAcc)));
      });


    } catch (e){
      
    } 
  }
  
}