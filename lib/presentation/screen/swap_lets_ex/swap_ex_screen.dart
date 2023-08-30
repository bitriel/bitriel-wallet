import 'package:bitriel_wallet/index.dart';

class SwapExchange extends StatelessWidget {
  
  const SwapExchange({super.key});

  @override
  Widget build(BuildContext context) {

    final LetsExchangeUCImpl letsExchangeUCImpl = LetsExchangeUCImpl();

    letsExchangeUCImpl.setContext = context;

    letsExchangeUCImpl.getLetsExchangeCoin();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: hexaCodeToColor(AppColors.background),
        title: MyTextConstant(
          text: "Swap",
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
                MaterialPageRoute(builder: (builder) => StatusExchange(letsExchangeUCImpl: letsExchangeUCImpl,))
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
                  valueListenable: letsExchangeUCImpl.swapModel.amt!,
                  builder: (context, value, wg) {
                    return Column(
                      children: [

                        _payInput(context, letsExchangeUCImpl),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: (){
                              
                            },
                            icon: const Icon(Iconsax.refresh_circle, size: 35,)
                          ),
                        ),
                      

                        _getDisplay(context, letsExchangeUCImpl),
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
              child: _buildNumberPad(context, letsExchangeUCImpl.swapModel.amt!.value, letsExchangeUCImpl.onDeleteTxt, letsExchangeUCImpl.formatDouble)
            ),

            ValueListenableBuilder(
              valueListenable: letsExchangeUCImpl.isReady,
              builder: (context, isReady, wg) {
                return MyButton(
                  edgeMargin: const EdgeInsets.all(paddingSize),
                  textButton: "Swap",
                  buttonColor: isReady == false ? AppColors.greyCode : AppColors.primaryBtn,
                  action: isReady == false ? null : () async {
                    await letsExchangeUCImpl.swap();
                  },
                );
              }
            ),
      
          ],
        ),
      ),
    );
  }

  Widget _payInput(BuildContext context, LetsExchangeUCImpl leUCImpl) {
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
                valueListenable: leUCImpl.coin1, 
                builder: (context, value, wg){
                  return InkWell(
                    onTap: (){
                      leUCImpl.setCoin(context, true);
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
                        child: Row(
                          children: [
                            MyTextConstant(
                              text: value.title ?? 'Select Token',
                              color2: value.title == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                              fontWeight: value.title == null ? FontWeight.normal : FontWeight.bold,
                            ),

                            value.networkCode != null ? MyTextConstant(
                              text: " (${value.networkCode})",
                              color2: value.networkCode == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                              overflow: TextOverflow.ellipsis,
                            ) : const SizedBox(),

                            const Spacer(),

                            Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.orangeColor),),

                            const SizedBox(width: 10),
                          ],
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
  
  Widget _getDisplay(BuildContext context, LetsExchangeUCImpl leUCImpl){
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
                      child: const MyTextConstant(
                        textAlign: TextAlign.start,
                        // text: pro.lstConvertCoin![pro.name2] != null ? "≈ ${pro.lstConvertCoin![pro.name2]}" : "≈ 0",
                        text: "≈ 0.00",
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),

              Expanded(child: Container()),

              ValueListenableBuilder(
                valueListenable: leUCImpl.coin2, 
                builder: (context, value, wg){
                  return InkWell(
                    onTap: (){
                      leUCImpl.setCoin(context, true);
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
                        child: Row(
                          children: [
                            MyTextConstant(
                              text: value.title ?? 'Select Token',
                              color2: value.title == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                              fontWeight: value.title == null ? FontWeight.normal : FontWeight.bold,
                            ),

                            value.networkCode != null ? MyTextConstant(
                              text: " (${value.networkCode})",
                              color2: value.networkCode == null ? hexaCodeToColor(AppColors.grey) : hexaCodeToColor(AppColors.midNightBlue),
                              overflow: TextOverflow.ellipsis,
                            ) : const SizedBox(),

                            const Spacer(),

                            Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.orangeColor),),

                            const SizedBox(width: 10),
                          ],
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
  Widget _ddTokenButton({BuildContext? context, Function()? onPressed, required int? i, required LetsExchangeUCImpl letsExchangeRepoImpl}){
    
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
              child: letsExchangeRepoImpl.lstLECoin.value[0].image!// SvgPicture.network(i == 0 ? letsExchangeRepoImpl.lstLECoin.value[0].image!.replaceAll("\\/", "/") : letsExchangeRepoImpl.lstLECoin.value[1].icon!.replaceAll("\\/", "/")) ,
            ),
          ),

          const SizedBox(width: 5),
          
          MyTextConstant(
            textAlign: TextAlign.start,
            text: i == 0 ? letsExchangeRepoImpl.lstLECoin.value[0].title : letsExchangeRepoImpl.lstLECoin.value[1].title,
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