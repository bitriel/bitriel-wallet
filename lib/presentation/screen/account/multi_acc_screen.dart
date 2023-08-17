import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/account/account_setting_screen.dart';

class MultiAccountScreen extends StatelessWidget {

  const MultiAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final MultiAccountImpl multiAccountImpl = MultiAccountImpl();

    multiAccountImpl.setContext(context);
    
    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      appBar: appBar(context, title: "Account"),
      body: (multiAccountImpl.sdkProvier!.isConnected == false ) 
      ? const Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          itemCount: multiAccountImpl.getAllAccount.length,
          itemBuilder:(context, index) {
            
            return Card(
              color: hexaCodeToColor(AppColors.cardColor),
              child: ListTile(
                leading: RandomAvatar(
                  multiAccountImpl.getAllAccount[index].icon!, 
                  alignment: Alignment.topLeft,
                  height: 40,
                  width: 40
                ),
                title: MyTextConstant(
                  text: multiAccountImpl.getAllAccount[index].name ?? '',
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                subtitle: MyTextConstant(
                  text: multiAccountImpl.getAllAccount[index].address!.replaceRange(10, multiAccountImpl.getAllAccount[index].address!.length - 10, "........"),
                  textAlign: TextAlign.start,
                  fontSize: 14,
                  color2: hexaCodeToColor(AppColors.darkGrey),
                ), 
                trailing: const Icon(
                  Iconsax.arrow_right_3
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountSettingScreen()
                    )
                  );
                },
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: multiAccountImpl.getAllAccount.length == 2 ? null : Row(
        children: [

          Expanded(
            child: MyButton(
              edgeMargin: const EdgeInsets.all(10),
              textButton: "Create Wallet",
              fontWeight: FontWeight.w600,
              buttonColor: AppColors.bluebgColor,
              opacity: 0.9,
              action: () async {

                await multiAccountImpl.createWallet();
                
              },
            ),
          ),
      
          Expanded(
            child: MyButton(
              edgeMargin: const EdgeInsets.all(10),
              textButton: "Import Wallet",
              fontWeight: FontWeight.w600,
              buttonColor: AppColors.midNightBlue,
              opacity: 0.9,
              action: () async {

                await multiAccountImpl.importWallet();

              },
            ),
          )
        ],
      )
    );
  }

}