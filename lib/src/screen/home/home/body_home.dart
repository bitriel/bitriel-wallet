import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/scroll_speed.dart';
import 'package:wallet_apps/src/models/image_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_apps/src/provider/app_p.dart';
import 'package:wallet_apps/src/provider/newarticle_p.dart';
import 'package:wallet_apps/src/screen/home/home/article/article_news.dart';
import 'package:wallet_apps/src/screen/home/swap/bitriel_swap/swap.dart';
import 'package:wallet_apps/src/screen/home/wallet/wallet.dart';
import 'package:wallet_apps/src/screen/home/events/events.dart';
import 'package:wallet_apps/src/screen/home/discover/discover.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/home/home/market/coin_market.dart';
import 'package:wallet_apps/src/screen/home/setting/setting.dart';

class HomePageBody extends StatelessWidget {

  final bool? isTrx;
  final List<Map<String, dynamic>>? imgList;
  final HomePageModel? homePageModel;
  final bool? pushReplacement;
  final Function(int index)? onPageChanged;
  // final Function? onTapWeb;
  // final Function? getReward;
  final Function? downloadAsset;

  const HomePageBody({ 
    Key? key, 
    this.isTrx,
    this.imgList,
    this.homePageModel,
    this.onPageChanged,
    this.pushReplacement,
    // this.onTapWeb,
    // this.getReward,
    this.downloadAsset
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: homePageModel!.globalKey,
      // extendBody: true,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: const Menu(),
        ),
      ),
      appBar: homePageModel!.activeIndex != 4 ? defaultAppBar(
        context: context,
        homePageModel: homePageModel,
        pushReplacement: pushReplacement
      ) : null,
      body: UpgradeAlert(
        upgrader: Upgrader(
          dialogStyle: UpgradeDialogStyle.material,
          durationUntilAlertAgain: const Duration(minutes: 30)
        ),
        child: PageView(
          physics: const CustomPageViewScrollPhysics(),
          controller: homePageModel!.pageController,
          onPageChanged: onPageChanged,
          children: [
            
            DiscoverPage(homePageModel: homePageModel!),
      
            WalletPage(isTrx: isTrx, homePageModel: homePageModel,),
      
            DefaultTabController(
              length: 2,
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        toolbarHeight: 300,
                        pinned: true,
                        floating: true,
                        snap: true,
                        title: _menu(context),
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        bottom: TabBar(
                          labelColor: hexaCodeToColor(AppColors.primaryColor),
                          unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
                          indicatorColor: hexaCodeToColor(AppColors.primaryColor),
                          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'NotoSans'),
                          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'NotoSans'),
                          tabs: const [
      
                            Tab(
                              text: "Markets",
                            ),
      
                            Tab(
                              text: "News",
                            ),
      
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                
                body: _coinMenuCategory(),
              ),
            ),
            // SwapPage(),
            const FindEvent(),
      
            const SettingPage(),
            // const NFT(),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(
        index: homePageModel!.activeIndex,
        onIndexChanged: onPageChanged,
      ),
    );
  }

  Widget _carouselAds(BuildContext context, int activeIndex) {
    return Container(
      margin: const EdgeInsets.only(top: paddingSize + 10, bottom: 10),
      child: Column(
        children: [
    
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,  
                aspectRatio: 29 / 10,
                autoPlay: true,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: homePageModel!.onAdsCarouselChanged,
              ),
              items: imgList!
                .map((item) => GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context, 
                    //   Transition(child: AdsWebView(item: item), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                    // );
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (BuildContext context) => const HomePage(activePage: 3,)), (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        child: 
                        // item['asset'].contains("https") ? Image.network(
                        //   item['asset'],
                        //   fit: BoxFit.fill,
                        //   width: MediaQuery.of(context).size.width,
                        // )
                        // : 
                        Image.asset(
                          item['asset'], 
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
            ),
          ),
    
          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: imgList!.length,
            effect: SlideEffect(
              radius: 5.0,
              dotWidth: 20.0.sp,
              dotHeight: 7.0.sp,
              paintStyle: PaintingStyle.fill,
              dotColor: hexaCodeToColor(AppColors.greyColor).withOpacity(0.36),
              activeDotColor: hexaCodeToColor(AppColors.secondary),
            ), 
            
          ),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, pro, wg) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Expanded(
                    child: MyMenuItem(
                      title: "Swap",
                      asset: "${pro.dirPath}/icons/swap-coin.png",
                      colorHex: "#0D6BA6",
                      action: () async {
                        Navigator.push(
                          context,
                          Transition(child: const SwapPage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                        );
                        // await showBarModalBottomSheet(
                        //   context: context,
                        //   backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                        //   shape: const RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.vertical(
                        //       top: Radius.circular(25.0),
                        //     ),
                        //   ),
                        //   builder: (context) => Column(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: const [
                        //       SwapMethod(),
                        //     ],
                        //   ),
                        // );
                      },
                    ),
                  ),
                
                  const SizedBox(width: 10,),
                
                  Expanded(
                    child: MyMenuItem(
                      title: "Staking",
                      asset: "${pro.dirPath}/icons/stake-coin.png",
                      colorHex: "#151644",
                      action: () {
                        underContstuctionAnimationDailog(context: context);
                      },
                    ),
                  ),
                ],
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MyMenuItem(
                      title: "Buy",
                      asset: "${pro.dirPath}/icons/buy-coin.png",
                      colorHex: "#F29F05",
                      action: () async {
                        underContstuctionAnimationDailog(context: context);
                      },
                    ),
                  ),
        
                  const SizedBox(width: 10,),
        
                  Expanded(
                    child: MyMenuItem(
                      title: "Bitriel NFTs",
                      asset: "${pro.dirPath}/icons/nft_polygon.png",
                      colorHex: "#192E3C",
                      action: () {

                        underContstuctionAnimationDailog(context: context);
                        
                        // customDialog(
                        //   context, 
                        //   'Access to Bitriel NFTs?', 
                        //   'Bitriel NFTs is still in development!!!\n\n You can play around with Bitriel NFTs page.',
                        //   txtButton: "Cancel",
                        //   btn2: MyFlatButton(
                        //     height: 60,
                        //     edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
                        //     isTransparent: false,
                        //     buttonColor: AppColors.whiteHexaColor,
                        //     textColor: AppColors.redColor,
                        //     textButton: "Confirm",
                        //     isBorder: true,
                        //     action: () {
                        //       // Close pop up dialog
                        //       Navigator.pop(context);

                        //       Navigator.push(
                        //         context, 
                        //         Transition(
                        //           child: const NFTMarketPlace(),
                        //           transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                        //         )
                        //       );
                        //     }
                        //   )
                        // );
                        
                      },
                    ),
                  ),
        
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _coinMenuCategory() {

    return TabBarView(
      children: [

        Consumer<MarketProvider>(
          builder: (context, marketProvider, widget) {
            return SingleChildScrollView(
              child: Column(
                children: [
                            
                  if (marketProvider.lsMarketLimit.isNotEmpty)
                  CoinMarket(lsMarketCoin: marketProvider.lsMarketLimit,)
                            
                  else if(marketProvider.lsMarketLimit.isEmpty) 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: paddingSize),
                    child: Column(
                      children: [
                                  
                        Lottie.asset(
                          "assets/animation/search_empty.json",
                          repeat: true,
                          reverse: true,
                          width: 70.w,
                        ),
                                  
                        const MyText(
                          text: "Opps, Something went wrong!", 
                          fontSize: 17, 
                          fontWeight: FontWeight.w600,
                          pTop: 20,
                        )          
                      ],
                    ),
                  ),
                  
                  AppUtils.discliamerShortText(context),
                ],
              ),
            );
          }
        ),

        // Consumer<MarketProvider>(
        //   builder: (context, marketProvider, widget) {
        //     return SingleChildScrollView(
        //       child: Column(
        //         children: [
                            
        //           if (marketProvider.cnts.isNotEmpty)
        //           CoinTrending(trendingCoin: marketProvider.cnts,)
                            
        //           else if(marketProvider.cnts.isEmpty) 
        //           Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 20),
        //             child: Column(
        //               children: [
                                  
        //                 Lottie.asset(
        //                   "assets/animation/search_empty.json",
        //                   repeat: true,
        //                   reverse: true,
        //                   width: 70.w,
        //                 ),
                        
                                  
        //                 const MyText(
        //                   text: "Opps, Something went wrong!", 
        //                   fontSize: 17, 
        //                   fontWeight: FontWeight.w600,
        //                   pTop: 20,
        //                 )
                                  
        //               ],
        //             ),
        //           ),
                  
        //           AppUtils.discliamerShortText(context),
        //         ],
        //       ),
        //     );
        //   }
        // ),

        Consumer<ArticleProvider>(
          builder: (context, articleProvider, widget) {
            return SingleChildScrollView(
              child: Column(
                children: [
                            
                  if (articleProvider.articleQueried!.isNotEmpty)
                  ArticleNews(articleQueried: articleProvider.articleQueried,)
                            
                  else if(articleProvider.articleQueried!.isEmpty) 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                                  
                        Lottie.asset(
                          "assets/animation/search_empty.json",
                          repeat: true,
                          reverse: true,
                          width: 70.w,
                        ),
                        
                                  
                        const MyText(
                          text: "Opps, Something went wrong!", 
                          fontSize: 17, 
                          fontWeight: FontWeight.w600,
                          pTop: 20,
                        )
                                  
                      ],
                    ),
                  ),
                  
                  AppUtils.discliamerShortText(context),
                ],
              ),
            );
          }
        ),
      ],
    );
  }

}