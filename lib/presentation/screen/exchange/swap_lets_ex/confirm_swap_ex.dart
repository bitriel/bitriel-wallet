import 'package:bitriel_wallet/index.dart';

class ConfirmSwapExchange extends StatelessWidget {

  final ValueNotifier<bool>? statusNotifier;

  final SwapResModel? swapResModel;

  final Function? confirmSwap;

  final Function? getStatus;
  
  const ConfirmSwapExchange({required this.statusNotifier, super.key, required this.swapResModel, required this.confirmSwap, this.getStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: "Swap"),
      body: Column(
        children: [
      
          _swapTokenInfo(swapResModel),

          _trxExchangeInfo(context, swapResModel, getStatus!),

          Expanded(
            child: Container()
          ),

          swapResModel!.status!.toLowerCase() != "success" ? MyButton(
            edgeMargin: const EdgeInsets.all(paddingSize),
            textButton: "Confirm",
            action: () {
              confirmSwap!(swapResModel);
            },
          ) : const SizedBox(),
      
        ],
      ),
    );
  }

  Widget _swapTokenInfo(SwapResModel? swapResModel) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
    
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar()
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
          
                    MyTextConstant(
                      text: "${swapResModel!.deposit_amount} ${swapResModel.coin_from}",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar()
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
          
                    MyTextConstant(
                      text: swapResModel.withdrawal_amount,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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

  Widget _trxExchangeInfo(BuildContext context, SwapResModel? swapResModel, Function getStatus) {
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
                      text: swapResModel!.withdrawal!.replaceRange(6, swapResModel.withdrawal!.length - 6, "......."),
                      fontWeight: FontWeight.w600,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primary), size: 20),
                      onPressed: () async {
                        Clipboard.setData(
                          ClipboardData(text: swapResModel!.deposit!.replaceRange(6, swapResModel!.deposit!.length - 6, ".......")),
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
                      text: swapResModel.deposit!.replaceRange(6, swapResModel.deposit!.length - 6, "......."),
                      fontWeight: FontWeight.w600,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primary), size: 20),
                      onPressed: () async {
                        Clipboard.setData(
                          ClipboardData(text: swapResModel!.deposit!),
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
                        text: "LetsExchange.io",
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
                ClipboardData(text: swapResModel!.transaction_id!),
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
                              text: "${swapResModel.transaction_id}",
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
                                
                                return MyTextConstant(
                                  text: "Status: ${swapResModel!.status}",
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
                          // Clipboard.setData(
                          //   ClipboardData(text: swapResModel.deposit!),
                          // );
                          // /* Copy Text */
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text("To Address is Copied to Clipboard"),
                          //   ),
                          // );
                          swapResModel = await getStatus();

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