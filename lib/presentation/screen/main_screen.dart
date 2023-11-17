import 'package:bitriel_wallet/index.dart';

class MainScreen extends StatelessWidget {
  
  MainScreen({super.key});

  final NavbarUsecaseImpl navbarUsecaseImpl = NavbarUsecaseImpl();

  final MultiAccountImpl multiAccountImpl = MultiAccountImpl();

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: navbarUsecaseImpl.currentIndex,
      builder: (context, currentIndex, wg) {
        return Scaffold(
          appBar: currentIndex != 2 ? defaultAppBar(context: context, multiAccountImpl: multiAccountImpl) : null,
          body: PageView(
            onPageChanged: navbarUsecaseImpl.changeIndex,
            controller: navbarUsecaseImpl.pageController,
            children: const [
              HomeScreen(),
              WalletScreen(),
              SettingScreen()
            ],
          ),
          bottomNavigationBar: ValueListenableBuilder(
            valueListenable: navbarUsecaseImpl.currentIndex,
            builder: (context, currentIndex, wg) {
              return BottomNavigationBar(
                selectedItemColor: hexaCodeToColor(AppColors.primaryBtn),
                unselectedItemColor: Colors.black,
                onTap: navbarUsecaseImpl.changeIndex,
                currentIndex: currentIndex,
                
                items: const [
                  BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home_outlined,)),
                  BottomNavigationBarItem(label: "Wallet", icon: Icon(Icons.account_balance_wallet_outlined)),
                  BottomNavigationBarItem(label: "Setting", icon: Icon(Icons.settings_outlined))
                ],
              );
            }
          ),
        );
      }
    );
  }

}