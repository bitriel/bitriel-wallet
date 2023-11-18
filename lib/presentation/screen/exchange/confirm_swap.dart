import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';
import 'package:bitriel_wallet/index.dart';

class ConfirmSwapExchange extends StatelessWidget {

  final ValueNotifier<bool>? statusNotifier;

  final ExChangeTxI? exChangeTxI;

  final Function? confirmSwap;

  final Function? getStatus;
  
  const ConfirmSwapExchange({required this.statusNotifier, super.key, required this.exChangeTxI, required this.confirmSwap, this.getStatus});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context, title: "Swap"),
      body: Column(
        children: [
      
          _swapTokenInfo(exChangeTxI),

          _trxExchangeInfo(context, exChangeTxI, getStatus!),

          Expanded(
            child: Container()
          ),

          exChangeTxI!.status!.toLowerCase() != "success" ? MyButton(
            edgeMargin: const EdgeInsets.all(paddingSize),
            textButton: "Confirm",
            action: () {
              confirmSwap!(exChangeTxI);
            },
          ) : const SizedBox(),
      
        ],
      ),
    );
  }

  Widget _swapTokenInfo(ExChangeTxI? exChangeTxI) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
    
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [

                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    // child: exChangeTxI!.coinFromIcon!.contains('.svg') ? SvgPicture.network(exChangeTxI.coinFromIcon!) : Image.network(exChangeTxI.coinFromIcon!),
                  )
                ),
          
                const SizedBox(width: 10.0),
          
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextConstant(
                      text: "You Swap",
                      color2: hexaCodeToColor(AppColors.grey),
                      fontWeight: FontWeight.w600,
                    ),
          
                    Row(
                      children: [

                        MyTextConstant(
                          text: "${exChangeTxI!.depositAmt} ${exChangeTxI.coinFrom}",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.cyanAccent
                          ),
                          child: MyTextConstant(
                            text: "${exChangeTxI.coinFromNetwork}",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
    
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: (){
                
              },
              icon: Icon(Iconsax.arrow_down, color: hexaCodeToColor(AppColors.primary), size: 35,)
            ),
          ),
    
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [

                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    // child: exChangeTxI.coinToIcon!.contains('.svg') ? SvgPicture.network(exChangeTxI.coinToIcon!) : Image.network(exChangeTxI.coinToIcon!),
                  )
                ),
          
                const SizedBox(width: 10.0),
          
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextConstant(
                      text: "You Will Get",
                      color2: hexaCodeToColor(AppColors.grey),
                      fontWeight: FontWeight.w600,
                    ),
          
                    
                    Row(
                      children: [

                        MyTextConstant(
                          text: exChangeTxI.withdrawalAmount,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),

                        MyTextConstant(
                          text: "${exChangeTxI.withdrawalAmount} ${exChangeTxI.coinTo}",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.cyanAccent
                          ),
                          child: MyTextConstant(
                            text: "${exChangeTxI.coinToNetwork}",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
    
        ],
      ),
    );
  }

  Widget _trxExchangeInfo(BuildContext context, ExChangeTxI? exChangeTxI, Function getStatus) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
    
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: hexaCodeToColor(AppColors.background),
              borderRadius: const BorderRadius.all(Radius.circular(18),
              ),
            ),
            child: Column(
              children: [
            
                Row(
                  children: [
                    MyTextConstant(
                      text: "From Address",
                      fontWeight: FontWeight.w600,
                      color2: hexaCodeToColor(AppColors.darkGrey),
                    ),
            
                    const Spacer(),
            
                    MyTextConstant(
                      text: exChangeTxI!.withdrawalAddress!.replaceRange(6, exChangeTxI.withdrawalAddress!.length - 6, "......."),
                      fontWeight: FontWeight.w600,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primary), size: 20),
                      onPressed: () async {
                        Clipboard.setData(
                          ClipboardData(text: exChangeTxI!.depositAddr!.replaceRange(6, exChangeTxI!.depositAddr!.length - 6, ".......")),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("From Address is Copied to Clipboard"),
                          ),
                        );
                      },  
                    )
                  ],
                ),
            
                const Divider(),
            
                Row(
                  children: [
                    MyTextConstant(
                      text: "To Address",
                      fontWeight: FontWeight.w600,
                      color2: hexaCodeToColor(AppColors.darkGrey),
                    ),
            
                    const Spacer(),
            
                    MyTextConstant(
                      text: exChangeTxI.depositAddr!.replaceRange(6, exChangeTxI.depositAddr!.length - 6, "......."),
                      fontWeight: FontWeight.w600,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primary), size: 20),
                      onPressed: () async {
                        Clipboard.setData(
                          ClipboardData(text: exChangeTxI!.depositAddr!),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("To Address is Copied to Clipboard"),
                          ),
                        );
                      },  
                    )
                  ],
                ),
            
                const Divider(),
            
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      MyTextConstant(
                        text: "Provider",
                        fontWeight: FontWeight.w600,
                        color2: hexaCodeToColor(AppColors.darkGrey),
                      ),
                            
                      const Spacer(),
                            
                      const MyTextConstant(
                        text: "Exolix.com",
                        fontWeight: FontWeight.w600,
                      ),
                    
                      const SizedBox(width: 10),
                    
                    ],
                  ),
                ),
            
              ],
            ),
          ),
    
          const SizedBox(height: 10),
    
          InkWell(
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: exChangeTxI!.id!),
              );
              /* Copy Text */
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Exchange ID is Copied to Clipboard"),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(paddingSize),
              decoration: BoxDecoration(
                color: hexaCodeToColor(AppColors.cardColor),
                borderRadius: const BorderRadius.all(Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
              
                  Row(
                    children: [
              
                      Flexible(
                        flex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      
                            MyTextConstant(
                              text: "Exchange ID",
                              fontWeight: FontWeight.w600,
                              color2: hexaCodeToColor(AppColors.darkGrey),
                            ),
          
                            const SizedBox(height: 2.5,),
                            
                            MyTextConstant(
                              text: "${exChangeTxI.id}",
                              color2: hexaCodeToColor(AppColors.primary),
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.bold,
                            ),
                      
                          ],
                        ),
                      ),
              
                      const Spacer(),

                      Flexible(
                        flex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      
                            MyTextConstant(
                              text: "Status",
                              fontWeight: FontWeight.w600,
                              color2: hexaCodeToColor(AppColors.darkGrey),
                            ),
          
                            const SizedBox(height: 2.5,),
                            
                            ValueListenableBuilder(
                              valueListenable: statusNotifier!,
                              builder: (context, statusNotifier, wg) {
                                
                                print("statusNotifier $statusNotifier");
                                return MyTextConstant(
                                  text: "Status: ${exChangeTxI!.status}",
                                  color2: hexaCodeToColor(AppColors.primary),
                                  textAlign: TextAlign.end,
                                );
                              }
                            )
                      
                          ],
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        icon: Icon(Iconsax.refresh_circle, color: hexaCodeToColor(AppColors.orangeColor)),
                        onPressed: () async {

                          exChangeTxI = await getStatus();

                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          statusNotifier!.notifyListeners();
                        },  
                      )
                      
                    ],
                  ),
              
                ],
              ),
            ),
          ),
    
        ],
      ),
    ); 
  }


}