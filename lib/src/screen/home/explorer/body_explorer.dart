import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/indecator_c.dart';
import 'package:wallet_apps/src/screen/home/explorer/multi_explorer/multi_explorer.dart';
import 'package:wallet_apps/src/screen/home/explorer/selendra_explorer/selendra_explorer.dart';

class DiscoverPageBody extends StatelessWidget {

  final HomePageModel? homePageModel;
  final TabController tabController;
  const DiscoverPageBody({
    Key? key,
    required this.tabController,
    this.homePageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [

            TabBar(
              labelColor: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.textColor),
              unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
              tabs: const [

                Tab(
                  child: MyText(
                    text: "Selendra Explorer",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Tab(
                  child: MyText(
                    text: "Other Explorer",
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0.5,
              indicator: CustomTabIndicator(
                color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor),
              )
            ),

            const SizedBox(height: paddingSize,),

            Expanded(
              child: TabBarView(
                controller: tabController,
                // children: const [
                //   SelendraExplorer(),
                //   MultiExplorer(),
                // ],
                children: [
                  
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.direction > 0) {
                        tabController.animateTo(1);
                      }
                      else{
                        homePageModel!.globalKey!.currentState!.openDrawer();
                      }
                    },
                    child: const SelendraExplorer()
                  ),
                  
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.direction > 0) {
                        homePageModel!.pageController!.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      }
                      else{
                        tabController.animateTo(0);
                      }
                    },
                    child: const MultiExplorer(),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

}