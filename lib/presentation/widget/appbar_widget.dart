import 'package:bitriel_wallet/index.dart';

PreferredSizeWidget appBar(final BuildContext context, {required final String title, Function? dispose}) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: hexaCodeToColor(AppColors.background),
    title: MyTextConstant(
      text: title,
      fontSize: 26,
      color2: hexaCodeToColor(AppColors.midNightBlue),
      fontWeight: FontWeight.w600,
    ),
    leading: IconButton(
      onPressed: () {
        if (dispose != null) dispose();
        Navigator.pop(context);
      },
      icon: Icon(
        Iconsax.arrow_left_2,
        size: 30,
        color: hexaCodeToColor(AppColors.midNightBlue),
      ),
    ),
  );
}


PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  required MultiAccountImpl multiAccountImpl
}) {

  const appBarHeight = 80.0;

  multiAccountImpl.setContext(context, listen: false);

  return AppBar(
    backgroundColor: hexaCodeToColor(AppColors.white),
    scrolledUnderElevation: 0,
    elevation: 0,
    // ignore: unrelated_type_equality_checks
    // backgroundColor: ValueListenableProvider.value(value: index!) != 3 ? hexaCodeToColor(AppColors.white) : Colors.black,
    automaticallyImplyLeading: false,
    toolbarHeight: appBarHeight,
    centerTitle: true,
    flexibleSpace: SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 14, right: 14, top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          color: hexaCodeToColor(AppColors.white)
        ),
      ),
    ),
    
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () async{

              await _selectAccount(context, multiAccountImpl);

            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Consumer<SDKProvider>(
              builder: (context, pro, wg) {
                  if (pro.isConnected == false) return const SizedBox();
                  
                  return pro.getSdkImpl.getKeyring.current.icon == null 
                  ? const CircleAvatar() 
                  : RandomAvatar(
                    pro.getSdkImpl.getKeyring.current.address!,
                    height: 40,
                    width: 40
                  );
                }
              ),
            )
          ),
        ),

        const Spacer(),
        
        GestureDetector(
          onTap: () async {
            // bottomSheetCgNetwork(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Consumer<SDKProvider>(
                builder: (context, pro, wg) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 5),
                    child: MyTextConstant(
                      text: pro.isConnected == false ? "" : pro.getSdkImpl.getKeyring.current.address!.replaceRange(6, pro.getSdkImpl.getKeyring.current.address!.length - 6, "......."),
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color2: hexaCodeToColor(AppColors.midNightBlue),
                      fontSize: 15,
                    ),
                  );
                }
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircleAvatar( 
                        child: ClipOval(
                          child: Image.asset(
                            "assets/logo/selendra.png",
                          ),
                        ),
                      ),
                    ),
                  ),

                  MyTextConstant(
                    text: "Selendra Network", 
                    color2: hexaCodeToColor(AppColors.darkGrey), 
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),

                ],
              ),

            ],
          )
        ),

        const Spacer(),

        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10),
            child: IconButton(
              iconSize: 25,
              icon: Icon(
                Iconsax.scan,
                color: hexaCodeToColor(AppColors.midNightBlue),
              ),
              onPressed: () async {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const QrScanner())
                );
              },
            ),
          ),
        ),
      ],
    )
  );
}

  Future<void> _selectAccount(BuildContext context, MultiAccountImpl multiAccountImpl) async {

    int currentIndex = multiAccountImpl.getAllAccount.indexWhere((element) {
      if (multiAccountImpl.getAccount.address == element.address){
        return true;
      }
      return false;
    });

    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical( 
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 15, right: 0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyTextConstant(
                      text: "Swtich Account",
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Iconsax.close_circle, 
                        color: hexaCodeToColor(AppColors.midNightBlue),
                      )
                    )
                  ],
                ),
              ),
              
              Flexible(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: multiAccountImpl.getAllAccount.length,
                  itemBuilder:(context, index) {
              
                    return Container(
                      color: currentIndex == index ? hexaCodeToColor(AppColors.primary).withOpacity(0.25) : Colors.transparent,
                      
                      child: ListTile(
                        leading: multiAccountImpl.getAllAccount[index].icon == null ? 
                        const CircleAvatar() : 
                        RandomAvatar(
                          multiAccountImpl.getAllAccount[index].icon!, 
                          alignment: Alignment.topLeft,
                          height: 40,
                          width: 40
                        ),
                        title: MyTextConstant(
                          text: multiAccountImpl.getAllAccount[index].name ?? '',
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                        subtitle: MyTextConstant(
                          text: multiAccountImpl.getAllAccount[index].address!.replaceRange(10, multiAccountImpl.getAllAccount[index].address!.length - 10, "........"),
                          fontSize: 14,
                          color2: hexaCodeToColor(AppColors.darkGrey),
                          textAlign: TextAlign.start,
                        ),
                        trailing: currentIndex == index ? Icon(Icons.check_circle_rounded, color: hexaCodeToColor(AppColors.primary),) : const SizedBox(),
                        onTap: () async {

                          await multiAccountImpl.switchAccount(multiAccountImpl.getAllAccount[index], index).then((value) => {
                            Navigator.pop(context),
                          });

                        },
                      ),
                    );
                  },
                ),
              ),

              multiAccountImpl.getAllAccount.length == 2 ? const SizedBox() : MyButton(
                edgeMargin: const EdgeInsets.all(15),
                textButton: "Add Account",
                fontWeight: FontWeight.w600,
                action: () async {

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: "/${BitrielRouter.multiAccRoute}"),
                      builder: (context) => const MultiAccountScreen()
                    ) 
                  );
                  
                  setState((){
                    currentIndex = multiAccountImpl.getAllAccount.indexWhere((element) {
                      if (multiAccountImpl.getAccount.address == element.address){
                        return true;
                      }
                      return false;
                    });
                  });

                },
              ),

            ],
          );
        }
      )
    );
  }


void bottomSheetCgNetwork(BuildContext context) async{
  
  return showModalBottomSheet(
    backgroundColor: hexaCodeToColor(AppColors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    context: context,
    builder: (setBuildContext) {

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTextConstant(
                        text: "Networks",
                        fontSize: 18,
                        color2: hexaCodeToColor(AppColors.midNightBlue),
                        fontWeight: FontWeight.w600,
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Iconsax.close_circle, 
                          color: hexaCodeToColor(AppColors.midNightBlue),
                        )
                      )
                    ],
                  ),
                ),

                // Network RPC 0

                Flexible(
                  child: Consumer<SDKProvider>(
                    builder: (context, pro, wg){
                      return ListView.builder(
                        itemCount: pro.getLstSelNetwork.length,
                        shrinkWrap: true,
                        itemBuilder: (contex, nwIndex){

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pro.getLstSelNetwork[nwIndex].network!.index == 0 ? 'Mainnet' : 'Testnet'),
                              ListView.builder(
                              itemCount: pro.getLstSelNetwork[nwIndex].lstNetwork!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, epIndex){
                                return _networkItem(context, pro.getLstSelNetwork[nwIndex].lstNetwork![epIndex], nwIndex, epIndex, setState);
                              },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: MyGradientButton(
                    textButton: "Switch Network",
                    action: () async{
                      Navigator.of(context).pop();
                    },
                  ),
                ),

              ],
            ),
          );
        }
      );

    }
  );
}

Widget _networkItem(BuildContext context, String nw, int nwIndex, int epIndex, Function stateFunc) {
  
  final sdk = Provider.of<SDKProvider>(context, listen: false);
  return InkWell(
    onTap: () async {

      // await sdk.setNetworkParamState(sdk.getLstSelNetwork[nwIndex], nwIndex, epIndex, stateFunc);//getSdkImpl.setNetworkParam(nw, index);
      
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
  
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: hexaCodeToColor(AppColors.primary),
            )
          ),
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: <Widget>[
  
              const SizedBox(width: 10),
  
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
  
                    MyTextConstant(
                      text: "Selendra via Endpoint ${epIndex+1}",
                      color2: hexaCodeToColor(AppColors.midNightBlue),
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
  
                    MyTextConstant(
                      text: nw,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),

              if (
                sdk.getSdkImpl.connectedIndex == epIndex && 
                sdk.getSdkImpl.networkIndex == nwIndex
              )
              const Icon(Icons.check_box)
            ]
          ),
        ),
  
        const SizedBox(height: 10),
      ],
    ),
  );
}