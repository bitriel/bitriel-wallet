import 'package:bitriel_wallet/index.dart';

class AccountSettingScreen extends StatelessWidget {

  final int? indexAcc;
  
  const AccountSettingScreen({super.key, this.indexAcc});

  @override
  Widget build(BuildContext context) {

    final MultiAccountImpl multiAccountImpl = MultiAccountImpl();

    multiAccountImpl.setContext(context);

    multiAccountImpl.initTxtController(indexAcc!);

    return Scaffold(
      appBar: appBar(context, title: "Wallet"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _inputWalletName(indexAcc!, multiAccountImpl),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextConstant(
              text: "BACKUP OPTION",
              fontSize: 12,
              color2: hexaCodeToColor(AppColors.grey),
            ),
          ),
          _backupOption(
            name: "Export Mnemonic",
            onTap: () {
              _exportWarningDialog(
                context: context,
                submit: () {
                  Navigator.pop(context);
                 
                  multiAccountImpl.getMnemonic();
                }
              );
            }
          ),

        ],
      ),
    );
  }

  Future<void> _exportWarningDialog({BuildContext? context, Function? submit}) async {

    bool isCheck1 = false;
    bool isCheck2 = false;
    bool isCheck3 = false;
    
    showModalBottomSheet(
      context: context!,
      backgroundColor: hexaCodeToColor(AppColors.white),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateWidget) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: MyTextConstant(
                    text: "This secret phrase is the master ket to your wallet",
                    color2: hexaCodeToColor(AppColors.midNightBlue),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: MyTextConstant(
                    text: "Tap on all checkboxes to confirm you understand the importance of your secret phrase",
                    color2: hexaCodeToColor(AppColors.darkGrey),
                    fontSize: 12,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: MyTextConstant(
                            text: "If I lose my secret phrase, my funds will be lost forever.",
                            textAlign: TextAlign.start,
                            fontSize: 13,
                            color2: hexaCodeToColor(AppColors.midNightBlue),
                          ),
                          activeColor: hexaCodeToColor(AppColors.primary),
                          value: isCheck1,
                          onChanged: (newValue1) {
                            setStateWidget(() {
                              isCheck1 = newValue1!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                
                        const SizedBox(height: 10,),
                
                        CheckboxListTile(
                          title: MyTextConstant(
                            text: "If I expose or share my secret phrase to anybody, my funds can get stolen.",
                            textAlign: TextAlign.start,
                            fontSize: 13,
                            color2: hexaCodeToColor(AppColors.midNightBlue),
                          ),
                          activeColor: hexaCodeToColor(AppColors.primary),
                          value: isCheck2,
                          onChanged: (newValue2) {
                            setStateWidget(() {
                              isCheck2 = newValue2!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                
                        const SizedBox(height: 10,),
                
                        CheckboxListTile(
                          title: MyTextConstant(
                            text: "Bitriel Wallet support will NEVER reach out to ask for it.",
                            textAlign: TextAlign.start,
                            fontSize: 13,
                            color2: hexaCodeToColor(AppColors.midNightBlue),
                          ),
                          activeColor: hexaCodeToColor(AppColors.primary),
                          value: isCheck3,
                          onChanged: (newValue3) {
                            setStateWidget(() {
                              isCheck3 = newValue3!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: MyButton(
                      textButton: "Continue",
                      buttonColor: isCheck1 == true && isCheck2 == true && isCheck3 == true ? AppColors.primary : AppColors.lightGrey,
                      action: (){
                        if(isCheck1 == true && isCheck2 == true && isCheck3 == true) submit!();
                      }
                    ),
                  ),
                ),
            
              ],
            );
          }
        );
      },
    );
  }

  Widget _inputWalletName(int indexAcc, MultiAccountImpl multiAccountImpl) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                child: Text(
                  'Wallet Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: TextField(
                  controller: multiAccountImpl.walletNameConroller,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                  ),
                  decoration: const InputDecoration(
                    hintText: "Wallet Name",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)
                  ),
                  onSubmitted: (value) async {
                    await multiAccountImpl.changeWalletName(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backupOption({required String name, required void Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
        color: hexaCodeToColor(AppColors.cardColor),
        child: ListTile(
          title: MyTextConstant(
            text: name,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
          trailing: Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primary),),
          onTap: onTap
        )
      ),
    );
  }

}