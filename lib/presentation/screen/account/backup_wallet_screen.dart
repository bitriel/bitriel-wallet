import 'package:bitriel_wallet/index.dart';

class BackUpWalletScreen extends StatelessWidget{
  
  final String mnemonicKey;

  const BackUpWalletScreen({
    Key? key, 
    required this.mnemonicKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){

    List<String> words = mnemonicKey.split(" ");
    int wordLength = words.length;

    print("wordLength $wordLength");
     
    return Scaffold(
      appBar: appBar(context, title: "Export Mnemonic"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: paddingSize, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _warningLabel(),
            
            wordLength == 1 ? _mnemonicEmpty() : Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 6),
                ),
                itemCount: wordLength,
                itemBuilder: (context, index) {
                  return _phraseKey(
                    index: index, 
                    mnemonicKey: mnemonicKey,
                    word: words
                  );
                },
              ),
            ),

            // _copyButton(context: context, mnemonic: mnemonicKey),
            

            SafeArea(child: _warningMsg()),
          ]
        ),
      )
    );
  }

  Widget _mnemonicEmpty() {
    return Column(
      children: [
        Lottie.asset(
          "assets/animation/search_empty.json",
          repeat: false,
          height: 200,
          width: 200
        ),

        MyTextConstant(
          text: "Mnemonic not found, You may input wrong passcode.\n Please try again!!!",
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _warningLabel() {
    return Card(
      color: hexaCodeToColor(AppColors.cardColor),
      child: ListTile(
        leading: Icon(Iconsax.warning_2, color: hexaCodeToColor(AppColors.red)),
        title: const MyTextConstant(
          text: "Never share your secret phrase with anyone.",
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _warningMsg() {
    return MyTextConstant(
      text: "Never share your secret phrase with anyone,\nstore it securely!",
      fontWeight: FontWeight.w600,
      color2: hexaCodeToColor(AppColors.primary),
    );
  }

  Widget _phraseKey({required int index, required String mnemonicKey, required List<String> word}) {

    return Card(
      child: ListTile(
        leading: MyTextConstant(
          text: "${index + 1}.",
        ),
        title: MyTextConstant(
          text: word[index],
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _copyButton({required BuildContext context, required String mnemonic}) {
    return MyButton(
      textButton: "Copy Mnemonic",
      action: () async{
        Clipboard.setData(ClipboardData(text: mnemonic)).then((_){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mnemonic copied to clipboard")));
        });
      },
    );
  }
  
}