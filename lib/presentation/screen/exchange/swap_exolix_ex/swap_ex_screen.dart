import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.uc.impl.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/exchange/swap_exolix_ex/lst_exolix_tx.exchange.dart';

class SwapExolicExchange extends StatelessWidget {
  
  SwapExolicExchange({super.key});

  final ExchangeUcImpl _exchangeUcImpl = ExchangeUcImpl();

  @override
  Widget build(BuildContext context) {

    _exchangeUcImpl.setContext = context;

    _exchangeUcImpl.initExchangeState();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: hexaCodeToColor(AppColors.background),
        title: ValueListenableBuilder(
          valueListenable: _exchangeUcImpl.currentIndex,
          builder: (context, currentIndex, wg) {
            
            return MyTextConstant(
              text: _exchangeUcImpl.exchanges?[currentIndex].title, //"Swap Exolix"
              fontSize: 26,
              color2: hexaCodeToColor(AppColors.midNightBlue),
              fontWeight: FontWeight.w600,
            );
          }
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Iconsax.arrow_left_2,
            size: 30,
            color: hexaCodeToColor(AppColors.midNightBlue),
          ),
        ),
        actions: [
          
          ValueListenableBuilder(
            valueListenable: _exchangeUcImpl.isReady,
            builder: (context, isReady, wg) {

              return TextButton(
                onPressed: isReady == false ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => StatusExolixExchange(exolixExchangeUCImpl: _exchangeUcImpl.exolicUCImpl,))
                  );
                }, 
                child: MyTextConstant(
                  text: "Status",
                  color2: hexaCodeToColor(AppColors.primary),
                ),
              );
            }
          )
          
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: ValueListenableBuilder(
                  valueListenable: _exchangeUcImpl.swapModel.amt!,
                  builder: (context, value, wg) {
                    return Column(
                      children: [

                        _payInput(context, _exchangeUcImpl),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: (){
                              
                            },
                            icon: Icon(Iconsax.refresh_circle, size: 35, color: hexaCodeToColor(AppColors.orangeColor),)
                          ),
                        ),
                      
                        _getDisplay(context, _exchangeUcImpl),
                      ],
                    );
                  }
                ),
              ),
            ),

            const MyTextConstant(text: "Exchange",),
            ValueListenableBuilder(
              valueListenable: _exchangeUcImpl.isExchangeStateReady,
              builder: (context, isExchangeStateReady, wg) {

                if (isExchangeStateReady == false) return const Center(child: CircularProgressIndicator(),);

                return DropdownButton<int>(
                  value: _exchangeUcImpl.currentIndex.value,
                  items: _exchangeUcImpl.exchanges?.map((e) {
                    return DropdownMenuItem<int>(
                      onTap: () => _exchangeUcImpl.switchExchange(_exchangeUcImpl.exchanges!.indexOf(e)),
                      value: _exchangeUcImpl.exchanges!.indexOf(e),
                      child: MyTextConstant(text: e.title),
                    );
                  }).toList() , 
                  onChanged: _exchangeUcImpl.onDropDownChange
                );
              }
            ),

            Expanded(
              child: Container()
            ),

            Center(
              child: _buildNumberPad(context, _exchangeUcImpl.exolicUCImpl.swapModel.amt!.value, _exchangeUcImpl.exolicUCImpl.onDeleteTxt, _exchangeUcImpl.exolicUCImpl.formatDouble)
            ),

            // Swap Button
            ValueListenableBuilder(
              valueListenable: _exchangeUcImpl.exolicUCImpl.isReady,
              builder: (context, isReady, wg) {
                return MyButton(
                  edgeMargin: const EdgeInsets.all(paddingSize),
                  textButton: "Swap",
                  buttonColor: isReady == false ? AppColors.greyCode : AppColors.primaryBtn,
                  action: isReady == false ? null : 
                  () async {
                    await _exchangeUcImpl.exolicUCImpl.exolixSwap();
                  },
                );
              }
            ),
      
          ],
        ),
      ),
    );
  }

  Widget _payInput(BuildContext context, ExchangeUcImpl leUCImpl) {

    return Padding(
      padding: const EdgeInsets.only(top: paddingSize, left: paddingSize, right: paddingSize),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                
                MyTextConstant(
                  text: 'You send',
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                  fontSize: 18,
                ),
                
              ],
            ),
          ),
          
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.50,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.50,
                      padding: const EdgeInsets.only(top: paddingSize, left: paddingSize / 2, bottom: paddingSize),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: hexaCodeToColor(AppColors.background)
                      ),
                      child: MyTextConstant(
                        textAlign: TextAlign.start,
                        text: leUCImpl.swapModel.amt!.value.isEmpty ? "0.00" : leUCImpl.swapModel.amt!.value.toString(),
                        fontSize: 20,
                        color2: leUCImpl.swapModel.amt!.value.isEmpty ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(child: Container()),

              ValueListenableBuilder(
                valueListenable: leUCImpl.isReady, 
                builder: (context, isReady, wg){

                  return isReady == false 
                  ? Shimmer.fromColors(
                    baseColor: hexaCodeToColor(AppColors.background),
                    highlightColor: hexaCodeToColor(AppColors.orangeColor),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.20,
                      padding: const EdgeInsets.only(top: paddingSize, left: paddingSize / 2, bottom: paddingSize),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: hexaCodeToColor(AppColors.background)
                      ),
                      child: const MyTextConstant(
                        text: "Token Loading...",
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  )
                  
                  : InkWell(
                    onTap: (){

                      if (isReady == true) leUCImpl.setCoin(context, true);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.20,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.20,
                        padding: const EdgeInsets.only(top: paddingSize, left: paddingSize / 2, bottom: paddingSize),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: hexaCodeToColor(AppColors.background)
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: leUCImpl.isCoin1,
                          builder: (context, isCoin1, wg) {
                            
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                if(leUCImpl.coin1 != null)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: 40, 
                                  width: 40, 
                                  child: ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.network(leUCImpl.coin1!.icon!)) //_buildImageItem(index),
                                ),

                                MyTextConstant(
                                  text: leUCImpl.coin1 != null ? leUCImpl.coin1?.coinName : 'Select Token',
                                  // color2: coin1.title == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                                  // fontWeight: coin1.title == null ? FontWeight.normal : FontWeight.bold,
                                )
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                  );
                }
              ),

            ],
          ),
          
        ],
      ),
    );
  }
  
  Widget _getDisplay(BuildContext context, ExchangeUcImpl leUCImpl){
    return Padding(
      padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: paddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: MyTextConstant(
              text: 'You recieve',
              color2: hexaCodeToColor(AppColors.midNightBlue),
              fontSize: 18,
            ),
          ),    
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // pro.balance2.isNotEmpty ?
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.50,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.50,
                      padding: const EdgeInsets.only(top: paddingSize, left: paddingSize / 2, bottom: paddingSize),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: hexaCodeToColor(AppColors.background)
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: leUCImpl.exolicUCImpl.receiveAmt,
                        builder: (context, receiveAmt, wg) {
                          return MyTextConstant(
                            textAlign: TextAlign.start,
                            // text: pro.lstConvertCoin![pro.name2] != null ? "≈ ${pro.lstConvertCoin![pro.name2]}" : "≈ 0",
                            text: "≈ $receiveAmt",
                            fontSize: 20,
                          );
                        }
                      ),
                    ),
                  )
                ],
              ),

              Expanded(child: Container()),

              ValueListenableBuilder( 
                valueListenable: leUCImpl.isReady, 
                builder: (context, isReady, wg){

                  return isReady == false 
                  ? Shimmer.fromColors(
                    baseColor: hexaCodeToColor(AppColors.background),
                    highlightColor: hexaCodeToColor(AppColors.orangeColor),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.20,
                          padding: const EdgeInsets.only(top: paddingSize, left: paddingSize / 2, bottom: paddingSize),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: hexaCodeToColor(AppColors.background)
                          ),
                          child: const MyTextConstant(
                            text: "Token Loading...",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  )
                  
                  : InkWell(
                    onTap: (){

                      if (isReady == true){

                        leUCImpl.setCoin(context, false);
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.20,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.20,
                        padding: const EdgeInsets.only(top: paddingSize, left: paddingSize / 2, bottom: paddingSize),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: hexaCodeToColor(AppColors.background)
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: leUCImpl.isCoin2,
                          builder: (context, isCoin2, wg) {
                            
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                if(leUCImpl.coin2 != null)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: 40, 
                                  width: 40, 
                                  child: ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.network(leUCImpl.coin2!.icon!)) //_buildImageItem(index),
                                ),

                                MyTextConstant(
                                  text: leUCImpl.coin2 != null ? leUCImpl.coin2?.coinName : 'Select Token',
                                  // color2: coin1.title == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                                  // fontWeight: coin1.title == null ? FontWeight.normal : FontWeight.bold,
                                )
                              ],
                            );
                          }
                        )
                        // ValueListenableBuilder(
                        //   valueListenable: leUCImpl.coin2,
                        //   builder: (context, coin2, wg) {
                        //     return Row(
                        //       children: [
                        //         MyTextConstant(
                        //           text: coin2.title ?? 'Select Token',
                        //           color2: coin2.title == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                        //           fontWeight: coin2.title == null ? FontWeight.normal : FontWeight.bold,
                        //         ),

                        //         coin2.networkCode != null ? MyTextConstant(
                        //           text: " (${coin2.networkCode})",
                        //           color2: coin2.networkCode == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                        //           overflow: TextOverflow.ellipsis,
                        //         ) : const SizedBox(),

                        //         const Spacer(),

                        //         Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.orangeColor),),

                        //         const SizedBox(width: 10),
                        //       ],
                        //     );
                        //   }
                        // ),
                      ),
                    ),
                  );
                }
              ),
            
            ],
          ),
        ],
      ),
    );
  }

  /// dd stand for dropdown
  Widget _ddTokenButton({Function()? onPressed, required int? i, required ExolixExchangeUCImpl exolixExchangeRepoImpl}){
    
    return GestureDetector(
      onTap: onPressed!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      
          SizedBox(
            height: 30,
            width: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: exolixExchangeRepoImpl.lstLECoin.value[0].image!
            ),
          ),

          const SizedBox(width: 5),
          
          MyTextConstant(
            textAlign: TextAlign.start,
            text: i == 0 ? exolixExchangeRepoImpl.lstLECoin.value[0].title : exolixExchangeRepoImpl.lstLECoin.value[1].title,
            fontSize: 18,
            color2: hexaCodeToColor("#949393"),
          ),
      
          const Icon(
            Iconsax.arrow_down_1,
            size: 20
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad(context, String valInput, Function onDeleteTxt, Function formatCurrency) {
    return SwapNumPad(
      buttonSize: 10,
      valInput: valInput,
      buttonColor: hexaCodeToColor("#FEFEFE"),
      delete: onDeleteTxt,
      formatCurrency: formatCurrency,
    );
  }

}