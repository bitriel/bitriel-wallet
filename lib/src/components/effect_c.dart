import 'package:wallet_apps/index.dart';

class MyShimmer extends StatelessWidget{

  final bool? isDarkMode;

  const MyShimmer({Key? key, this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Shimmer.fromColors(
      period: const Duration(seconds: 2),
      baseColor: isDarkMode!
          ? hexaCodeToColor(AppColors.darkCard)
          : Colors.grey[300]!,
      highlightColor: isDarkMode!
          ? hexaCodeToColor(AppColors.darkBgd)
          : Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        itemCount: 6,
      )
    );
  }
}