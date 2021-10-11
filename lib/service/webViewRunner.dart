import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/service/keyring.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class WebViewRunner {
  FlutterWebviewPlugin _web;
  Function _onLaunched;

  Map<String, Function> _msgHandlers = {};
  Map<String, Completer> _msgCompleters = {};
  int _evalJavascriptUID = 0;

  StreamSubscription _subscription;

  Future<void> launch(
    ServiceKeyring keyring,
    Keyring keyringStorage,
    Function onLaunched, {
    String jsCode,
  }) async {
    /// reset state before webView launch or reload
    _msgHandlers = {};
    _msgCompleters = {};
    _evalJavascriptUID = 0;
    _onLaunched = onLaunched;

    final needLaunch = _web == null;

    _web = FlutterWebviewPlugin();

    // await _web.close();
    // if (keyringStorage.allAccounts.isNotEmpty){
    //   print("Keyring storage ${keyringStorage.allAccounts.isEmpty}");
      // await _web.close();
    // }

    /// cancel another plugin's listener before launch
    if (_subscription != null) {
      _subscription.cancel();
    }
    _subscription = _web.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
        final js = jsCode ??
            await rootBundle
                .loadString('packages/polkawallet_sdk/js_api/dist/main.js');

        await _startJSCode(js, keyring, keyringStorage);
      }
    });

    if (!needLaunch) {
      _web.reload();
      return;
    }

    _web.launch(
      'about:blank',
      javascriptChannels: [
        JavascriptChannel(
            name: 'PolkaWallet',
            onMessageReceived: (JavascriptMessage message) {
              // print('received msg: ${message.message}');
              compute(jsonDecode, message.message).then((msg) {
                final String path = msg['path'];
                if (_msgCompleters[path] != null) {
                  Completer handler = _msgCompleters[path];
                  handler.complete(msg['data']);
                  if (path.contains('uid=')) {
                    _msgCompleters.remove(path);
                  }
                }
                if (_msgHandlers[path] != null) {
                  Function handler = _msgHandlers[path];
                  handler(msg['data']);
                }
              });
            }),
      ].toSet(),
      ignoreSSLErrors: true,
      clearCache: true,
//        withLocalUrl: true,
//        localUrlScope: 'lib/polkadot_js_service/dist/',
      hidden: true,
    );
  }

  Future<void> _startJSCode(
    String js,
    ServiceKeyring keyring,
    Keyring keyringStorage,
  ) async {
    // inject js file to webView
    await _web.evalJavascript(js);

    _onLaunched();
  }

  int getEvalJavascriptUID() {
    return _evalJavascriptUID++;
  }

  Future<dynamic> evalJavascript(
    String code, {
    bool wrapPromise = true,
    bool allowRepeat = true,
  }) async {
    // check if there's a same request loading
    if (!allowRepeat) {
      for (String i in _msgCompleters.keys) {
        String call = code.split('(')[0];
        if (i.contains(call)) {
          // print('request $call loading');
          return _msgCompleters[i].future;
        }
      }
    }

    if (!wrapPromise) {
      String res = await _web.evalJavascript(code);
      return res;
    }

    Completer c = new Completer();

    String method = 'uid=${getEvalJavascriptUID()};${code.split('(')[0]}';
    _msgCompleters[method] = c;

    String script = '$code.then(function(res) {'
        '  PolkaWallet.postMessage(JSON.stringify({ path: "$method", data: res }));'
        '}).catch(function(err) {'
        '  PolkaWallet.postMessage(JSON.stringify({ path: "log", data: err.message }));'
        '})';
    _web.evalJavascript(script);

    return c.future;
  }

  Future<NetworkParams> connectNode(List<NetworkParams> nodes) async {
    final String res = await evalJavascript(
        'settings.connect(${jsonEncode(nodes.map((e) => e.endpoint).toList())})');
    if (res != null) {
      final node = nodes.firstWhere((e) => e.endpoint == res);
      return node;
    }
    return null;
  }

  Future<NetworkParams> connectNon(List<NetworkParams> nodes) async {
    final String res = await evalJavascript(
        'settings.connectNon(${jsonEncode(nodes.map((e) => e.endpoint).toList())})');
    if (res != null) {
      final node = nodes.firstWhere((e) => e.endpoint == res);
      return node;
    }
    return null;
  }

  Future<void> connectBsc() async {
    final res = await evalJavascript('settings.connectBsc()');

    return res;
  }

  Future<String> getPrivateKey(String mnemonic) async {
    final res = await evalJavascript('wallets.getPrivateKey("$mnemonic")');
    return res;
  }

  Future<bool> validateEtherAddr(String address) async {
    final res = await evalJavascript('wallets.validateEtherAddr("$address")');
    return res;
  }

  Future<String> swapToken(String privateKey, String amount) async {
    final res =
        await evalJavascript('wallets.swapToken("$privateKey","$amount")');
    return res;
  }

  Future<List> getChainDecimal() async {
    final res = await evalJavascript('settings.getChainDecimal(api)');
    return res;
  }

  Future<List> getNChainDecimal() async {
    final res = await evalJavascript('settings.getChainDecimal(apiNon)');
    return res;
  }

  Future<String> callContract() async {
    final res = await evalJavascript('settings.callContract(api)');
    return res;
  }

  Future<String> initAttendant() async {
    final res = await evalJavascript('settings.initAttendant(api)');
    return res;
  }

  Future<String> getAToken(String attendent) async {
    final res =
        await evalJavascript('settings.getAToken(aContract,"$attendent")');
    return res.toString();
  }

  Future<bool> getAStatus(String attendent) async {
    final res =
        await evalJavascript('settings.getAStatus(aContract,"$attendent")');
    return res;
  }

  Future<List> getCheckInList(String attendent) async {
    final res =
        await evalJavascript('settings.getCheckInList(aContract,"$attendent")');
    return res;
  }

  Future<List> getCheckOutList(String attendent) async {
    final res = await evalJavascript(
        'settings.getCheckOutList(aContract,"$attendent")');
    return res;
  }

  Future<List> contractSymbol(String from) async {
    final res =
        await evalJavascript('settings.contractSymbol(apiContract,"$from")');

    return res;
  }

  Future<dynamic> totalSupply(String from) async {
    final res =
        await evalJavascript('settings.totalSupply(apiContract,"$from")');

    return res;
  }

  Future<dynamic> balanceOf(String who, String from) async {
    final res =
        await evalJavascript('settings.balanceOf(apiContract,"$from","$who")');

    return res;
  }

  Future<dynamic> balanceOfByPartition(
      String from, String who, String hash) async {
    final res = await evalJavascript(
        'settings.balanceOfByPartition(apiContract,"$from","$who","$hash")');
    return res;
  }

  Future<dynamic> getPartitionHash(String from) async {
    final res =
        await evalJavascript('settings.getPartitionHash(apiContract,"$from")');
    return res;
  }

  Future<String> getHashBySymbol(String from, String symbol) async {
    final res = await evalJavascript(
        'settings.getHashBySymbol(apiContract,"$from","$symbol")');
    return res;
  }

  Future<dynamic> allowance(String owner, String spender) async {
    final res = await evalJavascript(
        'settings.allowance(apiContract,"$owner","$spender")');

    return res;
  }

  Future<void> subscribeMessage(
    String code,
    String channel,
    Function callback,
  ) async {
    addMsgHandler(channel, callback);
    evalJavascript(code);
  }

  void unsubscribeMessage(String channel) {
    final unsubCall = 'unsub$channel';
    _web.evalJavascript('$unsubCall && $unsubCall()');
  }

  void addMsgHandler(String channel, Function onMessage) {
    _msgHandlers[channel] = onMessage;
  }

  void removeMsgHandler(String channel) {
    _msgHandlers.remove(channel);
  }
}
