import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/effect_c.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/menu/presale/presale.dart';

class HomeBody extends StatelessWidget {

  final boxSize = 125.0;
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        
        // Pie Chart With List Asset Market
        // PortFolioCus(),

        // Container(
        //   color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : Colors.white,
        //   padding: EdgeInsets.only(bottom: 15, top: 15, left: 5, right: 5),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [

        //       Expanded(
        //         child: InkWell(
        //           child: Container(
        //             height: boxSize,
        //             width: boxSize,
        //             margin: EdgeInsets.all(10),
        //             alignment: Alignment.center,
        //             decoration: BoxDecoration(
        //               boxShadow: [
        //                 shadow(context)
        //               ],
        //               gradient: LinearGradient(
        //                 begin: Alignment.topLeft,
        //                 end: Alignment.bottomRight,
        //                 colors: [
        //                   hexaCodeToColor('#a0e2ff'),
        //                   hexaCodeToColor('#03a4f4'),
        //                 ]
        //               ),
        //               borderRadius: BorderRadius.circular(20.0),
        //               // color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : hexaCodeToColor(AppColors.whiteColorHexa),
        //             ),
        //             child: MyText(
        //               text: "Airdrop",
        //               color: AppColors.whiteHexaColor,
        //               fontSize: 20,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //           onTap: (){
        //             Navigator.push(context, MaterialPageRoute(builder: (context) => ClaimAirDrop()));
        //           },
        //         ),
        //       ),

        //       Expanded(
        //         child: InkWell(
        //           child: Container(
        //             height: boxSize,
        //             width: boxSize,
        //             margin: EdgeInsets.all(10),
        //             alignment: Alignment.center,
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(20.0),
        //               boxShadow: [
        //                 shadow(context)
        //               ],
        //               gradient: LinearGradient(
        //                 begin: Alignment.topLeft,
        //                 end: Alignment.bottomRight,
        //                 colors: [
        //                   // hexaCodeToColor('#f39d0c'),
        //                   // hexaCodeToColor('#ff7900'),

        //                   hexaCodeToColor('#00ddff'),
        //                   hexaCodeToColor('#2165fa'),
        //                   // hexaCodeToColor('#1278c7'),
        //                 ]
        //               )
        //               // color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : hexaCodeToColor(AppColors.whiteColorHexa),
        //             ),
        //             child: MyText(
        //               text: "Swap",
        //               color: AppColors.whiteHexaColor,
        //               fontSize: 20,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //           onTap: () async {
        //             Navigator.push(context, MaterialPageRoute(builder: (context) => Swap()));
        //             await ContractsBalance().refetchContractBalance(context: context);
        //           },
        //         ),
        //       ),

        //       Expanded(
        //         child: InkWell(
        //           child: Container(
        //             height: boxSize,
        //             width: boxSize,
        //             margin: EdgeInsets.all(10),
        //             alignment: Alignment.center,
        //             decoration: BoxDecoration(
        //               boxShadow: [
        //                 shadow(context)
        //               ],
        //               borderRadius: BorderRadius.circular(20.0),
        //               gradient: LinearGradient(

        //                 begin: Alignment.topLeft,
        //                 end: Alignment.bottomRight,
        //                 colors: [
        //                   hexaCodeToColor('#ffec1f'),
        //                   hexaCodeToColor('#fec204'),
        //                   hexaCodeToColor('#f39d0c'),
        //                 ]
        //               )
        //               // color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : hexaCodeToColor(AppColors.whiteColorHexa),
        //             ),
        //             child: MyText(
        //               text: "Presale",
        //               color: AppColors.whiteHexaColor,
        //               fontSize: 20,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //           onTap: () async {
        //             Navigator.push(context, MaterialPageRoute(builder: (context) => Presale()));
        //             await ContractsBalance().refetchContractBalance(context: context);
        //           },
        //         ),
        //       )
        //     ],
        //   )
        // ),
        
        // Divider(
        //   height: 2,
        //   color: isDarkTheme ? Colors.black : Colors.grey.shade400,
        // ),

        Consumer<ContractProvider>(builder: (context, value, child) {
          return value.isReady
            // Asset List As Row
            ? AnimatedOpacity(
                opacity: value.isReady ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: AssetList(),
              )
            // Loading Data Effect Shimmer
            : MyShimmer(
              isDarkTheme: isDarkTheme,
            );
        }),
      ],
    );
  }
}