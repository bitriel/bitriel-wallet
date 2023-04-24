import 'package:wallet_apps/src/components/selendra_swap_c.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/swap_exchange_c.dart';

class DiscoverContent {

  static BuildContext? _context;

  static List<SelendraSwap>? lsSelendraSwap = [];

  static List<SwapExchange> lsSwapExchange = [];

  static AppProvider? _appPro;

  static void initContext({required BuildContext? context}){
    _context = context;

    _appPro ??= Provider.of<AppProvider>(_context!, listen: false);
    
    lsSwapExchange =  [
      SwapExchange(
        title: "Pancake Swap",
        image: Image.asset("${_appPro!.dirPath}/logo/pancake.png", width: 10, height: 10),
        action: () {
          underContstuctionAnimationDailog(context: _context);
        },
      ),

      SwapExchange(
        title: "Sushi Swap",
        image: Image.asset("${_appPro!.dirPath}/logo/sushi.png", width: 10, height: 10),
        action: () {
          underContstuctionAnimationDailog(context: _context);
        },
      ),

    ];

    lsSelendraSwap =  [
      SelendraSwap(
        title: "Claim Free SEL Tokens",
        subtitle: "Your chance to get SEL tokens via our Airdrops. It's just a few clicks away.",
        image: SvgPicture.asset("${_appPro!.dirPath}/icons/gift.svg",),
        action: () {
          underContstuctionAnimationDailog(context: _context);
        },
      ),

      SelendraSwap(
        title: "SEL Token Sale",
        subtitle: "We are doing limited time Presale for SEL token. Get discounted price before IDO and Exchange listings.",
        image: SvgPicture.asset("${_appPro!.dirPath}/icons/sale.svg",),
        action: () {
          underContstuctionAnimationDailog(context: _context);
          // Navigator.push(_context!, Transition(child: Presale(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        },
      ),

      // SelendraSwap(
      //   title: "Swap SEL from V1 to V2",
      //   subtitle: "If you have SEL v1, now it’s a good time to swap it to v2",
      //   image: Image.asset("${_appPro!.dirPath}/SelendraCircle-White.png",), 
      //   action: () {
      //     Navigator.push(_context!, Transition(child: Swap(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
      //   },
      // ),

      SelendraSwap(
        title: "Stacking SEL Token",
        subtitle: "Earn passive income SEL token",
        image: SvgPicture.asset("${_appPro!.dirPath}/icons/coin_stack.svg",),
        action: () {
          underContstuctionAnimationDailog(context: _context);
        },
      ),
      
    ];
    
  }
}