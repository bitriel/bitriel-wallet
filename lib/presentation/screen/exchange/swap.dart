import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.uc.impl.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/exchange/status_tx.dart';
import 'package:bitriel_wallet/presentation/widget/toggle_animation_widget.dart';

class SwapScreen extends StatelessWidget {
  
  SwapScreen({super.key});

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
                    MaterialPageRoute(builder: (builder) => StatusExolixExchange(exchangeUcImpl: _exchangeUcImpl,))
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
      body: SingleChildScrollView(
        child: SizedBox(
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
                  child: Column(
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
                  ),
                ),
              ),
        
              AnimatedToggle(
                values: const ["Exolix", "Let's Exchange"],
                onToggleCallback: _exchangeUcImpl.switchExchange,
                buttonColor: hexaCodeToColor(AppColors.primaryBtn),
                backgroundColor: hexaCodeToColor(AppColors.primaryBtn).withOpacity(0.2),
                textColor: Colors.white,
              ),
        
              Expanded(
                child: Container()
              ),
        
              Center(
                child: _buildNumberPad(context, _exchangeUcImpl.swapModel.withdrawAmt!.value, _exchangeUcImpl.onDeleteTxt, _exchangeUcImpl.formatDouble)
              ),
        
              // Swap Button
              SafeArea(
                child: ValueListenableBuilder(
                  valueListenable: _exchangeUcImpl.isBtn,
                  builder: (context, isBtn, wg) {
              
                    return MyButton(
                      edgeMargin: const EdgeInsets.all(paddingSize),
                      textButton: "Swap",
                      buttonColor: isBtn == false ? AppColors.greyCode : AppColors.primaryBtn,
                      action: isBtn == false ? null : 
                      () async {
                        await _exchangeUcImpl.swap();
                      },
                    );
                  }
                ),
              ),
              
            ],
          ),
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
                      child: ValueListenableBuilder(
                        valueListenable: leUCImpl.swapModel.withdrawAmt!,
                        builder: (context, amt, widget) {

                          return MyTextConstant(
                            textAlign: TextAlign.start,
                            text: amt.isEmpty ? "0.00" : amt.toString(),
                            fontSize: 20,
                            color2: amt.isEmpty ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                          );
                        }
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
                      if (isReady == true) leUCImpl.setCoin(true);
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                if(leUCImpl.coin1 != null)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: 30, 
                                  width: 30, 
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50), 
                                    child: leUCImpl.coin1!.icon!.contains('.svg') ? SvgPicture.network(leUCImpl.coin1!.icon!) : Image.network(leUCImpl.coin1!.icon!)
                                  ) //_buildImageItem(index),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3.8,
                                      child: MyTextConstant(
                                        text: leUCImpl.coin1 != null ? leUCImpl.coin1?.coinName : 'Select Token',
                                        // color2: coin1.title == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                                        // fontWeight: coin1.title == null ? FontWeight.normal : FontWeight.bold,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    if (leUCImpl.coin1 != null) Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: leUCImpl.coin1!.shortName == "BEP20" ? Colors.cyanAccent : const Color.fromARGB(255, 96, 237, 169),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: MyTextConstant(
                                        text: leUCImpl.coin1!.shortName ?? 'Native',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        textAlign: TextAlign.start,
                                      ),
                                    )
                                  ],
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
                        valueListenable: leUCImpl.isReceiveAmt,
                        builder: (context, receiveingAmt, wg) {

                          if (receiveingAmt == true) {
                            return const SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(child: CircularProgressIndicator()));
                          }

                          return MyTextConstant(
                            textAlign: TextAlign.start,
                            // text: pro.lstConvertCoin![pro.name2] != null ? "≈ ${pro.lstConvertCoin![pro.name2]}" : "≈ 0",
                            text: "≈ ${leUCImpl.swapModel.depositAmt}",
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

                        leUCImpl.setCoin(false);
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                if(leUCImpl.coin2 != null)
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: 30, 
                                  width: 30, 
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50), 
                                    child: leUCImpl.coin2!.icon!.contains('.svg') ? SvgPicture.network(leUCImpl.coin2!.icon!) : Image.network(leUCImpl.coin2!.icon!)
                                  ) //_buildImageItem(index),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 3.8,
                                      child: MyTextConstant(
                                        text: leUCImpl.coin2 != null ? leUCImpl.coin2?.coinName : 'Select Token',
                                        // color2: coin1.title == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                                        // fontWeight: coin1.title == null ? FontWeight.normal : FontWeight.bold,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    if (leUCImpl.coin2 != null) Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: leUCImpl.coin2!.shortName == "BEP20" ? Colors.cyanAccent : const Color.fromARGB(255, 96, 237, 169),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: MyTextConstant(
                                        text: leUCImpl.coin2!.shortName ?? 'Native',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          }
                        )

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