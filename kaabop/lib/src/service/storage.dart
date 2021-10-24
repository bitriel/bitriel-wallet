import 'package:wallet_apps/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';

// ignore: avoid_classes_with_only_static_members
class StorageServices {
  static String _decode;
  static SharedPreferences _preferences;

  final _storage = const FlutterSecureStorage();

  Future<String> readSecure(String key) async {
    final res = await _storage.read(key: key);
    return res;
  }

  Future<void> writeSecure(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> clearKeySecure(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearSecure() async {
    await _storage.deleteAll();
  }

  static Future<SharedPreferences> storeData(dynamic _data, String _path) async {
    _preferences = await SharedPreferences.getInstance();
    _decode = jsonEncode(_data);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<SharedPreferences> addMoreData(Map<String, dynamic> _data, String _path) async {
    List<Map<String, dynamic>> ls = [];
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey(_path)) {
      final _dataString = _preferences.getString(_path);

      ls = List<Map<String, dynamic>>.from(jsonDecode(_dataString) as List);
      ls.add(_data);
    } else {
      ls.add(_data);
    }

    _decode = jsonEncode(ls);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<void> storeAssetData(context) async {

    final listContract = Provider.of<ContractProvider>(context, listen: false).listContract;
    
    // print("storeAssetData");
    // listContract.forEach((element) {
    //   print("${element.name} ${element.change24h}");
    //   print("${element.name} ${element.marketPrice}");
    // });

    final res = SmartContractModel.encode(listContract);

    await _preferences.setString(DbKey.assetData, res);
  }

  static Future<SharedPreferences> addTxHistory(TxHistory txHistory, String key) async {
    final List<TxHistory> txHistoryList = [];
    _preferences = await SharedPreferences.getInstance();

    await StorageServices.fetchData('txhistory').then((value) {
      //print('My value $value');
      if (value != null) {
        for (final i in value) {
          txHistoryList.add(TxHistory(
            date: i['date'].toString(),
            symbol: i['symbol'].toString(),
            destination: i['destination'].toString(),
            sender: i['sender'].toString(),
            amount: i['amount'].toString(),
            org: i['fee'].toString(),
          ));
        }
        txHistoryList.add(txHistory);
      } else {
        txHistoryList.add(txHistory);
      }
    });

    await _preferences.setString(key, jsonEncode(txHistoryList));

    return _preferences;
  }

  static Future<void> saveEthContractAddr(String contractAddr) async {
    final List<String> contractAddrList = [];
    final res = await fetchData(DbKey.ethContractList);

    if (res != null) {
      contractAddrList.clear();
      for (final i in res) {
        contractAddrList.add(i.toString());
      }
      contractAddrList.add(contractAddr);
      await storeData(contractAddrList, DbKey.ethContractList);
    } else {
      contractAddrList.add(contractAddr);

      await storeData(contractAddrList, DbKey.ethContractList);
    }
  }

  static Future<void> removeEthContractAddr(String contractAddr) async {
    List contractAddrList = [];
    final res = await fetchData(DbKey.ethContractList);

    if (res != null) {
      contractAddrList = res as List;

      contractAddrList.removeWhere((element) => element == contractAddr);

      if (contractAddrList.isNotEmpty) {
        await StorageServices.storeData(contractAddrList, DbKey.ethContractList);
      } else {
        await removeKey(DbKey.ethContractList);
      }
    }
  }

  static Future<void> saveContractAddr(String contractAddr) async {
    final List<String> contractAddrList = [];
    final res = await fetchData('contractList');

    if (res != null) {
      contractAddrList.clear();
      for (final i in res) {
        contractAddrList.add(i.toString());
      }
      contractAddrList.add(contractAddr);
      await storeData(contractAddrList, 'contractList');
    } else {
      contractAddrList.add(contractAddr);

      await storeData(contractAddrList, 'contractList');
    }
  }

  static Future<void> removeContractAddr(String contractAddr) async {
    List contractAddrList = [];
    final res = await fetchData('contractList');

    if (res != null) {
      contractAddrList = res as List;

      contractAddrList.removeWhere((element) => element == contractAddr);

      if (contractAddrList.isNotEmpty) {
        await StorageServices.storeData(contractAddrList, 'contractList');
      } else {
        await removeKey('contractList');
      }
    }
  }

  // ignore: avoid_positional_boolean_parameters
  static Future<void> saveBool(String key, bool value) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setBool(key, value);
  }

  static Future<bool> readBool(String key) async {
    _preferences = await SharedPreferences.getInstance();
    final res = _preferences.getBool(key);

    return res ?? false;
  }

  // ignore: avoid_positional_boolean_parameters
  static Future<void> saveBio(bool enable) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setBool('bio', enable);
  }

  static Future<bool> readSaveBio() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool('bio') ?? false;
  }

  static Future<SharedPreferences> setUserID(String _data, String _path) async {
    _preferences = await SharedPreferences.getInstance();
    _decode = jsonEncode(_data);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<dynamic> fetchAsset(String _path) async {
    try {

      _preferences = await SharedPreferences.getInstance();

      _decode = _preferences.getString(_path);

      if (_decode != null){

        final res = SmartContractModel.decode(_decode);

        return res;
      }

    } catch (e) {
      print("Error fetchAsset $e");
    }
    //return _preferences.getString(_path);
  }

  static Future<dynamic> fetchData(String _path) async {
    _preferences = await SharedPreferences.getInstance();

    final _data = _preferences.getString(_path);

    if (_data == null) {
      return null;
    } else {
      return json.decode(_data);
    }
  }

  static Future<void> removeKey(String path) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.remove(path);
  }
}
