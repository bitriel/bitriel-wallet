import 'package:bitriel_wallet/index.dart';

class StatusExchange extends StatelessWidget {

  final LetsExchangeUCImpl? letsExchangeUCImpl;

  const StatusExchange({super.key, required this.letsExchangeUCImpl});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appBar(context, title: "Exchange Status"),
      body: Column(
        children: [
          
          // _inputExchangeID(),
          
          // MyButton(
          //   edgeMargin: const EdgeInsets.all(paddingSize),
          //   textButton: "Check",
          //   action: () async {

          //   },
          // ),

          ValueListenableBuilder(
            valueListenable: letsExchangeUCImpl!.lstTx,
            builder: (context, lst, wg) {
              return ListView(
                shrinkWrap: true,
                children: lst.map((e) {
                  return _statusSwapRes(letsExchangeUCImpl: letsExchangeUCImpl!, index: lst.indexOf(e));
                }).toList(),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _statusSwapRes({required LetsExchangeUCImpl letsExchangeUCImpl, int? index}) {
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: ListTile(
        onTap: () {
          letsExchangeUCImpl.confirmSwap(index);
        },
        title: MyTextConstant(
          text: "Exchange ID: ${letsExchangeUCImpl.lstTx.value[index!].transaction_id}",
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.start,
        ),
        subtitle: MyTextConstant(
          text: "Status: ${letsExchangeUCImpl.lstTx.value[index].created_at}",
          color2: hexaCodeToColor(AppColors.iconGreyColor),
          textAlign: TextAlign.start,
        ),
        trailing: MyTextConstant(
          text: "Status: ${letsExchangeUCImpl.lstTx.value[index].status}",
          color2: hexaCodeToColor(AppColors.primary),
          textAlign: TextAlign.end,
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