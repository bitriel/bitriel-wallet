import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:permission_handler/permission_handler.dart';

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

  GlobalKey? _qrKey;
  
  QRViewController? _controller;

  Future? _onQrViewCreated(QRViewController controller) async {
    controller.resumeCamera();
    try {
      _controller = controller;
      _controller!.scannedDataStream.listen((event) async {

        Navigator.pop(context, event.code);

      });

    } catch (e) {
     print("error _onQrViewCreated $e");
    }
  }
  
  @override
  void initState() {
    _qrKey = new GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
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
                ? hexaCodeToColor(AppColors.darkBgd).withOpacity(0)
                : hexaCodeToColor(AppColors.whiteHexaColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: QRView(
                key: _qrKey!,
                onQRViewCreated: (QRViewController qrView) async {
                  print("hello");
                  await _onQrViewCreated(qrView);
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
