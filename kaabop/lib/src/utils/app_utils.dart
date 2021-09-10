// This file hold Calculation And Data Convertion
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';

// ignore: avoid_classes_with_only_static_members
class AppUtils {
  static final globalKey = GlobalKey<NavigatorState>();

  static Future<DeployedContract> contractfromAssets(
      String path, String contractAddr) async {
    final String contractJson = await rootBundle.loadString(path);
    return DeployedContract(
      ContractAbi.fromJson(contractJson, 'contract'),
      EthereumAddress.fromHex(contractAddr),
    );
  }

  static addrFmt(String address) {
    String mask() {
      return '${address.substring(0, 6)}...${address.substring(address.length - 6, address.length)}';
    }
  }

  static EthereumAddress getEthAddr(String address) =>
      EthereumAddress.fromHex(address);

  static int timeStampConvertor(String userDate) {
    /* Convert date to timestamp */
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dateTime = dateFormat.parse(userDate);
    return dateTime.millisecondsSinceEpoch;
  }

  static String timeStampToDateTime(String timeStamp) {
    /* Convert Time Stamp To Date time ( Format yyyy-MM-ddTHH:mm:ssZ ) */
    final parse = DateTime.parse(timeStamp)
        .toLocal(); /* Parse Time Stamp String to DateTime Format */
    return formatDate(parse, [
      yyyy,
      '/',
      mm,
      '/',
      dd,
      ' ',
      hh,
      ':',
      nn,
      ':',
      ss,
      ' ',
      am
    ]); /* Return Real Date Time */
  }

  static String timeStampToDate(String timeStamp) {
    final parse = DateTime.parse(timeStamp)
        .toLocal(); /* Parse Time Stamp String to DateTime Format */
    return formatDate(
        parse, [yyyy, '/', mm, '/', dd]); /* Return Real Date Time */
  }

  static int convertHexaColor(String colorhexcode) {
    /* Convert Hexa Color */
    String colornew = '0xFF$colorhexcode';
    colornew = colornew.replaceAll('#', '');
    final colorint = int.parse(colornew);
    return colorint;
  }

  static int versionConverter(String _version) {
    String convert = _version.replaceAll(".", '');
    convert = convert.replaceAll('+', '');
    final parse = int.parse(convert);
    return parse;
  }
}

class ContractParser {}
