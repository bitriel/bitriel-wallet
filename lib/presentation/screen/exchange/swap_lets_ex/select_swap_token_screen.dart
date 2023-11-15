import 'package:bitriel_wallet/domain/usecases/swap_uc/exchange.i.dart';
import 'package:bitriel_wallet/index.dart';

class SelectSwapToken extends StatelessWidget {

  final List<ExchangeCoinI> coin;
  final ExchangeCoinI? coin1;
  final ExchangeCoinI? coin2;

  const SelectSwapToken({
    super.key, required this.coin,
    required this.coin1,
    required this.coin2,
  });

  @override
  Widget build(BuildContext context) {

    // final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: appBar(context, title: "Select Token"),
      body: Column(
        children: [
      
          // _searchBar(searchController, coin),

          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: coin.length,
                  itemBuilder: (context, index) {

                    return _listTokenItem(
                      context, 
                      index,
                      coin1,
                      coin2
                    );
                    
                  },
                ),


              ],
            ),
          ),
      
          // ValueListenableBuilder(
          //   valueListenable: leRepoImpl.lstLECoin,
          //   builder: (context, value, wg) {
          //     return Expanded(
          //       child: ListView.builder(
          //         itemCount: value.length,
          //         itemBuilder: (context, index) {
          //           return _listTokenItem(index);
          //         },
          //       ),
          //     );
          //   }
          // ),
        ],
      ),
    );
  }

  Widget _searchBar(TextEditingController searchController, List<LetsExCoinByNetworkModel> coin) {
    return Padding(
      padding: const EdgeInsets.only(top: 15 / 2, left: 15, right: 15, bottom: 15 / 2),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: 'Search among ${coin.length} tokens by name',
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
      ),
    );
  }

  Widget _buildImageItem(int index) {
    // if (coin[index].icon == null) {
      return const CircleAvatar();
    // }
    // else if (coin[index].icon!.endsWith('.svg')) {
    //   // Handle SVG images using flutter_svg
    //   return SvgPicture.network(
    //     coin[index].icon!.replaceAll("\\/", "/"),
    //     placeholderBuilder: (context) => const CircularProgressIndicator(),
    //     height: 100,
    //     width: 100,
    //   );
    // } 
    // else {
    //   // Handle PNG and JPEG images using cached_network_image
    //   return CachedNetworkImage(
    //     imageUrl: coin[index].icon!.replaceAll("\\/", "/"),
    //     placeholder: (context, url) => const CircularProgressIndicator(),
    //     errorWidget: (context, url, error) => const CircleAvatar(),
    //   );
    // }
  }

  Widget _listTokenItem(BuildContext context, int index, ExchangeCoinI? coin1, ExchangeCoinI? coin2) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      leading: SizedBox(
        height: 40, 
        width: 40, 
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50), 
          child: coin[index].icon!.contains('.svg') ? SvgPicture.network(coin[index].icon!) : Image.network(coin[index].icon!)
        ) //_buildImageItem(index),
      ),
      title: Row(
        children: [

          MyTextConstant(
            text: coin[index].coinName ?? '',
            fontWeight: FontWeight.w600,
            fontSize: 17,
            textAlign: TextAlign.start,
          ),

          const SizedBox(width: 10),

          coin[index].shortName != null ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: coin[index].shortName == "BEP20" ? Colors.cyanAccent : const Color.fromARGB(255, 96, 237, 169),
              borderRadius: BorderRadius.circular(10)
            ),
            child: MyTextConstant(
              text: coin[index].shortName ?? '',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              textAlign: TextAlign.start,
            ),
          ) : const SizedBox(),

        ],
      ),
      subtitle: MyTextConstant(
        text: coin[index].networkName,
        color2: hexaCodeToColor(AppColors.grey),
        fontSize: 13,
        textAlign: TextAlign.start,
      ),
      onTap: 
      // coin1 != null || coin2 != null ? null : 
      () {
        Navigator.pop(context, index);
      },
    );
  }
}