import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:wallet_apps/app.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletconnect_c.dart';
import 'package:wallet_apps/src/provider/atd_pro.dart';
import 'package:wallet_apps/src/provider/auth/google_auth_service.dart';
import 'package:wallet_apps/src/provider/event_p.dart';
import 'package:wallet_apps/src/provider/headless_webview_p.dart';
import 'package:wallet_apps/src/provider/newarticle_p.dart';
import 'package:wallet_apps/src/provider/presale_p.dart';
import 'package:wallet_apps/src/provider/airdrop_p.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_apps/src/provider/ticket_p.dart';
import 'package:wallet_apps/src/provider/verify_seed_p.dart';

Future<void> main() async {
  
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Catch Error During Callback
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.dumpErrorToConsole(details);
  //   if (kReleaseMode) exit(1);
  // };
  
  Stripe.publishableKey = dotenv.get("PUBLIC_KEY_STRIPE");
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WalletProvider>(
          create: (context) => WalletProvider(),
        ),
        ChangeNotifierProvider<MarketProvider>(
          create: (context) => MarketProvider(),
        ),
        ChangeNotifierProvider<ApiProvider>(
          create: (context) => ApiProvider(),
        ),
        ChangeNotifierProvider<ContractProvider>(
          create: (context) => ContractProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<PresaleProvider>(
          create: (context) => PresaleProvider(),
        ),
        ChangeNotifierProvider<Attendance>(
          create: (context) => Attendance(),
        ),
        ChangeNotifierProvider<AirDropProvider>(
          create: (context) => AirDropProvider(),
        ),
        ChangeNotifierProvider<SwapProvider>(
          create: (context) => SwapProvider(),
        ),
        ChangeNotifierProvider<ReceiveWalletProvider>(
          create: (context) => ReceiveWalletProvider(),
        ),
        ChangeNotifierProvider<WalletConnectProvider>(
          create: (context) => WalletConnectProvider(),
        ),
        ChangeNotifierProvider<ContractsBalance>(
          create: (context) => ContractsBalance(),
        ),
        ChangeNotifierProvider<MDWProvider>(
          create: (context) => MDWProvider(),
        ),
        ChangeNotifierProvider<GoogleAuthService>(
          create: (context) => GoogleAuthService(),
        ),
        ChangeNotifierProvider<TicketProvider>(
          create: (context) => TicketProvider(),
        ),
        ChangeNotifierProvider<HeadlessWebView>(
          create: (context) => HeadlessWebView(),
        ),
        ChangeNotifierProvider<EventProvider>(
          create: (context) => EventProvider(),
        ),
        ChangeNotifierProvider<VerifySeedsProvider>(
          create: (context) => VerifySeedsProvider(),
        ),
        ChangeNotifierProvider<ArticleProvider>(
          create: (context) => ArticleProvider(),
        ),
        ChangeNotifierProvider<AppProvider>(
          create: (context) => AppProvider(),
        ),
        // ChangeNotifierProvider<DOER>(
        //   create: (context) => GoogleAuthService(),
        // ),
      ],
      child: const App()
    ),
  );
}