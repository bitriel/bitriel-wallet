import 'package:bitriel_wallet/index.dart';

enum BitrielRouter {
  defaultRoute,
  welcomeRoute,
  multiAccRoute,
  importWalletRoute,
  createWalletRoute,
  walletRoute,
  homeRoute,
}

class MyAppRouteConstants {
  static const String splashRouteName = 'splash';
  static const String welcomeRouteName = 'welcome';
  static const String homeRouteName = 'home';
  static const String walletRouteName = 'wallet';
  static const String settingRouteName = 'setting';
  static const String importWalletRouteName = 'importWallet';
  static const String createRouteName = 'createWallet';
  static const String multiWalletRouteName = 'multiWallet';
}

class AppRouter {
  
  static final Map<String, Widget Function(BuildContext)> router = {
    // "/": (context) => const SwapExchange(),
    "/": (context) => const SplashScreen(),
    // "/": (context) => const WalletScreen(),
    "/${BitrielRouter.welcomeRoute}": (context) => const Welcome(),
    "/${BitrielRouter.multiAccRoute}": (context) => const MultiAccountScreen(),
    "/${BitrielRouter.createWalletRoute}": (context) => const CreateWalletScreen(),
    "/${BitrielRouter.importWalletRoute}": (context) => const ImportWalletScreen(),
    "/${BitrielRouter.walletRoute}": (context) => const WalletScreen(),
    "/${BitrielRouter.homeRoute}": (context) => MainScreen(),
  };

}