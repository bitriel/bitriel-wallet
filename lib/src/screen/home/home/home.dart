import 'package:carousel_slider/carousel_options.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/home/body_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  HomePageModel _model = HomePageModel();

  @override
  void initState() {
    super.initState();

    _model.activeIndex = 2;
    _model.carouActiveIndex = 0;
    _model.globalKey = GlobalKey<ScaffoldState>();
    _model.onPageChanged = (int index, CarouselPageChangedReason reason) {
      setState(() {
        this._model.carouActiveIndex = index;
      });
    };
  }
  
  void onIndexChanged(int index){
    setState(() {
      _model.activeIndex = index;
      _model.pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomePageBody(
      homePageModel: _model,
      onIndexChanged: onIndexChanged,
    );
  }
}