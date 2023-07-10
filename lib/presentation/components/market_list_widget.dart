import 'package:bitriel_wallet/domain/model/market_top100_m.dart';
import 'package:bitriel_wallet/index.dart';

class CoinMarketList extends StatefulWidget {

  final List<ListMetketCoinModel>? listCoinMarket;
  final int? index;

  const CoinMarketList({Key? key,
    @required this.listCoinMarket,
    @required this.index,
  }) : super(key: key);

  @override
  State<CoinMarketList> createState() => _CoinMarketListState();
}

class _CoinMarketListState extends State<CoinMarketList> {

  // String periodID = '1DAY';
  // void queryAssetChart(int index, StateSetter modalSetState) async {
  //   await ApiCalls().getChart(
  //     widget.listCoinMarket![index].symbol!, 
  //     'usd', periodID, 
  //     DateTime.now().subtract(const Duration(days: 6)), 
  //     DateTime.now()
  //   ).then((value) {
  //     setState(() {
  //       widget.listCoinMarket![index].chart = value;
  //     });

  //     modalSetState( () {});

  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: hexaCodeToColor("#E8F4FA"),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            // Asset Logo
            widget.listCoinMarket![widget.index!].image != null ? SizedBox(
              height: 35,
              width: 35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(color: Colors.white, child: Image.network(widget.listCoinMarket![widget.index!].image!))
              ),
            ) 
            : const ClipRRect(
              child: SizedBox(
                height: 35,
                width: 35,
              ),
            ),
        
            // Asset Name
            const SizedBox(width: 10),
    
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  Row( 
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      
                      MyTextConstant(
                        text: widget.listCoinMarket![widget.index!].symbol != null ? '${widget.listCoinMarket![widget.index!].symbol!.toUpperCase()} ' : '',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color2: hexaCodeToColor(AppColors.text),
                        textAlign: TextAlign.start,
                      ),
      
                    ],
                  ),
            
                  MyTextConstant(
                    text: widget.listCoinMarket![widget.index!].name ?? '',
                    fontSize: 14,
                    color2: hexaCodeToColor(AppColors.darkGrey),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            
            const Spacer(),
      
            // Total Amount
            MyTextConstant(
              fontSize: 17,
              // width: double.infinity,
              text: "\$${double.parse("${widget.listCoinMarket![widget.index!].currentPrice}".replaceAll(",", "")).toStringAsFixed(2)}",//!.length > 7 ? double.parse(scModel!.balance!).toStringAsFixed(4) : scModel!.balance,
              textAlign: TextAlign.right,
              fontWeight: FontWeight.w600,
              color2: hexaCodeToColor(AppColors.text),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}