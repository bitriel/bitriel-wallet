import 'package:bitriel_wallet/index.dart';

class SeedsCompoent {
  
  static double _seedHeight = 22.8;

  static List<Widget> getColumn(BuildContext context, String seed, int pos, {double? moreSize = 0}) {

    _seedHeight = 22.8;
    _seedHeight = (_seedHeight + moreSize!);
    var list = <Widget>[];
    var se = seed.split(' ');
    var colSize = se.length ~/ 3;

    for (var i = 0; i < colSize; i++) {

      if (se[i * 3 + pos] == "") {
        
        list.add(
            // Display Empty Text
          Container(
            // Minus 34 Size OF Padding Left & Right
            width: MediaQuery.of(context).size.width / 3 - _seedHeight,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            color: Colors.transparent,
          )
        );
      } else {

        list.add(Container(
          // Minus 34 Size OF Padding Left & Right
          width: MediaQuery.of(context).size.width / 3 - _seedHeight,
          padding: const EdgeInsets.only(top: 8, bottom: 8,),
          alignment: Alignment.center,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.primaryBtn).withOpacity(0.66),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          // color: grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if ((i * 3 + pos + 1) < 10)
                MyTextConstant(
                  text: '${i * 3 + pos + 1}. ${se[i * 3 + pos]}',
                  color2: hexaCodeToColor(AppColors.white),
                  fontSize: 16 * MediaQuery.of(context).textScaleFactor,
                  fontWeight: FontWeight.w600
                )
              else
                MyTextConstant(
                  text: '${i * 3 + pos + 1}. ${se[i * 3 + pos]}',
                  color2: hexaCodeToColor(AppColors.white),
                  fontSize: 16 * MediaQuery.of(context).textScaleFactor,
                  fontWeight: FontWeight.w600
                ),
            ]),
          ),
        ));
      }
    }
    return list;
  }

  static Widget seedContainer(BuildContext context, String txt, int index, int rmIndex, Function? onTap) {
    return GestureDetector(
      onTap: () {
        onTap!(index, rmIndex);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3 - _seedHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: hexaCodeToColor(AppColors.primaryBtn).withOpacity(0.66),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        // color: grey,
        child: MyTextConstant(
          text: txt,
          color2: hexaCodeToColor(AppColors.white),
          fontSize: 16 * MediaQuery.of(context).textScaleFactor,
          fontWeight: FontWeight.w600
        ),
      )
    );
  }
}

Future<void> seedVerifyLaterDialog(BuildContext context, Function? submit) async {

  bool isCheck = false;
  
  showModalBottomSheet(
    context: context,
    backgroundColor: hexaCodeToColor(AppColors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateWidget) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.asset(
                    "assets/animation/warning-shield.json",
                    repeat: true,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                MyTextConstant(
                  text: 'Verify you Seed Phrase later?',
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 10),
          
                CheckboxListTile(
                  title: MyTextConstant(
                    text: "I understand that if I lose my Secret Seed Phrase I will not be able to access my wallet",
                    textAlign: TextAlign.start,
                    color2: hexaCodeToColor(AppColors.midNightBlue),
                  ),
                  activeColor: hexaCodeToColor(AppColors.primary),
                  value: isCheck,
                  onChanged: (newValue) {
                    setStateWidget(() {
                      isCheck = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 10,),

                // MyButton(
                //   textButton: "Yes, Verify Later",
                //   fontWeight: FontWeight.w600,
                //   textColor: AppColors.primaryBtn,
                //   borderWidth: 1,
                //   isTransparent: true,
                //   isTransparentOpacity: 0,
                //   action: () async {

                //     await multiAccountImpl.importWallet();

                //   },
                // ),
                MyButton(
                  textButton: "Yes, Verify Later",
                  buttonColor: AppColors.white,
                  opacity: 0,
                  borderWidth: 1,
                  textColor: isCheck == false ? AppColors.lightGrey : AppColors.primaryBtn,
                  action: (){
                    isCheck == false ? null : submit!();
                  }
                ),
          
                const SizedBox(height: 10,),
          
                SafeArea(
                  child: MyButton(
                    textButton: "No, Verify Now",
                    action: (){
                      Navigator.pop(context);
                    }
                  ),
                ),
          
              ],
            ),
          );
        }
      );
    },
  );
}
