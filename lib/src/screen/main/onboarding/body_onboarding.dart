import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/portrait_card_c.dart';
import 'package:wallet_apps/src/screen/main/json/import_json.dart';
import 'package:wallet_apps/src/screen/main/social_login/phonenumber/phone_main_screen.dart';

import '../social_login/email/login_content.dart';

class OnboardignBody extends StatelessWidget {

  final InputController? inputController = InputController();
  final bool? selected;
  final Function? tabGoogle;

  OnboardignBody({Key? key, this.selected, this.tabGoogle}) : super(key: key);
  // WelcomeBody({this.inputController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
    
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  '${AppConfig.assetsPath}logo/bitriel-logo-v2.png',
                  // height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                const SizedBox(
                  height: 40,
                ),
          
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: MyText(
                    // text: "Set up \nyour wallet",
                    text: "Welcome!",
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    fontSize: 19,
                    hexaColor: isDarkMode
                      ? AppColors.whiteColorHexa
                      : AppColors.darkGrey,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: MyText(
                    text: "Bitriel offers users to store, transact, hold, buy, sell crypto assets, and more!",
                    textAlign: TextAlign.center,
                    hexaColor: isDarkMode
                      ? AppColors.lowWhite
                      : AppColors.textColor,
                  ),
                )
              ]
            )
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //   child: _setupMenu(context),
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              GoogleAuthButton(
                onPressed: () async {
                },
                style: const AuthButtonStyle(
                  buttonType: AuthButtonType.icon,
                  iconType: AuthIconType.secondary,
                ),
                themeMode: ThemeMode.light,
              ),

              SizedBox(width: 20.sp,),

              EmailAuthButton(
                onPressed: () async {
                  Navigator.push(
                    context, 
                    Transition(child: const LoginContent(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                  );

                },
                style: const AuthButtonStyle(
                  buttonType: AuthButtonType.icon,
                  iconType: AuthIconType.secondary,
                ),
                themeMode: ThemeMode.light,
              ),

              SizedBox(width: 20.sp,),

              CustomAuthButton(
                onPressed: () async {
                  // underContstuctionAnimationDailog(context: context);
                  Navigator.push(context, Transition(child: const PhoneMainScreen(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
                authIcon: AuthIcon(
                  iconPath: "assets/icons/phone-call.png",
                  iconSize: 30,
                ),
                style: const AuthButtonStyle(
                  buttonType: AuthButtonType.icon,
                  iconType: AuthIconType.outlined,
                  buttonColor: Colors.white,
                  height: 50
                ),
                themeMode: ThemeMode.light,
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(paddingSize + 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Color(0xff818181),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'OR',
                  style: TextStyle(color: Color(0xff818181), fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Color(0xff818181),
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              MyGradientButton(
                edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                textButton: AppString.createAccTitle,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () {
                  // PassCodeComponent().passCode(context: context, inputController: inputController!);
    
                  Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromCreateSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                  // Navigator.pushNamed(context, AppString.contentBackup);
                  // Navigator.push(context,MaterialPageRoute(builder: (context) => ContentsBackup()));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => MyUserInfo("error shallow spin vault lumber destroy tattoo steel rose toilet school speed")));
                },
              ),
              MyFlatButton(
                isTransparent: true,
                textColor: isDarkMode ? AppColors.whiteHexaColor : AppColors.secondary,
                edgeMargin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                textButton: AppString.importAccTitle,
                action: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Passcode(label: PassCodeLabel.fromImportSeeds)));
                  Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromImportSeeds,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}