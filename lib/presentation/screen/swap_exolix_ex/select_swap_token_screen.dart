import 'package:bitriel_wallet/domain/model/exolix_ex_coin_m.dart';
import 'package:bitriel_wallet/index.dart';

class SelectSwapToken extends StatelessWidget {

  final List<ExolixExCoinByNetworkModel> itemLE;

  const SelectSwapToken({super.key, required this.itemLE});

  @override
  Widget build(BuildContext context) {

    // final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: appBar(context, title: "Select Token"),
      body: Column(
        children: [

          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: itemLE.length,
                  itemBuilder: (context, index) {

                    return _listTokenItem(context, index);
                    
                  },
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(TextEditingController searchController, List<ExolixExCoinByNetworkModel> itemLE) {
    return Padding(
      padding: const EdgeInsets.only(top: 15 / 2, left: 15, right: 15, bottom: 15 / 2),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: 'Search among ${itemLE.length} tokens by name',
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
      return const CircleAvatar();
  }

  Widget _listTokenItem(BuildContext context, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      leading: SizedBox(
        height: 40, 
        width: 40, 
        child: _buildImageItem(index),
      ),
      title: MyTextConstant(
        text: itemLE[index].title ?? '',
        fontWeight: FontWeight.w600,
        fontSize: 17,
        textAlign: TextAlign.start,
      ),
      subtitle: MyTextConstant(
        text: itemLE[index].network,
        color2: hexaCodeToColor(AppColors.grey),
        fontSize: 13,
        textAlign: TextAlign.start,
      ),
      onTap: () {
        Navigator.pop(context, index);
      },
    );
  }
}