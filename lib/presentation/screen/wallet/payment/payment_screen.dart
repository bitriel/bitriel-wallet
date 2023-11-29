import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/wallet/payment/coin_select_screen.dart';

class TokenPayment extends StatelessWidget {

  final int? index;
  final String? address;
  final String? amt;
  
  TokenPayment({Key? key, this.index, this.address, this.amt}) : super(key: key);
  
  final PaymentUcImpl paymentUcImpl = PaymentUcImpl();

  @override
  Widget build(BuildContext context) { 

    paymentUcImpl.setBuildContext = context;

    if (address != null) paymentUcImpl.recipientController.text = address!;

    if (amt != null) paymentUcImpl.amountController.text = amt!;

    if (index != null) paymentUcImpl.assetChanged(index!);

    if (address != null && amt != null) {
      paymentUcImpl.isReady.value = true;
    }

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.background),
      appBar: appBar(context, title: "Send", dispose: (){
        Navigator.pop(context, paymentUcImpl.isPaySuccess);
      }),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
      
            ValueListenableBuilder(
              valueListenable: paymentUcImpl.index, 
              builder: (context, value, wg){

                if (paymentUcImpl.lstContractDropDown.isEmpty) return const SizedBox();
                
                return Container(
                  margin: const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0, bottom: 0.0),
                  child: Card(
                    color: hexaCodeToColor(AppColors.white),
                    child: ListTile(
                      leading: SizedBox(
                        height: 40,
                        width: 40,
                        child: paymentUcImpl.lstContractDropDown[value].logo != null ? 
                        Image.network(paymentUcImpl.lstContractDropDown[value].logo!, height: 40, width: 40,) : 
                        CircleAvatar(
                          child: MyTextConstant(
                            text: paymentUcImpl.lstContractDropDown[value].isBep20 == true ? "BEP20" : "ERC20",
                            fontSize: 10,
                          ),
                        ),
                      ),
                      title: MyTextConstant(
                        text: paymentUcImpl.lstContractDropDown[value].balance,//double.parse(paymentUcImpl.lstContractDropDown[value].balance!).toStringAsFixed(4),
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                      ),
                      subtitle: Row(
                        children: [

                          MyTextConstant(
                            text: "${paymentUcImpl.lstContractDropDown[value].name!} (${paymentUcImpl.lstContractDropDown[value].symbol!})",
                            textAlign: TextAlign.start,
                            fontSize: 12,
                          ),

                          paymentUcImpl.lstContractDropDown[value].isNative == true || 
                          paymentUcImpl.lstContractDropDown[value].isEther == true ||
                          paymentUcImpl.lstContractDropDown[value].isBSC == true ?
                          Container() :
                          Card(
                            color: hexaCodeToColor(AppColors.cardColor),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: MyTextConstant(
                                text: paymentUcImpl.lstContractDropDown[value].isBep20 == true ? "BNB Smart Chain" : "Ethereum",
                                textAlign: TextAlign.start,
                                fontSize: 10,
                              ),
                            ),
                          )
                        ],
                      ),
                      trailing: const Icon(Iconsax.arrow_right_3),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (builder) => SelectCoin(paymentUcImpl: paymentUcImpl))
                        );
                      },
                    ),
                  ),
                );
              }
            ),
      
            _getEnterAddrSection(paymentUcImpl),
            
            _getEnterAmountSection(paymentUcImpl),
      
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
      
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: paymentUcImpl.isReady,
                      builder: (context, value, wg) {
                        return MyButton(
                          edgeMargin: const EdgeInsets.all(10),
                          textButton: "Send",
                          fontWeight: FontWeight.w600,
                          buttonColor: value == false ? AppColors.grey : AppColors.primaryBtn,
                          opacity: 1,
                          action: value == false ? null : 
                          () async {
                            
                            await paymentUcImpl.submitTrx();
      
                          },
                        );
                      }
                    ),
                  ),
                ],
              ),
            )
      
          ],
        ),
      ),
    );
  }
}

Widget _getEnterAddrSection(PaymentUcImpl paymentUcImpl) {

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: Text(
                'Enter Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: TextFormField(
                controller: paymentUcImpl.recipientController,
                onChanged: paymentUcImpl.onChanged,
                validator: paymentUcImpl.addressValidator,
                focusNode: paymentUcImpl.addrNode,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
                ),
                decoration: const InputDecoration(
                  hintText: 'Address',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _getEnterAmountSection(PaymentUcImpl paymentUcImpl) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: Text(
                'Enter Amount',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: Row(
                children: <Widget>[
                  // SizedBox(
                  //   height: 30,
                  //   width: 30,
                  //   child: Image.asset("assets/logo/bitriel-logo.png", height: 30, width: 30,),
                  // ),
                  // const Text(
                  //   '\$',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold, fontSize: 30.0),
                  // ),
                  Expanded(
                    child: TextFormField(
                      controller: paymentUcImpl.amountController,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      // validator: paymentUcImpl.amtValidator,
                      focusNode: paymentUcImpl.amtNode,
                      onChanged: paymentUcImpl.onChanged,
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Amount',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
