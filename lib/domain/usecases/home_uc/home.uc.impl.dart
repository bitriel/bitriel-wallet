

import 'package:bitriel_wallet/index.dart';

class HomeUcImpl implements HomeUsecase {

  BuildContext? context;

  final double logoSize = 40;

  set setBuildContext(BuildContext ctx){
    context = ctx;
  }

  Future<void> swapOption() async {

    await showDialog(
      context: context!, 
      builder: (context) {
        return AlertDialog(
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                IconButton(
                  onPressed: (){
                    
                    Navigator.pushReplacement(
                      context,
                      // MaterialPageRoute(builder: (builder) => SwapExchange())
                      MaterialPageRoute(builder: (builder) => SwapExolicExchange())
                    );
                    
                  }, 
                  icon: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: SizedBox(
                          width: logoSize, height: logoSize,
                          child: Image.network("https://images.revain.org/blob/exolix_logo_1465e435_cebe_4c03_8ad1_10dcfdb214cb_9416e99266@128x128.png")
                        ),
                      ),
                      
                      const SizedBox(width: 20,),
                      const MyTextConstant(text:"Exolic", fontWeight: FontWeight.bold, fontSize: 18,),
                    ],
                  )
                ),

                const Divider(),
          
                IconButton(
                  onPressed: (){
                    
                    Navigator.pushReplacement(
                      context,
                      // MaterialPageRoute(builder: (builder) => SwapExchange())
                      MaterialPageRoute(builder: (builder) => SwapExchange())
                    );
                    
                  }, 
                  icon: Row(
                    children: [
                      
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: SizedBox(
                          width: logoSize, height: logoSize,
                          child: Image.network("https://images.crunchbase.com/image/upload/c_lpad,f_auto,q_auto:eco,dpr_1/ay0ngf0n5loi3yfjapbh")
                        ),
                      ),
                      
                      const SizedBox(width: 20,),
                      const MyTextConstant(text: "LetsExchange", fontWeight: FontWeight.bold, fontSize: 18,),
                    ],
                  )
                )
              ],
            ),
          ),
        );
      }
    );
  }
}