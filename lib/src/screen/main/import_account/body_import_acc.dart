import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class ImportAccBody extends StatelessWidget {
  final bool? enable;
  final String? reImport;
  final ImportAccModel? importAccModel;
  final Function? onChanged;
  final Function? onSubmit;
  final Function? clearInput;
  final Function? submit;

  const ImportAccBody({
    this.importAccModel,
    this.onChanged,
    this.onSubmit,
    this.clearInput,
    this.enable,
    this.reImport,
    this.submit,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Column(
      children: [
        Expanded(
            child: BodyScaffold(
          height: MediaQuery.of(context).size.height - 70,
          bottom: 0,
          child: Form(
            key: importAccModel!.formKey,
            child: Column(
              children: [
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: 'Restore with seed',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                      bottom: 16,
                    ),
                  )
                ),
                

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: 'Please add your 12 words seed below to restore your wallet.',
                      fontSize: 16,
                      color: isDarkTheme
                          ? AppColors.bgdColor
                          : AppColors.textColor,
                      textAlign: TextAlign.start,
                    ),
                  )
                ),

              MySeedField(
                  pTop: 20,
                  pLeft: 20,
                  pRight: 20,
                  pBottom: 16.0,
                  hintText: "Add your 12 keywords",
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(
                      TextField.noMaxLength,
                    )
                  ],
                  controller: importAccModel!.mnemonicCon,
                  focusNode: importAccModel!.mnemonicNode,
                  maxLine: 7,
                  onChanged: onChanged,
                  //inputAction: TextInputAction.done,
                  onSubmit: onSubmit,
                ),

                

                // if (reImport != null)
                //   MyInputField(
                //     pLeft: 20,
                //     pRight: 20,
                //     pBottom: 16.0,
                //     labelText: "Pin",
                //     textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                //     controller: importAccModel!.pwCon,
                //     focusNode: importAccModel!.pwNode,
                //     validateField: (value) =>
                //         value.isEmpty ? 'Please fill in pin' : null,
                //     maxLine: null,
                //     onChanged: onChanged,
                //     //inputAction: TextInputAction.done,
                //     onSubmit: onSubmit,
                //   )
                // else
                //   Container(),

                Expanded(
                  child: Container(),
                ),
                // MyFlatButton(
                //   hasShadow: enable,
                //   edgeMargin: const EdgeInsets.only(left: 66, right: 66, bottom: 16),
                //   textButton: AppText.next,
                //   action: enable == false
                //     ? null
                //     : () async {
                //       submit();
                //     },
                // )
                MyFlatButton(
                  hasShadow: enable,
                  edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  textButton: "Continue",
                  action: 
                  enable == false
                    ? null
                    : 
                    () async {
                      await submit!();
                    },
                )
              ],
            ),
          ),
        )),
      ],
    );
  }
}