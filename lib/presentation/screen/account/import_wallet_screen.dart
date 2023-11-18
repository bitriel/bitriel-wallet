import 'package:bitriel_wallet/domain/usecases/acc_manage_uc/import_wallet/import_wallet_impl.dart';
import 'package:bitriel_wallet/index.dart';

class ImportWalletScreen extends StatelessWidget {

  final String? pin;

  final bool? isVerify;

  final bool? isMultiAcc;

  const ImportWalletScreen({super.key, this.pin, this.isMultiAcc = false, this.isVerify = false});

  @override
  Widget build(BuildContext context) {
    
    final ImportWalletImpl importWalletImpl = ImportWalletImpl();
    
    importWalletImpl.setContext = context;

    importWalletImpl.isMultiAcc = isMultiAcc;
    // importWalletImpl.isSeedValid.value = isSeed!;

    return Scaffold(
      appBar: appBar(context, title: "Import Mnemonic"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // const SeedContents(
            //   title: 'Restore with seed', 
            //   subTitle: 'Please add your 12 words seed below to restore your wallet.'
            // ),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: MyTextConstant(
                text: "Please add your 12 words seed below to restore your wallet.",
                textAlign: TextAlign.start,
              ),
            ),
      
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: MySeedField(
                controller: importWalletImpl.seedController,
                pLeft: 0, pRight: 0,
                pTop: 20,
                pBottom: 16.0,
                hintText: "Add your 12 keywords",
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(
                    TextField.noMaxLength,
                  )
                ],
                // controller: importAccModel!.key,
                // focusNode: importAccModel!.keyNode,
                maxLine: 7,
                validateField: Validator.seedValidator,
                onChanged: (String value){
                  importWalletImpl.changeState(value);
                },
                onSubmit: (String value) async {
                  importWalletImpl.addAndImport(pin!);
                },
              ),
            ),
      
            Expanded(child: Container()),
            SafeArea(
              child: ValueListenableBuilder(
                valueListenable: importWalletImpl.isSeedValid,
                builder: (context, value, wg) {
                  return MyButton(
                    textButton: "Next",
                    action: value ? () async {
                      await importWalletImpl.addAndImport(pin!);
                    } : null,
                  );
                }
              ),
            ),

          ],
        ),
      )
    );
  }

}