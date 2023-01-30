import 'package:scan/scan.dart';
import 'package:wallet_apps/index.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with SingleTickerProviderStateMixin {
  final BorderRadius _borderRadius = const BorderRadius.vertical(
    top: Radius.circular(20),
  );

  late AnimationController controller;
  late Animation<double> scaleAnimation;
  ScanController scanController = ScanController();

  @override
  void dispose() {
    scanController.pause();
    controller.dispose();
    controller.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .8,
                  child: ScanView(
                    controller: scanController,
                    scanLineColor: hexaCodeToColor(AppColors.primaryColor),
                    onCapture: (data) => {
                      Navigator.of(context).pop(data)
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    iconSize: 40,
                    color: hexaCodeToColor(AppColors.primaryColor)
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: _borderRadius,
                      color: hexaCodeToColor(AppColors.whiteColorHexa)
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: const MyText(text: "Send Funds", fontSize: 18, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                          subtitle: const MyText(text: "Scan address QR code to send money", fontSize: 15, textAlign: TextAlign.start),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              SizedBox(
                                width: 30,
                                child: Icon(
                                  Iconsax.arrow_up_3,
                                  color: Colors.black
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const MyText(text: "Connect to apps", fontSize: 18, fontWeight: FontWeight.w600, textAlign: TextAlign.start),
                          subtitle: const MyText(text: "Scan WalletConnect QR code", fontSize: 15, textAlign: TextAlign.start),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Image.asset(
                                  'assets/icons/wallet-connect.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
