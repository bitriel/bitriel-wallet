import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';
import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.uc.impl.dart';
import 'package:bitriel_wallet/index.dart';

class StatusExolixExchange extends StatelessWidget {

  final ExchangeUcImpl? exchangeUcImpl;

  const StatusExolixExchange({super.key, required this.exchangeUcImpl});

  @override
  Widget build(BuildContext context) {
    
    exchangeUcImpl!.tabBarIndex.value = 0;

    exchangeUcImpl!.getTrxHistory();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar(context, title: "Exchange Status"),
        body: Column(
          children: [
    
            TabBar(
              onTap: exchangeUcImpl?.onChangedTabBar,
              tabs: const [
                Tab(text: "Exolix",),
                Tab(text: "LetsExchange",)
              ]
            ),
            
            ValueListenableBuilder(
              valueListenable: exchangeUcImpl!.tabBarIndex,
              builder: (context, tabBarIndex, wg) {

                if (exchangeUcImpl!.exchanges![tabBarIndex].tx.isEmpty){
                  return const Center(
                    child: MyTextConstant(text: "No Transaction",),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  children: exchangeUcImpl!.exchanges![tabBarIndex].tx.reversed.map((e) {
                    return _statusSwapRes(
                      exchangeUcImpl: exchangeUcImpl!,
                      lstTx: List<ExChangeTxI>.from(exchangeUcImpl!.exchanges![tabBarIndex].tx),
                      index: exchangeUcImpl!.exchanges![tabBarIndex].tx.indexOf(e) 
                    );
                  }).toList(),
                );
              }
            )
            // TabBarView(
            //   children: [

            //     ListView(
            //       shrinkWrap: true,
            //       children: exchangeUcImpl!.exchanges![exchangeUcImpl!.currentIndex.value].tx.reversed.map((e) {
            //         return _statusSwapRes(
            //           exchangeUcImpl: exchangeUcImpl!,
            //           lstTx: exchangeUcImpl!.exchanges![exchangeUcImpl!.currentIndex.value].tx,
            //           index: exchangeUcImpl!.exchanges![exchangeUcImpl!.currentIndex.value].tx.indexOf(e) 
            //         );
            //       }).toList(),
            //     ),
            //     ListView(
            //       shrinkWrap: true,
            //       children: exchangeUcImpl!.exchanges![exchangeUcImpl!.tabBarIndex].tx.reversed.map((e) {
            //         return _statusSwapRes(
            //           exchangeUcImpl: exchangeUcImpl!,
            //           lstTx: exchangeUcImpl!.exchanges![exchangeUcImpl!.currentIndex].tx,
            //           index: exchangeUcImpl!.exchanges![exchangeUcImpl!.currentIndex].tx.indexOf(e) 
            //         );
            //       }).toList(),
            //     )

            //   ]
            // )
    
            // ValueListenableBuilder(
            //   valueListenable: exchangeUcImpl!.isReady,
            //   builder: (context, lst, wg) {
    
            //     if (exchangeUcImpl!.lstTx!.isEmpty){
            //       return Center(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
                  
            //             Padding(
            //               padding: const EdgeInsets.only(top: 150),
            //               child: Lottie.asset(
            //                 "assets/animation/search_empty.json",
            //                 repeat: false,
            //                 height: 200,
            //                 width: 200
            //               ),
            //             ),
                  
            //             const MyTextConstant(
            //               text: "No request exchange activity.",
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //             )
                  
            //           ],
            //         ),
            //       );
            //     }
    
            //     // ignore: curly_braces_in_flow_control_structures, unnecessary_null_comparison
            //     else if (lst == null) return Expanded(
            //       child: Shimmer.fromColors(
            //         baseColor: Colors.grey[300]!,
            //         highlightColor: Colors.grey[100]!,
            //         child: ListView.builder(
            //         itemCount: 6,
            //         itemBuilder: (context, index) {
            //           return Card(
            //           elevation: 1.0,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(16),
            //           ),
            //           child: const SizedBox(height: 80),
            //           );
            //         },
            //         ),
            //       )
            //     );
                
            //     return 
            // ListView(
            //       shrinkWrap: true,
            //       children: exchangeUcImpl!.exchanges![exchangeUcImpl!.currentIndex.value].tx.reversed.map((e) {
            //         return _statusSwapRes(
            //           exchangeUcImpl: exchangeUcImpl!,
            //           lstTx: exchangeUcImpl!.exchanges![exchangeUcImpl!.currentIndex.value].tx,
            //           index: exchangeUcImpl!.exchanges![exchangeUcImpl!.currentIndex.value].tx.indexOf(e) 
            //         );
            //       }).toList(),
            //     )
              // }
            // )
    
          ],
        ),
      ),
    );
  }

  Widget _statusSwapRes({required ExchangeUcImpl exchangeUcImpl, required List<ExChangeTxI> lstTx, int? index}) {
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: ListTile(
        onTap: () {
          exchangeUcImpl.confirmSwap(index);
        },
        title: MyTextConstant(
          text: "Exchange ID: ${lstTx[index!].id}",
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.start,
        ),
        subtitle: MyTextConstant(
          text: "Status: ${lstTx[index].createdAt == null ? '' : tzToDateTime(lstTx[index].createdAt!)}",
          color2: hexaCodeToColor(AppColors.iconGreyColor),
          textAlign: TextAlign.start,
        ),
        trailing: ValueListenableBuilder(
          valueListenable: ValueNotifier(false),
          builder: (context, statusNotifier, wg) {

            return MyTextConstant(
              text: "Status: ${lstTx[index].status!}",
              color2: hexaCodeToColor(AppColors.primary),
              textAlign: TextAlign.end,
            );
          }
        ),
      ),
    );
  }

  Widget _inputExchangeID() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: const Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                child: Text(
                  'Enter Exchange ID',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: TextField(
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                  decoration: InputDecoration(
                      hintText: 'Exchange ID',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}