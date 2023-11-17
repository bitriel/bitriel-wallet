import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/swap_exolix_ex/swap_ex_screen.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    walletProvider.marketUCImpl.getMarkets();    

    Provider.of<SDKProvider>(context, listen: false).setBuildContext = context;
    
    Provider.of<SDKProvider>(context, listen: false).fetchAllAccount();

    Provider.of<WalletProvider>(context, listen: false).setBuildContext = context;

    Provider.of<WalletProvider>(context, listen: false).getAsset();

    walletProvider.marketUCImpl.scrollController.addListener(() {
      walletProvider.marketUCImpl.backToTop.value = walletProvider.marketUCImpl.scrollController.offset > 400 ? true : false;
    });

    return Scaffold(
      body: SingleChildScrollView(
        controller: walletProvider.marketUCImpl.scrollController,
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: hexaCodeToColor(AppColors.white),
          child: Column(
            children: [
      
              _menuItems(context),
      
              _top100Tokens(context, walletProvider.marketUCImpl),
      
            ],
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: walletProvider.marketUCImpl.backToTop,
        builder: (context, value, wg){
          return floatButton(walletProvider.marketUCImpl.scrollController, value);
        }
      )
    );
  }

  Widget floatButton(ScrollController scrollController, bool backToTop) 
  => backToTop ? FloatingActionButton(
    onPressed: () {
      scrollController.animateTo(
        0, 
        duration: const Duration(seconds: 1), 
        curve: Curves.bounceInOut
      );
    },
    child: const Icon(Iconsax.arrow_up_3),
  ) 
  : const SizedBox();

  Widget _menuItems(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hexaCodeToColor(AppColors.cardColor),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 14, right: 14, left: 14, bottom: 14 / 2 ),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DashboardMenuItem(
                          title: "Swap",
                          asset: "assets/icons/exchange.png",
                          hexColor: "#219EBC",
                          action: () {
                            Navigator.push(
                              context,
                              // MaterialPageRoute(builder: (builder) => SwapExchange())
                              MaterialPageRoute(builder: (builder) => SwapExolicExchange())
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: DashboardMenuItem(
                          title: "Staking",
                          asset: "assets/icons/stake.png",
                          hexColor: "#FF9F00",
                          action: () async {
                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.info,
                              text: 'In Development',
                            );
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
                        child: DashboardMenuItem(
                          title: "Buy",
                          asset: "assets/icons/wallet.png",
                          hexColor: "#FF0071",
                          action: () async {
                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.info,
                              text: 'In Development',
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: DashboardMenuItem(
                          title: "Bitriel NFTs",
                          asset: "assets/icons/digital.png",
                          hexColor: "#6C15ED",
                          action: () async {
                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.info,
                              text: 'In Development',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _listScrollMenuItem() {
    List<String> menuName = ["Any Tickets", "Bitriel Go", "Bitriel Pay", "Bitriel X", "Bitriel ID"];
    List<String> menuImage = [
      "assets/logo/bitriel-logo.png",
      "assets/logo/bitriel-logo.png",
      "assets/logo/bitriel-logo.png",
      "assets/logo/bitriel-logo.png",
      "assets/logo/bitriel-logo.png",
    ];

    return ListView.builder(
      shrinkWrap: true,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      scrollDirection: Axis.horizontal,
      itemCount: menuName.length,
      itemBuilder:(context, index) {
        return Padding(
          padding: EdgeInsets.only(left: 14.0, right: index == menuName.length - 1 ? 14 : 0),
          child: ScrollMenuItem(
            title: menuName[index], 
            asset: menuImage[index],
            action: () async{
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.info,
                text: 'In Development',
              );
            }
          ),
        );
      },
    );
  }
  
  Widget _top100Tokens(BuildContext context, MarketUCImpl coinMarketCap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [

          const Align(
            alignment: Alignment.topLeft,
            child: MyTextConstant(
              text: "Top Coins 100",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          ValueListenableBuilder(
            valueListenable: coinMarketCap.lstMarket, 
            builder: (context, value, wg){
              if (value.isEmpty) return const ShimmerMarketWidget();
              return _listMarketView(value);
            }
          )

        ],
      ),
    ); 
  }

  Widget _listMarketView(List<Market> markets){
    
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemCount: markets.length,
      shrinkWrap: true,
      itemBuilder: (context, index){

        Market current = markets[index];

        final String priceConvert = double.parse("${current.price}".replaceAll(",", "")).toStringAsFixed(2);
        
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TokenInfo(tokenName: current.name, market: markets, index: index,))
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                // Asset Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: Colors.white, 
                    child: Image.network(
                      current.logo, width: 30, height: 30,
                    )
                  )
                ),
            
                // Asset Name
                const SizedBox(width: 10),
          
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                
                      Row( 
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          
                          MyTextConstant(
                            text: current.symbol.toUpperCase(),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color2: hexaCodeToColor(AppColors.text),
                            textAlign: TextAlign.start,
                          ),
          
                        ],
                      ),
                
                      MyTextConstant(
                        text: current.name,
                        fontSize: 12,
                        color2: hexaCodeToColor(AppColors.darkGrey),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
                
                const Spacer(),
          
                // Total Amount
                MyTextConstant(
                  fontSize: 17,
                  text: "\$${priceConvert.replaceAllMapped(Fmt().reg, Fmt().mathFunc)}",
                  textAlign: TextAlign.right,
                  fontWeight: FontWeight.w600,
                  color2: hexaCodeToColor(AppColors.text),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
