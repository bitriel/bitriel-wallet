import 'package:bitriel_wallet/domain/usecases/swap_uc/exolix_uc/exolix_ex_uc_impl.dart';
import 'package:bitriel_wallet/index.dart';

class StatusExolixExchange extends StatelessWidget {

  final ExolixExchangeUCImpl? exolixExchangeUCImpl;

  const StatusExolixExchange({super.key, required this.exolixExchangeUCImpl});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appBar(context, title: "Exchange Status"),
      body: Column(
        children: [

          ValueListenableBuilder(
            valueListenable: exolixExchangeUCImpl!.lstTx,
            builder: (context, lst, wg) {

              if (lst.isEmpty){
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                
                      Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: Lottie.asset(
                          "assets/animation/search_empty.json",
                          repeat: false,
                          height: 200,
                          width: 200
                        ),
                      ),
                
                      const MyTextConstant(
                        text: "No request exchange activity.",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                
                    ],
                  ),
                );
              }

              // ignore: curly_braces_in_flow_control_structures, unnecessary_null_comparison
              else if (lst[0] == null) return Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Card(
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const SizedBox(height: 80),
                    );
                  },
                  ),
                )
              );
              
              return ListView(
                shrinkWrap: true,
                children: lst.map((e) {
                  return _statusSwapRes(exolixExchangeUCImpl: exolixExchangeUCImpl!, index: lst.indexOf(e));
                }).toList(),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _statusSwapRes({required ExolixExchangeUCImpl exolixExchangeUCImpl, int? index}) {
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: ListTile(
        onTap: () {
          exolixExchangeUCImpl.exolixConfirmSwap(index);
        },
        title: MyTextConstant(
          text: "Exchange ID: ${exolixExchangeUCImpl.lstTx.value[index!]!.id}",
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.start,
        ),
        subtitle: MyTextConstant(
          text: "Status: ${exolixExchangeUCImpl.lstTx.value[index]!.createdAt}",
          color2: hexaCodeToColor(AppColors.iconGreyColor),
          textAlign: TextAlign.start,
        ),
        trailing: MyTextConstant(
          text: "Status: ${exolixExchangeUCImpl.lstTx.value[index]!.status}",
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