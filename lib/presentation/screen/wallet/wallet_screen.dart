import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/wallet/wallet_info_screen.dart';

class WalletScreen extends StatelessWidget {

  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    // final MultiAccountImpl multiAccountImpl = MultiAccountImpl();

    final walletPro = Provider.of<WalletProvider>(context, listen: false);

    // if (context.mounted){

    //   walletPro.setBuildContext = context;
      
    //   if (walletPro.defaultListContract == null || walletPro.defaultListContract!.isEmpty) {
    //     walletPro.getAsset();
      
    //     Provider.of<SDKProvider>(context, listen: false).fetchAllAccount();
    //   }
    // }

    return SingleChildScrollView(
      child: Column(
        children: [
          
          _cardPortfolio(context,),

          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const Expanded(child: Divider()),
                // Expanded(child: _searchBar(searchController)),

                IconButton(
                  onPressed: () {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddAsset())
                    );
                  
                  }, 
                  icon: const Icon(Iconsax.add_circle)
                ),
          
                
              ],
            ),
          ),

          Consumer<WalletProvider>(
            builder: (context, pro, wg) {
              
              if (pro.sortListContract == null) {
                return const CircularProgressIndicator();
              }
              else if (pro.sortListContract!.isEmpty) {
                return const Text("No token found");
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pro.sortListContract!.length,
                itemBuilder: (context, index){
                  return _getItem(ctx: context, coinMarketCap: walletPro.marketUCImpl, index: index, assetsModel: pro.sortListContract!);
                },
                // children: pro.sortListContract!.map((e) {

                //   return _getItem(ctx: context, coinMarketCap: walletPro.marketUCImpl, element: e, assetsModel: pro.sortListContract!);

                // }).toList(),
              );
            }
          ),

          // Consumer<WalletProvider>(
          //   builder: (context, pro, wg) {
              
          //     if (pro.listErc20 == null) {
          //       return const CircularProgressIndicator();
          //     }
          //     else if (pro.listErc20!.isEmpty) {
          //       return const Text("No token found");
          //     }

          //     return ListView(
          //       shrinkWrap: true,
          //       physics: const NeverScrollableScrollPhysics(),
          //       children: pro.listErc20!.map((e) {

          //         return _getItem(ctx: context, coinMarketCap: walletPro.marketUCImpl, element: e, assetsModel: pro.listErc20!);

          //       }).toList(),
          //     );
          //   }
          // ),

        ],
      ),
    );
     
  }

  Widget _cardPortfolio(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hexaCodeToColor(AppColors.cardColor),
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        children: [

          MyTextConstant(
            text: "Avialable balance",
            color2: hexaCodeToColor(AppColors.darkGrey),
            fontSize: 15,
          ),

          ValueListenableBuilder(
            valueListenable: Provider.of<WalletProvider>(context).mainBalance,
            builder: (context, mainBalance, wg) {
              return MyTextConstant(
                text: "\$${mainBalance.toStringAsFixed(4)}",
                color2: hexaCodeToColor(AppColors.midNightBlue),
                fontSize: 30,
                fontWeight: FontWeight.w600,
              );
            }
          ),

          const SizedBox(height: 15),

          Row(
            children: [

            Expanded(
              child: MyIconButton(
                edgeMargin: const EdgeInsets.all(10),
                fontWeight: FontWeight.w600,
                buttonColor: AppColors.green,
                action: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TokenPayment())
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextConstant(
                      text: "Send",
                      color2: hexaCodeToColor(AppColors.white),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),

                      const SizedBox(width: 5,),

                      const Icon(Iconsax.send_sqaure_2, color: Colors.white, size: 20,)
                    ],
                  ),
                ),
              ),
        
            Expanded(
              child: MyIconButton(
                edgeMargin: const EdgeInsets.all(10),
                fontWeight: FontWeight.w600,
                buttonColor: "#161414",
                action: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReceiveWallet(symbol: "SEL", tokenName: "Selendra Token", tokenNetwork: "Selendra Chain",))
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextConstant(
                      text: "Receive",
                      color2: hexaCodeToColor(AppColors.white),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),

                      const SizedBox(width: 5,),

                      const Icon(Iconsax.receive_square_2, color: Colors.white, size: 20,)
                    ],
                  ),
                ),
              )
            ],
          ),

        ],
      )
    );
  }

  Widget _searchBar(TextEditingController searchController) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: 'Search coins, tokens',
        // Add a clear button to the search bar
        suffixIcon: IconButton(
          icon: const Icon(Iconsax.close_circle),
          onPressed: () => searchController.clear(),
        ),
        // Add a search icon or button to the search bar
        prefixIcon: IconButton(
          icon: const Icon(Iconsax.search_normal_1),
          onPressed: () {
            // Perform the search here
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  Widget _getItem({required BuildContext ctx, required MarketUCImpl coinMarketCap, required int index, required List<SmartContractModel> assetsModel}) {

    return SizedBox(
      child: ValueListenableBuilder(
        valueListenable: coinMarketCap.lstMarket,
        builder: (context, value, wg) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            leading: SizedBox(
              height: 30, 
              width: 30, 
              child: assetsModel[assetsModel.indexOf(assetsModel[index])].logo != null ? CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.network(
                  assetsModel[assetsModel.indexOf(assetsModel[index])].logo!,
                  fit: BoxFit.contain,
                  height: 50,
                  width: 50,
                ) 
              )
              : CircleAvatar(
                backgroundColor: hexaCodeToColor(AppColors.cardColor),
                child: assetsModel[assetsModel.indexOf(assetsModel[index])].isBep20 == true ? const MyTextConstant(text: "BEP20", fontSize: 9,)
                : const MyTextConstant(text: "ERC20", fontSize: 9, ),
              ),
            ),
            title: Row(
              children: [
                MyTextConstant(
                  text: assetsModel[assetsModel.indexOf(assetsModel[index])].name!,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),

                assetsModel[assetsModel.indexOf(assetsModel[index])].isBep20 == true ? 
                Card(
                  color: hexaCodeToColor(AppColors.cardColor),
                  child: const Padding(
                    padding: EdgeInsets.all(3.0),
                    child: MyTextConstant(
                      text: "BNB Smart Chain",
                      textAlign: TextAlign.start,
                      fontSize: 12,
                    ),
                  ),
                ) : Container(),

                assetsModel[assetsModel.indexOf(assetsModel[index])].isErc20 == true ? 
                Card(
                  color: hexaCodeToColor(AppColors.cardColor),
                  child: const Padding(
                    padding: EdgeInsets.all(3.0),
                    child: MyTextConstant(
                      text: "Ethereum",
                      textAlign: TextAlign.start,
                      fontSize: 12,
                    ),
                  ),
                ) : Container()

              ],
            ),
            subtitle: MyTextConstant(
              text: assetsModel[assetsModel.indexOf(assetsModel[index])].symbol!,
              color2: hexaCodeToColor(AppColors.grey),
              fontSize: 12,
              textAlign: TextAlign.start,
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                MyTextConstant(
                  text: assetsModel[index].balance == null ? '0' : double.parse(assetsModel[index].balance!.replaceAll(",", "")).toStringAsFixed(4), //assetsModel[assetsModel.indexOf(assetsModel[index])].balance!,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),

                MyTextConstant(
                  text: assetsModel[index].money != null ? "\$${assetsModel[index].money!.toStringAsFixed(4)}" : "0.0",
                  color2: hexaCodeToColor(AppColors.grey),
                  fontSize: 12,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                ctx,
                MaterialPageRoute(builder: (context) => WalletInfo(index: index, market: value,))
              );
            },
          );
        }
      ),
    );
  }

}
