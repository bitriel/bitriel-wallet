import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/widget/swap_numpad_c.dart';

class SwapExchange extends StatelessWidget {
  const SwapExchange({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController? myController = TextEditingController();

    return Scaffold(
      appBar: appBar(context, title: "Swap"),
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
                child: Column(
                  children: [

                    _payInput(context, myController),

                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: (){
                          
                        },
                        icon: Icon(Iconsax.refresh_circle, color: hexaCodeToColor(AppColors.primaryColor), size: 35,)
                      ),
                    ),
                  

                    _getDisplay(context),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container()
            ),

            Center(
              child: _buildNumberPad(context, myController,)
            ),

            MyButton(
              edgeMargin: const EdgeInsets.all(paddingSize),
              textButton: "Review Swap",
              action: () async {
                
              },
            ),
      
          ],
        ),
      ),
    );
  }

    Widget _payInput(BuildContext context, TextEditingController myController) {
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
                    width: MediaQuery.of(context).size.width / 2,
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        controller: myController,
                        style: const TextStyle(
                          fontSize: 20
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: const BorderSide(
                              width: 0, 
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: hexaCodeToColor(AppColors.grey)),
                          hintText: "0.00",
                          fillColor: hexaCodeToColor(AppColors.background),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        enableInteractiveSelection: false,
                        showCursor: false,
                        // Disable the default soft keybaord
                        keyboardType: TextInputType.none,
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(child: Container()),

              _ddTokenButton(
                context: context, 
                i: 0,
                onPressed: () async {

                 
                }
              ),

            ],
          ),
          
        ],
      ),
    );
  }
  
  Widget _getDisplay(BuildContext context){
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
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
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
                  )
                ],
              ),

              Expanded(child: Container()),
            
              _ddTokenButton(
                context: context, 
                i: 1,
                onPressed: () async {

                
                }
              ),
              
            ],
          ),
        ],
      ),
    );
  }

  /// dd stand for dropdown
  Widget _ddTokenButton({BuildContext? context, Function()? onPressed, required int? i}){
    
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
              child: const Placeholder(),
            ),
          ),

          const SizedBox(width: 5),
          
          MyTextConstant(
            textAlign: TextAlign.start,
            text: "SEL",
            fontSize: 18,
            color2: hexaCodeToColor("#949393"),
          ),
      
          Icon(
            Iconsax.arrow_down_1,
            color: hexaCodeToColor(AppColors.primaryColor),
            size: 20
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad(context, TextEditingController myController) {
    return SwapNumPad(
      buttonSize: 10,
      buttonColor: hexaCodeToColor("#FEFEFE"),
      controller: myController,
    );
  }

}