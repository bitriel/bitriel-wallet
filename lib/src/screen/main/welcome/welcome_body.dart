import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/passcode_c.dart';

class WelcomeBody extends StatelessWidget {

  final InputController? inputController = InputController();
  // WelcomeBody({this.inputController});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        SvgPicture.asset(
          AppConfig.assetsPath+'logo/bitriel-logo-v2.svg',
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.15,
        ),
        SizedBox(
          height: 50,
        ),
        MyText(
          text: "Welcome!",
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: isDarkTheme
              ? AppColors.whiteColorHexa
              : AppColors.textColor,
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 42, right: 42),
          child: MyText(
            text: "Bitriel offer users to store, make transaction, invest, buy, sell crypto assets, and more!",
            fontSize: 15,
            color: isDarkTheme
                ? AppColors.whiteColorHexa
                : AppColors.textColor,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Column(
          children: [
            MyFlatButton(
              hasShadow: true,
              edgeMargin: const EdgeInsets.only(left: 42, right: 42, bottom: 16),
              textButton: AppString.createAccTitle,
              action: () {
                PassCodeComponent().passCode(context: context, inputController: inputController!);
                // Navigator.pushNamed(context, AppString.contentBackup);
                // Navigator.push(context,MaterialPageRoute(builder: (context) => ContentsBackup()));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MyUserInfo("error shallow spin vault lumber destroy tattoo steel rose toilet school speed")));
              },
            ),
            MyFlatButton(
              isTransparent: true,
              buttonColor: AppColors.whiteHexaColor,
              edgeMargin:
                  const EdgeInsets.only(left: 42, right: 42, bottom: 16),
              textButton: AppString.importAccTitle,
              action: () {
                Navigator.pushNamed(context, AppString.importAccView);
              },
            )
          ],
        ),
      ],
    );
  }
}
