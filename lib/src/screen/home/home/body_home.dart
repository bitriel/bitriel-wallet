import 'package:carousel_slider/carousel_slider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/defi_menu_item_c.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';
import 'package:wallet_apps/src/models/image_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePageBody extends StatelessWidget {
  final PageController controller;
  final int activeIndex;
  

  const HomePageBody({ Key? key, required this.controller, required this.activeIndex }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.darkBgd),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(left: paddingSize),
          onPressed: () {

          },
          icon: Icon(Iconsax.profile_circle, size: 25),
        ),
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.only(right: 25),
            icon: Icon(
              Iconsax.scan,
              size: 25,
            ),
            onPressed: () {
              
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: paddingSize),
              child: _carouselAds(context, activeIndex),
            ),
      
      
            SizedBox(height: 25), 
            _menu(context),
            
      
            SizedBox(height: 25), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "DeFi",
                fontSize: 20,
                color: AppColors.whiteColorHexa,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 10),
              child: _defiMenu(context),
            ),
      
      
            SizedBox(height: 25), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "Marketplace",
                fontSize: 20,
                color: AppColors.whiteColorHexa,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 10),
              child: _marketPlaceMenu(context),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _carouselAds(BuildContext context, activeIndex) {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 21 / 9,
              autoPlay: true,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, image){
                activeIndex = index;
              }
            ),
            items: imgList
              .map((item) => Container(
                    child: Center(
                      child:Image.network(item, fit: BoxFit.cover)
                    ),
                  )
                )
              .toList(),
          ),

          
          Container(
            // color: Colors.red.withOpacity(.4),
            child: SmoothPageIndicator(
              controller: controller,
              count: imgList.length,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: 32,
                  height: 12,
                  color: Colors.indigo,
                  rotationAngle: 180,
                  verticalOffset: -10,
                  borderRadius: BorderRadius.circular(24),
                  // dotBorder: DotBorder(
                  //   padding: 2,
                  //   width: 2,
                  //   color: Colors.indigo,
                  // ),
                ),
                dotDecoration: DotDecoration(
                  width: 24,
                  height: 12,
                  color: Colors.grey,
                  // dotBorder: DotBorder(
                  //   padding: 2,
                  //   width: 2,
                  //   color: Colors.grey,
                  // ),
                  // borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(2),
                  //     topRight: Radius.circular(16),
                  //     bottomLeft: Radius.circular(16),
                  //     bottomRight: Radius.circular(2)),
                  borderRadius: BorderRadius.circular(16),
                  verticalOffset: 0,
                ),
                spacing: 6.0,
                activeColorOverride: (i) => hexaCodeToColor(AppColors.sliderColor),
                inActiveColorOverride: (i) => hexaCodeToColor(AppColors.sliderColor).withOpacity(0.38),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _menu(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MenuItem(
                  title: "Swap",
                  icon: Icon(Iconsax.card_coin, color: Colors.white, size: 35),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  action: () {
                  },
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: MenuItem(
                  title: "Staking",
                  icon: Icon(Iconsax.discount_shape, color: Colors.white, size: 35),
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  action: () {
                  },
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSize , vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MenuItem(
                  title: "Send",
                  icon: Transform.rotate(
                    angle: 141.371669412,
                    child: Icon(Iconsax.import, color: Colors.white, size: 35),
                  ),
                  
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () {
                  },
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: MenuItem(
                  title: "Recieve",
                  icon: Icon(Iconsax.import, color: Colors.white, size: 35),
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  action: () {
                  },
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: MenuItem(
                  title: "Pay",
                  icon: Icon(Iconsax.scan, color: Colors.white, size: 35),
                  begin: Alignment.bottomRight,
                  end: Alignment.topCenter,
                  action: () {
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _defiMenu(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DefiMenuItem(
            title: "Bitriel DEX",
            action: () {
        
            },
          ),
        ),

        SizedBox(width: 10,),

        Expanded(
          child: DefiMenuItem(
            title: "Balancer",
            action: () {
        
            },
          ),
        )
      ],
    );
  }

  Widget _marketPlaceMenu(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MarketPlaceMenuItem(
                title: "SALA Digital",
                action: () {
            
                },
              ),
            ),

            SizedBox(width: 10,),

            Expanded(
              child: MarketPlaceMenuItem(
                title: "KOOMPI Fi-Fi",
                action: () {
            
                },
              ),
            )
          ],
        ),

        SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: MarketPlaceMenuItem(
                title: "Land Tokens",
                action: () {
            
                },
              ),
            ),

            SizedBox(width: 10,),

            Expanded(
              child: MarketPlaceMenuItem(
                title: "OpenSea",
                action: () {
            
                },
              ),
            )
          ],
        )
      ],
    );
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 10 : 20;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(images[pagePosition]))),
    );
}

  imageAnimation(PageController animation, images, pagePosition) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, widget) {
        print(pagePosition);

        return SizedBox(
          width: 200,
          height: 200,
          child: widget,
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Image.network(images[pagePosition]),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }


}