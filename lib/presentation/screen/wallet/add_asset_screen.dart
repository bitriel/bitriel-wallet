import 'package:bitriel_wallet/index.dart';

class AddAsset extends StatelessWidget {

  final int? index;

  const AddAsset({super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {

    final AddAssetUcImpl addAssetUcImpl = AddAssetUcImpl();

    addAssetUcImpl.setBuildContext = context;

    addAssetUcImpl.fetchContracts();

    if (index != null) {
      addAssetUcImpl.onChanged(index!);
    }

    return Scaffold(
      appBar: appBar(context, title: "Import Token", dispose: addAssetUcImpl.dispose),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            
            const SizedBox(height: 25,),

            _selectNetwork(context, addAssetUcImpl),
            
            const SizedBox(height: 10),

            TextField(
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
                hintText: "Enter token contract 0x....",
                fillColor: hexaCodeToColor(AppColors.background),
              ),
              controller: addAssetUcImpl.controller,
              onChanged: addAssetUcImpl.onAddrChanged,
              // onChanged: (String value) {
                
              //   // addAssetUcImpl.validateWeb3Address();
              //   // addAssetUcImpl.searchContract();
            
              // },
            ),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(),
            ),

            ValueListenableBuilder(
              valueListenable: addAssetUcImpl.isSearching, 
              builder: (context, value, wg){
                if (value == true){
                  return _resultContract(addAssetUcImpl.searched!, addAssetUcImpl);
                }

                return const SizedBox();
              }
            ),

            Expanded(child: Container()),
            ValueListenableBuilder(
              valueListenable: addAssetUcImpl.isLoadingBtn, 
              builder: (context, value, wg){

                return  MyButton(
                  action: value == true ? null : 
                  () async {
      
                    await addAssetUcImpl.submitSeach();
      
                  },
                  child: value == true ? 
                  const CircularProgressIndicator(color: Colors.white) : 
                  const MyTextConstant(
                    text: "Search",
                    color2: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  )
                );
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _listNetwork(
  {
    BuildContext? context, 
    final bool? isValue,
    final Function? onChanged,
    final List<Map<String, dynamic>>? listNetwork,
  }
  ){
    return Column(
      children: [
        
        Icon(
          Icons.remove,
          color: Colors.grey[600],
          size: 25,
        ),

        Expanded(
          child: ListView.builder(
            itemCount: listNetwork!.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: SizedBox(
                  height: 27,
                  width: 27,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset("${listNetwork[index]["logo"]}", height: 27, width: 27)),
                ),
                title: MyTextConstant(
                  text: listNetwork[index]["symbol"], 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                onTap: () {
                  Navigator.pop(context, index);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _selectNetwork(BuildContext context, AddAssetUcImpl addAssetUcImpl) {
    return GestureDetector(
      onTap: () async {

        await showModalBottomSheet(
          context: context,
          isDismissible: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical( 
              top: Radius.circular(25.0),
            ),
          ),
          builder: (context) => _listNetwork(
            context: context,
            isValue: true,
            listNetwork: addAssetUcImpl.networkSymbol!,
            onChanged: (value) {
              Navigator.pop(context, value);
            }
          ),
        ).then((value) {
        
          addAssetUcImpl.onChanged(value);
          
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15), 
        decoration: BoxDecoration(
          color: hexaCodeToColor(AppColors.background),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: <Widget>[

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: addAssetUcImpl.networkIndex,
                builder: (context, index, wg){
                  return Row(
                    children: [
                      
                      SizedBox(
                        height: 27,
                        width: 27,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(addAssetUcImpl.networkSymbol![index]['logo'], height: 27, width: 27,),
                        ),
                      ),

                      const SizedBox(width: 5),

                      MyTextConstant(
                        text: addAssetUcImpl.networkSymbol![index]['symbol'],
                        fontSize: 17,
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  );
                },
              ),
            ),

            Row(
              children: [
                Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primary),),
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget _resultContract(SmartContractModel model, AddAssetUcImpl addAssetUcImpl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        color: hexaCodeToColor(AppColors.background)
      ),
      child: ListTile(
        leading: const Image(
          image: AssetImage('assets/logo/bitriel-logo.png'),
          height: 35,
          width: 35,
        ),
        title: MyTextConstant(
        text: model.name,
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.start,
      ),
      subtitle: MyTextConstant(
        text: model.symbol,
        color2: hexaCodeToColor(AppColors.grey),
        fontSize: 12,
        textAlign: TextAlign.start,
      ),
        trailing: SizedBox(
          width: 80,
          height: 35,
          child: MyButton(
            textButton: 'Import',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            action: () async{
              await addAssetUcImpl.addAsset();
            },
          ),
        ),
      )
    );
  }

}