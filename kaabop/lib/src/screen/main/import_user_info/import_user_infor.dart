import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_info_body.dart';

class ImportUserInfo extends StatefulWidget {
  final String passPhrase;

  static const route = '/importUserInfo';

  const ImportUserInfo(this.passPhrase);

  @override
  State<StatefulWidget> createState() {
    return ImportUserInfoState();
  }
}

class ImportUserInfoState extends State<ImportUserInfo> {
  final ModelUserInfo _userInfoM = ModelUserInfo();

  LocalAuthentication _localAuth = LocalAuthentication();

  final MenuModel _menuModel = MenuModel();

  @override
  void initState() {
    AppServices.noInternetConnection(_userInfoM.globalKey);
    super.initState();
  }

  @override
  void dispose() {
    _userInfoM.userNameCon.clear();
    _userInfoM.passwordCon.clear();
    _userInfoM.confirmPasswordCon.clear();
    _userInfoM.enable = false;
    super.dispose();
  }

  // Future<void> dialog(String text1, String text2, {Widget action}) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //         title: Align(
  //           child: Text(text1),
  //         ),
  //         content: Padding(
  //           padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
  //           child: Text(text2),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _importFromMnemonic() async {
    try {
      final json = await ApiProvider.sdk.api.keyring.importAccount(
        ApiProvider.keyring,
        keyType: KeyType.mnemonic,
        key: widget.passPhrase,
        name: _userInfoM.userNameCon.text,
        password: _userInfoM.confirmPasswordCon.text,
      );

      final acc = await ApiProvider.sdk.api.keyring.addAccount(
        ApiProvider.keyring,
        keyType: KeyType.mnemonic,
        acc: json,
        password: _userInfoM.confirmPasswordCon.text,
      );

      if (acc != null) {
        addBtcWallet();
        final resPk = await ApiProvider().getPrivateKey(widget.passPhrase);
        if (resPk != null) {
          ContractProvider().extractAddress(resPk);
          final res = await ApiProvider.keyring.store
              .encryptPrivateKey(resPk, _userInfoM.confirmPasswordCon.text);

          if (res != null) {
            await StorageServices().writeSecure('private', res);
          }
        }
        Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

        Provider.of<ApiProvider>(context, listen: false).connectPolNon();
        Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
        Provider.of<ContractProvider>(context, listen: false).getBscBalance();
        Provider.of<ContractProvider>(context, listen: false).getEtherBalance();
        //isDotContain();
        //isBnbContain();
        //isBscContain();
        isKgoContain();

        MarketProvider().fetchTokenMarketPrice(context);

        Provider.of<ApiProvider>(context, listen: false).getChainDecimal();
        Provider.of<ApiProvider>(context, listen: false).getAddressIcon();
        Provider.of<ApiProvider>(context, listen: false).getCurrentAccount();

        await dialogSuccess(
          context,
          const Text("You haved imported successfully"),
          const Text('Congratulation'),
          // ignore: deprecated_member_use
          action: FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, Home.route, ModalRoute.withName('/'));
            },
            child: const Text('Continue'),
          ),
        );
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: Text('Message'),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text(e.message.toString()),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      // await dialog(
      //   e.message.toString(),
      //   'Message',
      // );
      Navigator.pop(context);
    }
  }

  Future<void> addBtcWallet() async {
    final seed = bip39.mnemonicToSeed(widget.passPhrase);
    final hdWallet = HDWallet.fromSeed(seed);

    await StorageServices.setData(hdWallet.address, 'btcaddress');

    final res = await ApiProvider.keyring.store
        .encryptPrivateKey(hdWallet.wif, _userInfoM.confirmPasswordCon.text);

    if (res != null) {
      await StorageServices().writeSecure('btcwif', res);
    }

    Provider.of<ApiProvider>(context, listen: false)
        .getBtcBalance(hdWallet.address);
    Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain');

    Provider.of<ApiProvider>(context, listen: false)
        .setBtcAddr(hdWallet.address);
    Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
  }

  // Future<void> isDotContain() async {
  //   // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('DOT');
  //   // Provider.of<ApiProvider>(context, listen: false).isDotContain();
  //   Provider.of<ApiProvider>(context, listen: false).connectPolNon();
  // }

  // Future<void> isBnbContain() async {
  //   Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BNB');

  // }

  // Future<void> isBscContain() async {
  //   Provider.of<WalletProvider>(context, listen: false)
  //       .addTokenSymbol('SEL (BEP-20)');
  //   Provider.of<ContractProvider>(context, listen: false).getSymbol();
  //   Provider.of<ContractProvider>(context, listen: false)
  //       .getBscDecimal()
  //       .then((value) {
  //     Provider.of<ContractProvider>(context, listen: false).getBscBalance();
  //   });
  // }

  Future<void> isKgoContain() async {
    // Provider.of<WalletProvider>(context, listen: false)
    //     .addTokenSymbol('KGO (BEP-20)');
    // Provider.of<ContractProvider>(context, listen: false).getKgoSymbol();
    Provider.of<ContractProvider>(context, listen: false)
        .getKgoDecimal()
        .then((value) {
      Provider.of<ContractProvider>(context, listen: false).getKgoBalance();
    });
  }

  // ignore: avoid_void_async
  void switchBiometric(bool switchValue) async {
    _localAuth = LocalAuthentication();

    await _localAuth.canCheckBiometrics.then((value) async {
      if (value == false) {
        snackBar(_menuModel.globalKey, "Your device doesn't have finger print");
      } else {
        if (switchValue) {
          await authenticateBiometric(_localAuth).then((values) async {
            if (_menuModel.authenticated) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.saveBio(_menuModel.switchBio);
            }
          });
        } else {
          await authenticateBiometric(_localAuth).then((values) async {
            if (_menuModel.authenticated) {
              setState(() {
                _menuModel.switchBio = switchValue;
              });
              await StorageServices.removeKey('bio');
            }
          });
        }
      }
    });
  }

  Future<bool> authenticateBiometric(LocalAuthentication _localAuth) async {
    // Trigger Authentication By Finger Print
    // ignore: join_return_with_assignment
    _menuModel.authenticated = await _localAuth.authenticateWithBiometrics(
      localizedReason: '',
      stickyAuth: true,
    );

    return _menuModel.authenticated;
  }

  void popScreen() {
    Navigator.pop(context);
  }

  Future<void> onSubmit() async {
    if (_userInfoM.userNameNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.passwordNode);
    } else if (_userInfoM.passwordNode.hasFocus) {
      FocusScope.of(context).requestFocus(_userInfoM.confirmPasswordNode);
    } else {
      FocusScope.of(context).unfocus();
      validateAll();
      if (_userInfoM.enable) await submitProfile();
    }
  }

  String onChanged(String value) {
    _userInfoM.formStateAddUserInfo.currentState.validate();
    validateAll();
    return null;
  }

  String validateFirstName(String value) {
    if (_userInfoM.nodeFirstName.hasFocus) {
      if (value.isEmpty) {
        return 'Please fill in username';
      } else if (_userInfoM.confirmPasswordCon.text !=
          _userInfoM.passwordCon.text) {
        return 'Password does not matched';
      }
    }
    return _userInfoM.responseFirstname;
  }

  String validatePassword(String value) {
    if (_userInfoM.passwordNode.hasFocus) {
      if (value.isEmpty || value.length < 4) {
        return 'Please fill in 4-digits password';
      }
    }
    return _userInfoM.responseMidname;
  }

  String validateConfirmPassword(String value) {
    if (_userInfoM.confirmPasswordNode.hasFocus) {
      if (value.isEmpty || value.length < 4) {
        return 'Please fill in 4-digits confirm pin';
      } else if (_userInfoM.confirmPasswordCon.text !=
          _userInfoM.passwordCon.text) {
        return 'Pin does not matched';
      }
    }

    return null;
  }

  void validateAll() {
    if (_userInfoM.userNameCon.text.isNotEmpty &&
        _userInfoM.passwordCon.text.isNotEmpty &&
        _userInfoM.confirmPasswordCon.text.isNotEmpty) {
      if (_userInfoM.passwordCon.text == _userInfoM.confirmPasswordCon.text) {
        setState(() {
          enableButton(true);
        });
      }
    } else if (_userInfoM.enable) {
      setState(() {
        enableButton(false);
      });
    }
  }

  // Submit Profile User
  Future<void> submitProfile() async {
    // Show Loading Process
    dialogLoading(context);

    await _importFromMnemonic();
  }

  PopupMenuItem item(Map<String, dynamic> list) {
    return PopupMenuItem(
      value: list['gender'],
      child: Text("${list['gender']}"),
    );
  }

  // ignore: use_setters_to_change_properties
  // ignore: avoid_positional_boolean_parameters
  void enableButton(bool value) => _userInfoM.enable = value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _userInfoM.globalKey,
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: ImportUserInfoBody(
          modelUserInfo: _userInfoM,
          onSubmit: onSubmit,
          onChanged: onChanged,
          validateFirstName: validateFirstName,
          validatepassword: validatePassword,
          validateConfirmPassword: validateConfirmPassword,
          submitProfile: submitProfile,
          popScreen: popScreen,
          switchBio: switchBiometric,
          menuModel: _menuModel,
          item: item,
        ),
      ),
    );
  }
}
