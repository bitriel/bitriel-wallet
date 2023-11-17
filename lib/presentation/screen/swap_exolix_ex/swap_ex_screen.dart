import 'package:bitriel_wallet/domain/usecases/swap_uc/exolix_uc/exolix_ex_uc_impl.dart';
import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/swap_exolix_ex/status_exchange.dart';

class SwapExolicExchange extends StatelessWidget {
  
  SwapExolicExchange({super.key});

  final ExolixExchangeUCImpl exolicUCImpl = ExolixExchangeUCImpl();

  @override
  Widget build(BuildContext context) {

    exolicUCImpl.setContext = context;

    exolicUCImpl.getExolixExchangeCoin();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: hexaCodeToColor(AppColors.background),
        title: MyTextConstant(
          text: "Swap Exolix",
          fontSize: 26,
          color2: hexaCodeToColor(AppColors.midNightBlue),
          fontWeight: FontWeight.w600,
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
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => StatusExolixExchange(exolixExchangeUCImpl: exolicUCImpl,))
              );
            }, 
            child: MyTextConstant(
              text: "Status",
              color2: hexaCodeToColor(AppColors.primary),
            ),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: ValueListenableBuilder(
                  valueListenable: exolicUCImpl.swapModel.amt!,
                  builder: (context, value, wg) {
                    return Column(
                      children: [

                        _payInput(context, exolicUCImpl),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: (){
                              
                            },
                            icon: Icon(Iconsax.refresh_circle, size: 35, color: hexaCodeToColor(AppColors.orangeColor),)
                          ),
                        ),
                      
                        _getDisplay(context, exolicUCImpl),
                      ],
                    );
                  }
                ),
              ),
            ),

            Expanded(
              child: Container()
            ),

            Center(
              child: _buildNumberPad(context, exolicUCImpl.swapModel.amt!.value, exolicUCImpl.onDeleteTxt, exolicUCImpl.formatDouble)
            ),

            // Swap Button
            ValueListenableBuilder(
              valueListenable: exolicUCImpl.isReady,
              builder: (context, isReady, wg) {
                return MyButton(
                  edgeMargin: const EdgeInsets.all(paddingSize),
                  textButton: "Swap",
                  buttonColor: isReady == false ? AppColors.greyCode : AppColors.primaryBtn,
                  action: isReady == false ? null : 
                  () async {
                    await exolicUCImpl.exolixSwap();
                  },
                );
              }
            ),
      
          ],
        ),
      ),
    );
  }

  Widget _payInput(BuildContext context, ExolixExchangeUCImpl leUCImpl) {
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
                valueListenable: leUCImpl.isLstCoinReady, 
                builder: (context, isLstCoinReady, wg){
                  return isLstCoinReady == false 
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
                      
                      if (kDebugMode) {
                        // ignore: unnecessary_null_comparison
                        print(isLstCoinReady == null);
                      }
                      if (isLstCoinReady == true) leUCImpl.setCoin(context, true);
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
                          valueListenable: leUCImpl.coin1,
                          builder: (context, coin1, wg) {
                            return Row(
                              children: [
                                
                                MyTextConstant(
                                  text: coin1.title ?? 'Select Token',
                                  color2: coin1.title == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                                  fontWeight: coin1.title == null ? FontWeight.normal : FontWeight.bold,
                                ),

                                coin1.networkCode != null ? MyTextConstant(
                                  text: " (${coin1.networkCode})",
                                  color2: coin1.networkCode == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                                  overflow: TextOverflow.ellipsis,
                                ) : const SizedBox(),

                                const Spacer(),

                                Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.orangeColor),),

                                const SizedBox(width: 10),
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
  
  Widget _getDisplay(BuildContext context, ExolixExchangeUCImpl leUCImpl){
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
                        valueListenable: leUCImpl.receiveAmt,
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
                valueListenable: leUCImpl.isLstCoinReady, 
                builder: (context, isLstCoinReady, wg){
                  return isLstCoinReady == false 
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

                      if (isLstCoinReady == true){

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
                          valueListenable: leUCImpl.coin2,
                          builder: (context, coin2, wg) {
                            return Row(
                              children: [
                                MyTextConstant(
                                  text: coin2.title ?? 'Select Token',
                                  color2: coin2.title == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                                  fontWeight: coin2.title == null ? FontWeight.normal : FontWeight.bold,
                                ),

                                coin2.networkCode != null ? MyTextConstant(
                                  text: " (${coin2.networkCode})",
                                  color2: coin2.networkCode == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                                  overflow: TextOverflow.ellipsis,
                                ) : const SizedBox(),

                                const Spacer(),

                                Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.orangeColor),),

                                const SizedBox(width: 10),
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