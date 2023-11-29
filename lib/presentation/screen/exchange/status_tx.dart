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
                      context: context,
                      exchangeUcImpl: exchangeUcImpl!,
                      lstTx: List<ExChangeTxI>.from(exchangeUcImpl!.exchanges![tabBarIndex].tx),
                      index: exchangeUcImpl!.exchanges![tabBarIndex].tx.indexOf(e) 
                    );
                  }).toList(),
                );
              }
            )
    
          ],
        ),
      ),
    );
  }

  Widget _statusSwapRes({BuildContext? context, required ExchangeUcImpl exchangeUcImpl, required List<ExChangeTxI> lstTx, int? index}) {
    
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
          text: lstTx[index].createdAt == null ? '' : tzToDateTime(lstTx[index].createdAt!),
          color2: hexaCodeToColor(AppColors.iconGreyColor),
          textAlign: TextAlign.start,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            const MyTextConstant(
              text: "Status",
              textAlign: TextAlign.end,
              fontWeight: FontWeight.bold,
            ),

            ValueListenableBuilder(
              valueListenable: exchangeUcImpl.statusNotifier,
              builder: (context, statusNotifier, wg) {

                return MyTextConstant(
                  text: lstTx[index].status!,
                  color2: hexaCodeToColor(AppColors.primary),
                  textAlign: TextAlign.end,
                );
              }
            )
          ],
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