import 'dart:ui';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/defi_menu_item_c.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/models/marketplace_list_m.dart';
import 'package:wallet_apps/src/screen/home/webview/marketplace_webview.dart';

class DiscoverPageBody extends StatelessWidget {

  final HomePageModel? homePageModel;
  final TabController tabController;
  final TextEditingController? searchController;
  const DiscoverPageBody({
    Key? key,
    required this.tabController,
    this.homePageModel,
    this.searchController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _searchInputWeb(context),

            const SizedBox(height: 10), 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "DeFi",
                fontSize: 17.5,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
              child: SizedBox(
                height: 20.h,
                width: MediaQuery.of(context).size.width,
                child: _defiMenu(context)
              ),
            ),
        
            const SizedBox(height: 10), 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "NFTs",
                fontSize: 17.5,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
              child: SizedBox(
                height: 20.h,
                width: MediaQuery.of(context).size.width,
                child: _marketPlaceMenu(context)
              ),
            ),
        
            const SizedBox(height: 10), 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "DApps",
                fontSize: 17.5,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
              child: _selEcoSysMenu(context),
            ),
          ]
        ),
      ),
    );
  }

  Widget _searchInputWeb(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(paddingSize),
      height: 25.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage('assets/search_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const MyText(
                  text: 'Browser',
                  fontWeight: FontWeight.w700,
                  color2: Colors.white,
                  fontSize: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                const MyText(
                  right: 25,
                  left: 25,
                  text: "Welcome to Bitriel browser you can search any site you want",
                  color2: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  onFieldSubmitted: (val) {
                    Navigator.push(
                      context,
                      Transition(child: MarketPlaceWebView(url: searchController!.text, title: "Browser",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                    );
                  },
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    fontSize: 14,
                    color: hexaCodeToColor(AppColors.whiteColorHexa),
                  ),
                  decoration: InputDecoration(
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
                    ),

                    hintText: "Enter site name or URL",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: hexaCodeToColor(AppColors.whiteColorHexa),
                    ),

                    prefixStyle: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 18.0),
                    
                    /* Prefix Text */
                    filled: true,
                    fillColor: hexaCodeToColor("#D9D9D9").withOpacity(0.5),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          Transition(child: MarketPlaceWebView(url: searchController!.text, title: "Browser",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                        );
                      },
                      icon: Icon(Iconsax.search_normal_1, color: hexaCodeToColor( AppColors.whiteHexaColor), size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _marketPlaceMenu(BuildContext context) {

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 125 / 456,
        crossAxisCount: 2,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: marketPlaceList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
          child: DefiMenuItem(
            image: Image.asset(
              marketPlaceList[index]['asset'],
              width: 10.w,
              height: 10.h,
            ),
            title: marketPlaceList[index]['title'],
            subtitle: marketPlaceList[index]['subtitle'],
            action: () async {
              Navigator.push(
                context,
                Transition(child: MarketPlaceWebView(url: marketPlaceList[index]['url'], title: marketPlaceList[index]['title'],), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              );
            },
          ),
        );
      },
    );
  }

  Widget _defiMenu(BuildContext context) {

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 125 / 456,
        crossAxisCount: 2,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: defiList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
          child: DefiMenuItem(
            image: Image.asset(
              defiList[index]['asset'],
              width: 10.w,
              height: 10.h,
            ),
            title: defiList[index]['title'],
            subtitle: defiList[index]['subtitle'],
            action: () async {
              Navigator.push(
                context,
                Transition(child: MarketPlaceWebView(url: defiList[index]['url'], title: defiList[index]['title'],), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              );
            },
          ),
        );
      },
    );
  }

  Widget _selEcoSysMenu(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  "assets/logo/weteka.png",
                  width: 30.w,
                ),
                title: "Weteka",
                action: () async {
                  await LaunchApp.openApp(
                  androidPackageName: 'com.koompi.sala',
                  // openStore: false
                );
                },
              ),
            ),

            const SizedBox(width: 10,),

            Expanded(
              child: SelEcoSysMenuItem(
                image: SvgPicture.asset(
                  "assets/logo/Koompi_wifi.svg",
                  width: 14.w,
                  color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : "#0CACDA"),
                ),
                title: "KOOMPI Fi-Fi",
                action: () {
                  underContstuctionAnimationDailog(context: context);
                },
              ),
            )
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  isDarkMode ?
                  "assets/logo/selendra-logo.png" :
                  "assets/logo/selendra.png",
                  width: 7.w,
                ),
                title: "Funan DApp",
                action: () {
                  underContstuctionAnimationDailog(context: context);
                },
              ),
            ),

            const SizedBox(width: 10,),

            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  isDarkMode 
                  ? "assets/logo/bitriel-light.png" 
                  : "assets/logo/bitriel-logo-v2.png",
                  width: 10.w,
                ),
                title: "Bitriel DEX",
                action: () {
                  underContstuctionAnimationDailog(context: context);
                },
              ),
            )
          ],
        )
      ],
    );
  }


}