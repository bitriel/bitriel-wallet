
import 'package:flutter_svg/svg.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/menu/account_c.dart';
import '../../../../index.dart';

class Account extends StatefulWidget {
  //static const route = '/account';
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  KeyPairData? _currentAcc;
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();

  final GlobalKey<FormState> _changePinKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _backupKey = GlobalKey<FormState>();

  final FocusNode _pinNode = FocusNode();
  final FocusNode _oldNode = FocusNode();
  final FocusNode _newNode = FocusNode();
  bool _loading = false;

  String onChanged(String value) {
    _backupKey.currentState!.validate();
    return value;
  }

  String onChangedChangePin(String value) {
    _changePinKey.currentState!.validate();
    return value;
  }

  String onChangedBackup(String value) {
    _backupKey.currentState!.validate();
    return value;
  }

  Future<void> onSubmit() async {
    if (_backupKey.currentState!.validate()) {
      await getBackupKey(_pinController.text);
    }
  }

  void onSubmitChangePin() {
    submitChangePin();
  }

  Future<void> submitBackUpKey() async {
    if (_pinController.text.isNotEmpty) {
      await getBackupKey(_pinController.text);
    }
  }

  void submitChangePin() {
    if (_oldPinController.text.isNotEmpty && _newPinController.text.isNotEmpty) {
      _changePin(_oldPinController.text, _newPinController.text);
    }
  }

  Future<void> deleteAccout() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: const Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: MyText(
              text: 'Are you sure to delete your account?',
              width: 80,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const MyText(text: 'Close', color: AppColors.blackColor),
            ),
            TextButton(
              onPressed: () async => await _deleteAccount(),
              child: const MyText(
                text: 'Delete',
                color: AppColors.redColor,
                fontWeight: FontWeight.w700
              ),
            ),
            // action
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {

    dialogLoading(context);

    final _api = await Provider.of<ApiProvider>(context, listen: false);
    
    try {
      await _api.getSdk.api.keyring.deleteAccount(
        _api.getKeyring,
        _currentAcc!,
      );

      final mode = await StorageServices.fetchData(DbKey.themeMode);
      final event = await StorageServices.fetchData(DbKey.event);

      await StorageServices().clearStorage();

      // Re-Save Them Mode
      await StorageServices.storeData(mode, DbKey.themeMode);
      await StorageServices.storeData(event, DbKey.event);

      await StorageServices().clearSecure();
      
      Provider.of<ContractProvider>(context, listen: false).resetConObject();

      await Future.delayed(Duration(seconds: 2), () {});
      
      Provider.of<WalletProvider>(context, listen: false).clearPortfolio();

      Navigator.pushAndRemoveUntil(context, RouteAnimation(enterPage: Welcome()), ModalRoute.withName('/'));
    } catch (e) {
      // print("_deleteAccount ${e.toString()}");
      // await dialog(context, e.toString(), 'Opps');
    }
  }

  Future<void> getBackupKey(String pass) async {
    print("getBackupKey");
    Navigator.pop(context);
    final _api = await Provider.of<ApiProvider>(context, listen: false);
    print(_api.getKeyring.current.pubKey);
    print(pass);
    try {
      // final pairs = await KeyringPrivateStore([0, 42])// (_api.getKeyring.keyPairs[0].pubKey, pass);
      final pairs = await KeyringPrivateStore([0, 42]).getDecryptedSeed(_api.getKeyring.keyPairs[0].pubKey, pass);
      print("${pairs}");
      if (pairs!['seed'] != null) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: Align(
                child: Text('Backup Key'),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text(pairs['seed'].toString()),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                // action
              ],
            );
          },
        );
      } else {
        //await dialog(context, 'Incorrect Pin', 'Backup Key');
      }
    } catch (e) {
      //await dialog(context, e.toString(), 'Opps');
      print("Error getBackupKey $e");
    }
    _pinController.text = '';
  }

  Future<void> _changePin(String oldPass, String newPass) async {

    Navigator.pop(context);
    setState(() {
      _loading = true;
    });
    final res = await Provider.of<ApiProvider>(context, listen: false);
    final changePass = await res.getSdk.api.keyring.changePassword(res.getKeyring, oldPass, newPass);
    if (changePass != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Align(
              child: Text('Change Pin'),
            ),
            content: const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text('You pin has changed!!'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              // action
            ],
          );
        },
      );

      // await dialog(
      //   context,
      //   'You pin has changed!!',
      //   'Change Pin',
      // );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Align(
              child: Text('Opps'),
            ),
            content: const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text('Change Failed!!'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              // action
            ],
          );
        },
      );

      setState(() {
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
    _oldPinController.text = '';
    _newPinController.text = '';
  }

  void copyToClipBoard(String text, BuildContext context) {
    Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    ).then(
      (value) => {
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to Clipboard'),
            duration: Duration(seconds: 3),
          ),
        ),
      },
    );
  }

  @override
  void initState() {

    _currentAcc = Provider.of<ApiProvider>(context, listen: false).getKeyring.keyPairs[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  MyAppBar(
                    title: "Account",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isDarkTheme
                          ? hexaCodeToColor(AppColors.darkCard)
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                        boxShadow: [shadow(context)]
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 25,
                              bottom: 25,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: isDarkTheme
                                ? hexaCodeToColor(AppColors.darkCard)
                                : hexaCodeToColor(AppColors.whiteHexaColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Consumer<ApiProvider>(
                                      builder: (context, value, child) {
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          margin: const EdgeInsets.only(
                                            right: 16,
                                          ),
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: SvgPicture.string(
                                            value.accountM.addressIcon!,
                                          ),
                                        );
                                      },
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text: _currentAcc!.name,
                                          color: isDarkTheme
                                            ? AppColors.whiteColorHexa
                                            : AppColors.textColor,
                                          fontSize: 20,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          GestureDetector(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                    title: const Align(
                                      child: Text('Maintainance'),
                                    ),
                                    content: const Padding(
                                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                                      child: MyText(text: 'This feature is under maintainance'),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                      // action
                                    ],
                                  );
                                },
                              );
                              
                              // AccountC().showBackup(
                              //   context,
                              //   _backupKey,
                              //   _pinController,
                              //   _pinNode,
                              //   onChangedBackup,
                              //   onSubmit,
                              //   submitBackUpKey,
                              // );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 70,
                              child: MyText(
                                text: 'Backup Key',
                                color: isDarkTheme
                                    ? AppColors.whiteColorHexa
                                    : AppColors.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              AccountC().showChangePin(
                                context,
                                _changePinKey,
                                _oldPinController,
                                _newPinController,
                                _oldNode,
                                _newNode,
                                onChangedChangePin,
                                onSubmitChangePin,
                                submitChangePin,
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 70,
                              child: MyText(
                                text: 'Change Pin',
                                color: isDarkTheme
                                    ? AppColors.whiteColorHexa
                                    : AppColors.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              // await contract.unsubscribeNetwork();
                              await deleteAccout();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 70,
                              child: const MyText(
                                text: 'Delete Account',
                                color: "#FF0000",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
