import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:provider/provider.dart';

import '../../../index.dart';

class AssetList extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final passphraseController = TextEditingController();
  final pinController = TextEditingController();
  final focus = FocusNode();
  final pinFocus = FocusNode();

  Future<bool> validateMnemonic(String mnemonic) async {
    final res = await ApiProvider.sdk.api.keyring.validateMnemonic(mnemonic);
    return res;
  }

  String validate(String value) {
    return null;
  }

  Future<bool> checkPassword(String pin) async {
    final res = await ApiProvider.sdk.api.keyring
        .checkPassword(ApiProvider.keyring.current, pin);
    return res;
  }

  Future<void> onSubmit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      dialogLoading(context);
      final isValidSeed = await validateMnemonic(passphraseController.text);
      final isValidPw = await checkPassword(pinController.text);

      if (isValidSeed == false) {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Opps'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('Invalid Seed phrase'),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
      // await dialog(
      if (isValidPw == false) {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Opps'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('PIN verification failed'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }

      if (isValidSeed && isValidPw) {
        final seed = bip39.mnemonicToSeed(passphraseController.text);
        final hdWallet = HDWallet.fromSeed(seed);
        final keyPair = ECPair.fromWIF(hdWallet.wif);
        final bech32Address = new P2WPKH(
                data: new PaymentData(pubkey: keyPair.publicKey),
                network: bitcoin)
            .data
            .address;

        await StorageServices.setData(bech32Address, 'bech32');
        final res = await ApiProvider.keyring.store
            .encryptPrivateKey(hdWallet.wif, pinController.text);

        if (res != null) {
          await StorageServices().writeSecure('btcwif', res);
        }

        Provider.of<ApiProvider>(context, listen: false)
            .getBtcBalance(hdWallet.address);
        Provider.of<ApiProvider>(context, listen: false)
            .isBtcAvailable('contain');

        Provider.of<ApiProvider>(context, listen: false)
            .setBtcAddr(bech32Address);
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('BTC');
        Navigator.pop(context);
        Navigator.pop(context);

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Success'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('You have created bitcoin wallet.'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SEL Verion 1
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.selBsc.id,
                      assetLogo: value.selBsc.logo,
                      balance: value.selBsc.balance ?? AppString.loadingPattern,
                      tokenSymbol: value.selBsc.symbol ?? '',
                      org: value.selBsc.org,
                      marketPrice: value.selBsc.marketPrice,
                      priceChange24h: value.selBsc.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.selBsc.logo,
                value.selBsc.symbol ?? '',
                'BEP-20',
                value.selBsc.balance ?? AppString.loadingPattern,
                Colors.transparent,
                marketPrice: value.selBsc.marketPrice,
                priceChange24h: value.selBsc.change24h,
              ),
            );
          },
        ),

        // SEL Verion 2
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.selBscV2.id,
                      assetLogo: value.selBscV2.logo,
                      balance:
                          value.selBscV2.balance ?? AppString.loadingPattern,
                      tokenSymbol: value.selBscV2.symbol ?? '',
                      org: value.selBscV2.org,
                      marketPrice: value.selBscV2.marketPrice,
                      priceChange24h: value.selBscV2.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.selBscV2.logo,
                value.selBscV2.symbol ?? '',
                'BEP-20',
                value.selBscV2.balance ?? AppString.loadingPattern,
                Colors.transparent,
                marketPrice: value.selBscV2.marketPrice,
                priceChange24h: value.selBscV2.change24h,
              ),
            );
          },
        ),

        // KGO Token
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.kgoBsc.id,
                      assetLogo: value.kgoBsc.logo,
                      balance: value.kgoBsc.balance ?? AppString.loadingPattern,
                      tokenSymbol: value.kgoBsc.symbol ?? '',
                      org: value.kgoBsc.org,
                      marketData: value.kgoBsc.marketData,
                      marketPrice: value.kgoBsc.marketPrice,
                      priceChange24h: value.kgoBsc.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.kgoBsc.logo,
                value.kgoBsc.symbol ?? '',
                'BEP-20',
                value.kgoBsc.balance ?? AppString.loadingPattern,
                Colors.transparent,
                marketPrice: value.kgoBsc.marketPrice,
                priceChange24h: value.kgoBsc.change24h,
                lineChartData: value.kgoBsc.lineChartData,
              ),
            );
          },
        ),

        // Koompi Token
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return value.kmpi.isContain
                ? Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: DismissibleBackground(),
                    onDismissed: (direct) {
                      value.removeToken(value.kmpi.symbol, context);
                      // setPortfolio();
                    },
                    child: Consumer<ContractProvider>(
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<ContractProvider>(context,
                                    listen: false)
                                .fetchKmpiBalance();
                            Navigator.push(
                              context,
                              RouteAnimation(
                                enterPage: AssetInfo(
                                  id: value.kmpi.id,
                                  assetLogo: value.kmpi.logo,
                                  balance: value.kmpi.balance ??
                                      AppString.loadingPattern,
                                  tokenSymbol: value.kmpi.symbol,
                                  org: value.kmpi.org,
                                ),
                              ),
                            );
                          },
                          child: AssetItem(
                            value.kmpi.logo,
                            value.kmpi.symbol,
                            value.kmpi.org,
                            value.kmpi.balance,
                            Colors.black,
                          ),
                        );
                      },
                    ),
                  )
                : Container();
          },
        ),

        // Koompi ATD Token
        Consumer<ContractProvider>(
          builder: (coontext, value, child) {
            return value.atd.isContain
                ? Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: DismissibleBackground(),
                    onDismissed: (direct) {
                      value.removeToken(value.atd.symbol, context);
                      //setPortfolio();
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteAnimation(
                            enterPage: AssetInfo(
                              id: value.atd.id,
                              assetLogo: value.atd.logo,
                              balance:
                                  value.atd.balance ?? AppString.loadingPattern,
                              tokenSymbol: value.atd.symbol,
                              org: value.atd.org,
                            ),
                          ),
                        );
                      },
                      child: AssetItem(
                        value.atd.logo,
                        value.atd.symbol,
                        value.atd.org,
                        value.atd.balance,
                        Colors.black,
                      ),
                    ),
                  )
                : Container();
          },
        ),

        // BNB Token
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.bnbSmartChain.id,
                      assetLogo: value.bnbSmartChain.logo,
                      balance: value.bnbSmartChain.balance ??
                          AppString.loadingPattern,
                      tokenSymbol: value.bnbSmartChain.symbol ?? '',
                      marketData: value.bnbSmartChain.marketData,
                      marketPrice: value.bnbSmartChain.marketPrice,
                      priceChange24h: value.bnbSmartChain.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.bnbSmartChain.logo,
                value.bnbSmartChain.symbol ?? '',
                'Smart Chain',
                value.bnbSmartChain.balance ?? AppString.loadingPattern,
                Colors.transparent,
                marketPrice: value.bnbSmartChain.marketPrice,
                priceChange24h: value.bnbSmartChain.change24h,
                size: 60,
                lineChartData: value.bnbSmartChain.lineChartData,
              ),
            );
          },
        ),

        // Bitcion Token
        Consumer<ApiProvider>(
          builder: (context, value, child) {
            final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
            return GestureDetector(
              onTap: () async {
                if (!value.btc.isContain) {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(25.0),
                        height: MediaQuery.of(context).size.height / 1.2,
                        color: isDarkTheme
                            ? Color(
                                AppUtils.convertHexaColor(AppColors.darkBgd),
                              )
                            : Color(
                                AppUtils.convertHexaColor(AppColors.bgdColor),
                              ),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                MyText(
                                  top: 16.0,
                                  bottom: 16.0,
                                  fontSize: 22,
                                  text: 'Create Bitcoin Wallet',
                                  color: isDarkTheme
                                      ? AppColors.whiteColorHexa
                                      : AppColors.textColor,
                                ),
                                const SizedBox(height: 16.0),
                                MyInputField(
                                  focusNode: focus,
                                  controller: passphraseController,
                                  labelText: 'Seed phrase',
                                  validateField: (value) => value.isEmpty
                                      ? 'Please fill in passphrase'
                                      : null,
                                  onSubmit: () {},
                                ),
                                const SizedBox(height: 16.0),
                                MyInputField(
                                  focusNode: pinFocus,
                                  controller: pinController,
                                  labelText: 'Pin',
                                  obcureText: true,
                                  validateField: (value) =>
                                      value.isEmpty || value.length < 4
                                          ? 'Please fill in old 4 digits pin'
                                          : null,
                                  textInputFormatter: [
                                    LengthLimitingTextInputFormatter(4)
                                  ],
                                  onSubmit: () {},
                                ),
                                const SizedBox(height: 25),
                                MyFlatButton(
                                  textButton: "Submit",
                                  edgeMargin: const EdgeInsets.only(
                                    top: 40,
                                    left: 66,
                                    right: 66,
                                  ),
                                  hasShadow: true,
                                  action: () async {
                                    onSubmit(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  // await
                } else {
                  Navigator.push(
                    context,
                    RouteAnimation(
                      enterPage: AssetInfo(
                        id: value.btc.id,
                        assetLogo: value.btc.logo,
                        balance: value.btc.balance ?? AppString.loadingPattern,
                        tokenSymbol: value.btc.symbol,
                        org: value.btc.org ?? '',
                        marketData: value.btc.marketData,
                        marketPrice: value.btc.marketPrice,
                        priceChange24h: value.btc.change24h,
                      ),
                    ),
                  );
                }
              },
              child: AssetItem(
                value.btc.logo,
                value.btc.symbol,
                '',
                value.btc.balance ?? AppString.loadingPattern,
                Colors.transparent,
                size: 60,
                marketPrice: value.btc.marketPrice,
                priceChange24h: value.btc.change24h,
                lineChartData: value.btc.lineChartData,
              ),
            );
          },
        ),

        // Ethereum Token
        Consumer<ContractProvider>(builder: (context, value, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                RouteAnimation(
                  enterPage: AssetInfo(
                    id: value.etherNative.id,
                    assetLogo: value.etherNative.logo,
                    balance:
                        value.etherNative.balance ?? AppString.loadingPattern,
                    tokenSymbol: value.etherNative.symbol ?? '',
                    org: value.etherNative.org ?? '',
                    marketData: value.etherNative.marketData,
                    marketPrice: value.etherNative.marketPrice,
                    priceChange24h: value.etherNative.change24h,
                  ),
                ),
              );
            },
            child: AssetItem(
              value.etherNative.logo,
              value.etherNative.symbol,
              value.etherNative.org,
              value.etherNative.balance ?? AppString.loadingPattern,
              Colors.transparent,
              marketPrice: value.etherNative.marketPrice,
              priceChange24h: value.etherNative.change24h,
              lineChartData: value.etherNative.lineChartData,
            ),
          );
        }),
        Consumer<ApiProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.dot.id,
                      assetLogo: value.dot.logo,
                      balance: value.dot.balance ?? AppString.loadingPattern,
                      tokenSymbol: value.dot.symbol,
                      org: value.dot.org,
                      marketData: value.dot.marketData,
                      marketPrice: value.dot.marketPrice,
                      priceChange24h: value.dot.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.dot.logo,
                value.dot.symbol,
                '',
                value.dot.balance ?? AppString.loadingPattern,
                Colors.transparent,
                size: 60,
                marketPrice: value.dot.marketPrice,
                priceChange24h: value.dot.change24h,
                lineChartData: value.dot.lineChartData,
              ),
            );
          },
        ),

        // SEL Test Net
        Consumer<ApiProvider>(builder: (context, value, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                RouteAnimation(
                  enterPage: AssetInfo(
                    id: value.selNative.id,
                    assetLogo: value.selNative.logo,
                    balance:
                        value.selNative.balance ?? AppString.loadingPattern,
                    tokenSymbol: value.selNative.symbol,
                    org: value.selNative.org,
                  ),
                ),
              );
            },
            child: AssetItem(
              value.selNative.logo,
              value.selNative.symbol,
              value.selNative.org,
              value.selNative.balance ?? AppString.loadingPattern,
              Colors.transparent,
            ),
          );
        }),

        // ERC or Token After Added
        Consumer<ContractProvider>(builder: (context, value, child) {
          return value.token.isNotEmpty
              ? Column(
                  children: [
                    for (int index = 0; index < value.token.length; index++)
                      Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: DismissibleBackground(),
                        onDismissed: (direct) {
                          if (value.token[index].org == 'ERC-20') {
                            value.removeEtherToken(
                                value.token[index].symbol, context);
                          } else {
                            value.removeToken(
                                value.token[index].symbol, context);
                          }

                          //setPortfolio();
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              RouteAnimation(
                                enterPage: AssetInfo(
                                  assetLogo: 'assets/circle.png',
                                  balance: value.token[index].balance ??
                                      AppString.loadingPattern,
                                  tokenSymbol: value.token[index].symbol ?? '',
                                  org: value.token[index].org,
                                ),
                              ),
                            );
                          },
                          child: AssetItem(
                            'assets/circle.png',
                            value.token[index].symbol ?? '',
                            value.token[index].org ?? '',
                            value.token[index].balance ??
                                AppString.loadingPattern,
                            Colors.transparent,
                          ),
                        ),
                      )
                  ],
                )
              : Container();
        }),
      ],
    );
  }
}
