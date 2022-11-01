import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/src/api/api_chart.dart';

import '../../../../index.dart';
import '../../../components/chart/chart_m.dart';

class AssetDetail extends StatefulWidget {
  // final Market marketData;
  final SmartContractModel scModel;
  const AssetDetail(
    // this.marketData, 
    this.scModel, {Key? key}
  ) : super(key: key);

  @override
  AssetDetailState createState() => AssetDetailState();
}

class AssetDetailState extends State<AssetDetail> {

  String convert(String? supply) {
    var formatter = NumberFormat.decimalPattern();

    if (supply != null) {
      if (supply.contains('.')) {
        var value = supply.replaceFirst(RegExp(r"\.[^]*"), "");
        return formatter.format(int.parse(value));
      }
    }

    return formatter.format(int.parse(supply!));
  }

  String periodID = '1DAY';
  void queryAssetChart() async {
    await ApiCalls().getChart(
      widget.scModel.symbol!, 
      'usd', periodID, 
      DateTime.now().subtract(const Duration(days: 6)), 
      DateTime.now()
    ).then((value) {

      widget.scModel.chart = value;

      setState(() {
        
      });
    });
  }

  @override
  void initState() {
    queryAssetChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            if (widget.scModel.chart == null)
            const CircularProgressIndicator()
            
            else if (widget.scModel.chart!.isNotEmpty) 
            chartAsset(
              true,
              ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: widget.scModel.logo!.contains('http') 
                ? Image.network(
                  widget.scModel.logo!,
                  fit: BoxFit.contain,
                )
                : Image.asset(
                  widget.scModel.logo!,
                  fit: BoxFit.contain,
                )
              ),
              widget.scModel.name!,
              widget.scModel.symbol!,
              'USD',
              widget.scModel.marketPrice!,
              widget.scModel.chart!,
            ),
            // else Container(),

            SizedBox(height: 2.h),
            
            widget.scModel.marketData == null 
            ? assetFromJson()
            : assetFromApi(),

          ],
        )
      ),
    );
  }

  Widget line() {
    return Container(
      height: 1,
      color: isDarkMode
        ? hexaCodeToColor(AppColors.titleAssetColor)
        : hexaCodeToColor(AppColors.textColor),
    );
  }

  Widget textRow(String leadingText, String trailingText, String endingText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: leadingText,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              MyText(
                text: trailingText,
                hexaColor: isDarkMode
                  ? AppColors.whiteColorHexa
                  : AppColors.textColor,
                overflow: TextOverflow.ellipsis,
              ),
              MyText(
                text: endingText,
                hexaColor: endingText != '' && endingText.substring(1, 2) == '-'
                  ? '#FF0000'
                  : isDarkMode
                      ? '#00FF00'
                      : '#66CD00',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget assetFromJson() {
    return widget.scModel.description != null ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyText(
          text: 'Token Info',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 16.0),

        textRow('Token Name', widget.scModel.symbol!.toUpperCase(), ''),

        textRow('Project Name', '${widget.scModel.name}', ''),

        textRow('Token Standard', '${widget.scModel.org}', ''),

        textRow('Max Supply', '${widget.scModel.maxSupply}', ''),

        line(),

        const SizedBox(height: 10.0),

        MyText(
          text: 'About ${widget.scModel.name}',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 16.0),

        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.description}',
        ),
      ],
    )
    :
    SizedBox(
      height: 60.sp,
      child: OverflowBox(
        minHeight: 60.h,
        maxHeight: 60.h,
        child: Lottie.asset("${AppConfig.animationPath}no-data.json", width: 60.w, height: 60.w, repeat: false),
      )
    );
  }


  Widget assetFromApi() {
    return widget.scModel.marketData!.description != null ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyText(
          text: 'Token Info',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 16.0),

        textRow('Token Name', (widget.scModel.marketData!.symbol)!.toUpperCase(), ''),

        textRow('Project Name', '${widget.scModel.marketData!.name}', ''),

        textRow('Max Supply', '${widget.scModel.marketData!.maxSupply}', ''),

        line(),

        const SizedBox(height: 10.0),

        MyText(
          text: 'About ${widget.scModel.marketData!.name}',
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.left,
        ),

        const SizedBox(height: 16.0),

        widget.scModel.marketData!.description == null ?
        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.marketData!.description}',
        )
        :
        MyText(
          textAlign: TextAlign.start,
          text: '${widget.scModel.description}',
        ),
      ],
    )
    :
    SizedBox(
      height: 60.sp,
      child: OverflowBox(
        minHeight: 60.h,
        maxHeight: 60.h,
        child: Lottie.asset("${AppConfig.animationPath}no-data.json", width: 60.w, height: 60.w, repeat: false),
      )
    );
  }
}
