// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wallet_apps/index.dart';

class TransactionActivityDetails extends StatefulWidget {
  final Map<String, dynamic> _trxInfo;

  const TransactionActivityDetails(this._trxInfo, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyActivityDetailsState();
  }
}

class MyActivityDetailsState extends State<TransactionActivityDetails> {

  // final RefreshController _refreshController = RefreshController();
  
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  bool isProgress = true;
  bool isLogout = false;

  @override
  void initState() {
    AppServices.noInternetConnection(context: context);
    super.initState();
  }

  /* Scroll Refresh */
  void reFresh() {
    setState(() {
      isProgress = true;
    });
    // _refreshController.refreshCompleted();
  }

  void popScreen() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: transactionActivityDetailsBody(context, widget._trxInfo, popScreen),
    );
  }
}
