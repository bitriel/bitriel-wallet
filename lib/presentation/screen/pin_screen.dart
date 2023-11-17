import 'package:bitriel_wallet/index.dart';

enum PinCodeLabel {
  fromSplash,
  fromCreateSeeds,
  fromImportSeeds,
  fromSendTx,
  fromMenu,
  fromChangePin,
  fromBackUp,
  fromAccount,
  fromSignMessage
}

class PincodeScreen extends StatefulWidget {

  final String title;
  final PinCodeLabel? label;
  
  const PincodeScreen({
    Key? key, 
    required this.title,
    this.label
  }) : super(key: key);
  //static const route = '/passcode';

  @override
  PincodeScreenState createState() => PincodeScreenState();
}

class PincodeScreenState extends State<PincodeScreen> {

  /// (Title) 0 = Old PIN
  /// 
  /// (Title) 1 = New PIN
  /// 
  /// (Title) 2 = Invalid PIN
  /// 
  /// (Sub Title) 3 = Please fill correct PIN
  /// 
  /// (Sub Title) 4 = Please fill your old PIN
  /// 
  /// (Sub Title) 5 = Please fill your new PIN
  final List<String> lsMessage = [
    'Old PIN',
    'New PIN',
    'Invalid PIN',
    "Please fill correct PIN",
    'Please fill your old PIN',
    'Please fill your new PIN',
  ];

  PinUsecaseImpl pinUsecaseImpl = PinUsecaseImpl();

  final localAuth = LocalAuthentication();

  @override
  void initState() {
    // pinUsecaseImpl.secureStorageUCImpl.readSecure(DbKey.pin)!.then((value) => res = value);
    pinUsecaseImpl.authToHome(context);
    pinUsecaseImpl.pinModel.pinLabel = widget.label;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return pinBody();
  }

  Widget pinBody(){
    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: hexaCodeToColor(AppColors.background),
        title: MyTextConstant(
          text: widget.title,
          fontSize: 26,
          color2: hexaCodeToColor(AppColors.midNightBlue),
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Iconsax.arrow_left_2,
            size: 30,
            color: hexaCodeToColor(AppColors.midNightBlue),
          ),
        ),

        actions: [
          
          ValueListenableBuilder(
            valueListenable: pinUsecaseImpl.pinModel.isFirstPIN,
            builder: (context, vl, wg){
              return vl == true ? TextButton(
                onPressed: () {

                  /// Switch PIN Digit
                  pinUsecaseImpl.onPressedDigitOption(pinUsecaseImpl.pinModel.is6gidit.value);
                }, 
                child: ValueListenableBuilder(
                  valueListenable: pinUsecaseImpl.pinModel.is6gidit,
                  builder: (context, value, wg){
                    return MyTextConstant(
                      text: value == false ? "Use 4-digits PIN" : "Use 6-digits PIN",
                      color2: hexaCodeToColor(AppColors.primary),
                      fontWeight: FontWeight.w700,
                    );
                  },
                ),
              ) : const SizedBox();
            }
          )
        ],

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20,),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircleAvatar(
                  backgroundColor: hexaCodeToColor(AppColors.white),
                  child: Icon(
                    Iconsax.security_safe,
                    size: 50,
                    color: hexaCodeToColor(AppColors.primaryBtn),
                  ),
                ),
              ),
            ),

            Center(
              child: 
              (pinUsecaseImpl.pinModel.isFirstPIN.value == true ) ? ValueListenableBuilder(
                valueListenable: pinUsecaseImpl.pinModel.isFirstPIN, 
                builder: (builder, value, wg){
                  return widget.label == PinCodeLabel.fromSendTx || widget.label == PinCodeLabel.fromBackUp ? 
                  const MyTextConstant(
                    text: "Enter PIN to confirm",
                    fontSize: 17,
                  )
                  : MyTextConstant(
                    text: value == true ? 'Enhance the security of your account by creating a PIN code' : 'Repeat a PIN code to continue',
                    fontSize: 17,
                  );
                }
              )
              // For Change PIN
              : MyTextConstant(
                text: pinUsecaseImpl.pinModel.subTitleStatus,
                color2: AppUtils.colorFor(pinUsecaseImpl.pinModel.titleStatus == "Invalid PIN" ? AppColors.redColor : isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            // if (subStatus == null)
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     if (
              //       widget.label == PinCodeLabel.fromSplash ||
              //       widget.label == PinCodeLabel.fromSendTx ||
              //       widget.label == PinCodeLabel.fromBackUp ||
              //       widget.label == PinCodeLabel.fromSignMessage
              //     )
              //     const MyTextConstant(
              //       fontSize: 17,
              //       text: "Verify PIN code to continue",
              //     )
              //     else
              //       const MyTextConstant(
              //         fontSize: 17,
              //         text: "Enhance the security of your account by creating a PIN code",
              //       )
              //   ],
              // ),
            // // For Change PIN
            // else
            //   MyTextConstant(
            //     text: subStatus,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 19,
            //   ),

            const SizedBox(height: 50),
            ValueListenableBuilder(
              valueListenable: pinUsecaseImpl.pinModel.is6gidit,
              builder: (builder, value, wg) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: value == true
                  ? [
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[0]),
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[1]),
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[2]),
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[3]),
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[4]),
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[5]),
                    ]
                  : [
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[0]),
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[1]),
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[2]),
                      DotPin(txt: pinUsecaseImpl.pinModel.lsPINController[3]),
                    ],
                );
              }
            ),
            const Expanded(
              child: SizedBox(),
            ),
            ReuseNumPad(startNumber: 1, pinIndexSetup: pinUsecaseImpl.setPin, clearPin: pinUsecaseImpl.clearPin),
            const SizedBox(height: 20),
            ReuseNumPad(startNumber: 4, pinIndexSetup: pinUsecaseImpl.setPin, clearPin: pinUsecaseImpl.clearPin),
            const SizedBox(height: 20),
            ReuseNumPad(startNumber: 7, pinIndexSetup: pinUsecaseImpl.setPin, clearPin: pinUsecaseImpl.clearPin),
            const SizedBox(height: 20),
            SafeArea(child: ReuseNumPad(startNumber: 0, pinIndexSetup: pinUsecaseImpl.setPin, clearPin: pinUsecaseImpl.clearPin)),
            const SizedBox(height: 20),
          ],
        ),
      )
    );
  }
}