import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  // final List portList;
  // final WalletSDK sdk;
  // final Keyring keyring;

  // QrScanner({this.portList, this.sdk, this.keyring});

  @override
  State<StatefulWidget> createState() {
    return QrScannerState();
  }
}

class QrScannerState extends State<QrScanner> {

  final GlobalKey qrKey = GlobalKey();

  Future? _onQrViewCreated(QRViewController controller) async {
    try {
      controller.scannedDataStream.listen((event) async {
        controller.dispose();

        Navigator.pop(context, event.code);

      });

    } catch (e) {
     
    }

    return controller;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: BodyScaffold(
        physic: const NeverScrollableScrollPhysics(),
        height: MediaQuery.of(context).size.height,
        bottom: 0,
        child: Column(
          children: [
            MyAppBar(
              title: "Scanning",
              color: isDarkTheme
                ? hexaCodeToColor(AppColors.darkCard)
                : hexaCodeToColor(AppColors.whiteHexaColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: (QRViewController qrView) async {
                  await _onQrViewCreated(qrView);
                  // print(qrKey.currentState);
                },
                overlay: QrScannerOverlayShape(
                  borderRadius: 10,
                  borderWidth: 10,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}