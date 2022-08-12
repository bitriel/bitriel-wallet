import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/service/contract.dart';

class ReceiveWallet extends StatefulWidget {
  //static const route = '/recievewallet';
  final int? assetIndex;
  final SmartContractModel? scModel;

  ReceiveWallet({
    Key? key,
    this.assetIndex,
    @required this.scModel
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReceiveWalletState();
  }
}

class ReceiveWalletState extends State<ReceiveWallet> {

  ReceiveWalletProvider? provider;

  /// For SEL Navtive
  String? symbol;

  String? ethAddr;

  @override
  void initState() {

    provider = Provider.of<ReceiveWalletProvider>(context, listen: false);
    provider!.globalKey = GlobalKey<ScaffoldState>();

    provider!.lsContractSymbol = ContractService.getConSymbol(context, Provider.of<ContractProvider>(context, listen: false).sortListContract);

    ethAddr = Provider.of<ContractProvider>(context, listen: false).getEtherAddress;
    symbol = ApiProvider().isMainnet ? 'SEL (Selendra Chain)': 'SEL (Testnet)';

    provider!.getAccount(Provider.of<ApiProvider>(context, listen: false).getAccount);

    if (widget.assetIndex == null) findAsset();
    else {
      provider!.assetsIndex = Provider.of<ContractProvider>(context, listen: false).sortListContract.indexOf(widget.scModel!);
      // _scanPayM.assetValue = ;
    }
    provider!.accountM!.address = Provider.of<ContractProvider>(context, listen: false).sortListContract[provider!.assetsIndex].address;

    // print("after ${widget.assetIndex!}");

    // print("Provider.of<ContractProvider>(context, listen: false).sortListContract[widget.assetIndex!].address ${Provider.of<ContractProvider>(context, listen: false).sortListContract[widget.assetIndex!].address}");
    
    // if (widget.assetIndex != null){
    //   provider!.initialValue = widget.assetIndex!;
    //   provider!.accountM!.address = Provider.of<ContractProvider>(context, listen: false).getEtherAddress;

    //   print("Address ${provider!.accountM!.address}");
    //   // symbol = Provider.of<ContractProvider>(context, listen: false).sortListContract[widget.assetIndex!].symbol;//ApiProvider().isMainnet ? 'SEL (Selendra Chain)': 'SEL (Testnet)';
    //   // if (Provider.of<ContractProvider>(context, listen: false).sortListContract[widget.assetIndex!].org == "BEP-20") {
    //   //   provider!.getAccount(Provider.of<ApiProvider>(context, listen: false).getAccount);
    //   // }// = Provider.of<ApiProvider>(context, listen: false).getAccount.address!;
    //   // findAsset();

    // } else {
    //   print("symbol $symbol");
    //   // provider!.getAccount(Provider.of<ApiProvider>(context, listen: false).accountM);
    //   findAsset();
    // }

    AppServices.noInternetConnection(context: context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // name = Provider.of<ApiProvider>(context, listen: false).accountM.name!;
    // wallet = Provider.of<ApiProvider>(context, listen: false).accountM.address!;
    super.didChangeDependencies();
  }

  void findAsset(){
    for(int i = 0; i< provider!.lsContractSymbol!.length; i++){
      if (provider!.lsContractSymbol![i]['symbol'] == symbol){
        provider!.assetsIndex = i;
        break;
      }
    }

  }

  void onChanged(String value) {
    setState(() {
      provider!.assetsIndex = int.parse(value);
    });

    changedEthAdd(value);
  }

  void changedEthAdd(String value) {
    if (provider!.lsContractSymbol![int.parse(value)]['symbol'] == 'BTC') {
      provider!.accountM!.address = Provider.of<ContractProvider>(context, listen: false).listContract[ApiProvider().btcIndex].address;
    } else if (provider!.lsContractSymbol![int.parse(value)]['symbol'] == symbol || provider!.lsContractSymbol![int.parse(value)]['symbol'] == 'DOT'){
      provider!.accountM!.address = Provider.of<ApiProvider>(context, listen: false).getAccount.address!;
    } else {
      provider!.accountM!.address = ethAddr;
    }
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    
    return ReceiveWalletBody(
      // assetIndex: widget.assetIndex,
      onChanged: onChanged,
    );
  }
}
