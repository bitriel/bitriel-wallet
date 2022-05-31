import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/screen/main/create_key/body_create_key.dart';

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({Key? key}) : super(key: key);

  @override
  _CreateWalletPagetScreenState createState() =>
      _CreateWalletPagetScreenState();
}

class _CreateWalletPagetScreenState extends State<CreateWalletPage> {
  bool initial = true;
  String _seed = '';

  void generateKey() async {
    
    _seed = await Provider.of<ApiProvider>(context, listen: false).generateMnemonic();
    setState(() {
      // _seed = bip39.generateMnemonic();
    });
  }

  void _showWarning(BuildContext context) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2.2,
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.blue),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                SizedBox(height: 25),
                MyText(
                  text: "Please, read carefully!",
                  color: AppColors.bgdColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),  
        
        
                SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size8),
                    color: hexaCodeToColor("#FFF5F5"),
                  ), 
                  width: 500,
                  height: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(width: 10),
                      SvgPicture.asset('assets/icons/warning.svg'),
        
                      SizedBox(width: 20),
                      Expanded(
                        child: MyText(
                          text: "The information below is important to guarantee your account security.",
                          color: AppColors.warningColor,
                          textAlign: TextAlign.start,
                        ),
                      )
                    ]
                  ),
                ),
        
                SizedBox(height: 10),
                MyText(
                  text: "Please write down your wallet's mnemonic seed and keep it in a safe place. The mnemonic can be used to restore your wallet. If you lose it, all your assets that link to it will be lost.",
                  textAlign: TextAlign.start,
                  color: AppColors.bgdColor,
                  fontSize: 16,
                ),
        
                SizedBox(height: 50),
                MyFlatButton(
                  hasShadow: false,
                  textButton: "I Agree",
                  action: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  void didChangeDependencies() async {
    if (initial) {
      _seed = bip39.generateMnemonic();

      setState(() {
        initial = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    // generateKey();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _showWarning(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CreateKeyBody(
      initial: initial,
      seed: _seed,
      generateKey: generateKey,
    );
  }
}
