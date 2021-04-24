import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'asset_info/asset_info.dart';

class HomeBody extends StatelessWidget {
  final Function balanceOf;
  final Function setPortfolio;

  const HomeBody({this.balanceOf, this.setPortfolio});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final contract = Provider.of<ContractProvider>(context, listen: false);
        await Future.delayed(const Duration(milliseconds: 300))
            .then((value) async {
          setPortfolio();
          if (contract.bnbNative.isContain) {
            contract.getBnbBalance();
          }
          if (contract.bscNative.isContain) {
            contract.getBscBalance();
          }

          // if (contract.etherNative.isContain) {
          //   contract.getEtherBalance();
          // }

          if (contract.kgoNative.isContain) {
            contract.getKgoBalance();
          }

          if (contract.token.isNotEmpty) {
            contract.fetchNonBalance();
          }
        });
      },
      child: ListView(
        children: [
          homeAppBar(context),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                PortFolioCus(),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: hexaCodeToColor(AppColors.secondary),
                        ),
                      ),
                      const MyText(
                        text: 'Assets',
                        fontSize: 27,
                        color: AppColors.whiteColorHexa,
                        left: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              RouteAnimation(
                                enterPage: AddAsset(),
                              ),
                            );
                          },
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Consumer<ContractProvider>(
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    RouteAnimation(
                      enterPage: AssetInfo(
                        assetLogo: value.bscNative.logo,
                        balance: value.bscNative.balance ?? '0',
                        tokenSymbol: value.bscNative.symbol ?? '',
                        org: value.bscNative.org,
                      ),
                    ),
                  );
                },
                child: AssetItem(
                  value.bscNative.logo,
                  value.bscNative.symbol ?? '',
                  'BEP-20',
                  value.bscNative.balance ?? '0',
                  hexaCodeToColor('#022330'),
                ),
              );
            },
          ),
          Consumer<ContractProvider>(
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    RouteAnimation(
                      enterPage: AssetInfo(
                        assetLogo: value.kgoNative.logo,
                        balance: value.kgoNative.balance ?? '0',
                        tokenSymbol: value.kgoNative.symbol ?? '',
                        org: value.kgoNative.org,
                      ),
                    ),
                  );
                },
                child: AssetItem(
                  value.kgoNative.logo,
                  value.kgoNative.symbol ?? '',
                  'BEP-20',
                  value.kgoNative.balance ?? '0',
                  hexaCodeToColor('#022330'),
                ),
              );
            },
          ),
          Consumer<ContractProvider>(
            builder: (context, value, child) {
              return value.kmpi.isContain
                  ? Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: DismissibleBackground(),
                      onDismissed: (direct) {
                        value.removeToken(value.kmpi.symbol, context);
                        setPortfolio();
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
                                    assetLogo: value.kmpi.logo,
                                    balance: value.kmpi.balance ?? '0',
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
          Consumer<ContractProvider>(
            builder: (coontext, value, child) {
              return value.atd.isContain
                  ? Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: DismissibleBackground(),
                      onDismissed: (direct) {
                        value.removeToken(value.atd.symbol, context);
                        setPortfolio();
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            RouteAnimation(
                              enterPage: AssetInfo(
                                assetLogo: value.atd.logo,
                                balance: value.atd.balance ?? '0',
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
          Consumer<ApiProvider>(
            builder: (context, value, child) {
              return value.dot.isContain
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteAnimation(
                            enterPage: AssetInfo(
                              assetLogo: value.dot.logo,
                              balance: value.dot.balance,
                              tokenSymbol: value.dot.symbol,
                              org: value.dot.org,
                            ),
                          ),
                        );
                      },
                      child: AssetItem(
                        value.dot.logo,
                        value.dot.symbol,
                        '',
                        value.dot.balance,
                        Colors.black,
                      ),
                    )
                  : Container();
            },
          ),
          Consumer<ContractProvider>(
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    RouteAnimation(
                      enterPage: AssetInfo(
                        assetLogo: value.bnbNative.logo,
                        balance: value.bnbNative.balance ?? '0',
                        tokenSymbol: value.bnbNative.symbol ?? '',
                      ),
                    ),
                  );
                },
                child: AssetItem(
                  value.bnbNative.logo,
                  value.bnbNative.symbol ?? '',
                  'Smart Chain',
                  value.bnbNative.balance ?? '0',
                  Colors.black,
                ),
              );
            },
          ),
          // Consumer<ContractProvider>(builder: (context, value, child) {
          //   return GestureDetector(
          //     onTap: () {
          //       // Navigator.push(
          //       //   context,
          //       //   RouteAnimation(
          //       //     enterPage: AssetInfo(
          //       //       assetLogo: value.nativeM.logo,
          //       //       balance: value.nativeM.balance,
          //       //       tokenSymbol: value.nativeM.symbol,
          //       //       org: value.nativeM.org,
          //       //     ),
          //       //   ),
          //       // );
          //     },
          //     child: AssetItem(
          //       value.etherNative.logo,
          //       value.etherNative.symbol,
          //       value.etherNative.org,
          //       value.etherNative.balance??'0',
          //       Colors.white,
          //     ),
          //   );
          // }),
          Consumer<ApiProvider>(builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      assetLogo: value.nativeM.logo,
                      balance: value.nativeM.balance,
                      tokenSymbol: value.nativeM.symbol,
                      org: value.nativeM.org,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.nativeM.logo,
                value.nativeM.symbol,
                value.nativeM.org,
                value.nativeM.balance,
                Colors.white,
              ),
            );
          }),
          Consumer<ContractProvider>(builder: (context, value, child) {
            return value.token.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: false,
                    primary: false,
                    itemCount: value.token.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: DismissibleBackground(),
                        onDismissed: (direct) {
                          value.removeToken(value.token[index].symbol, context);
                          setPortfolio();
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              RouteAnimation(
                                enterPage: AssetInfo(
                                  assetLogo: 'assets/circle.png',
                                  balance: value.token[index].balance ?? '0',
                                  tokenSymbol: value.token[index].symbol ?? '',
                                  org: value.token[index].org,
                                ),
                              ),
                            );
                          },
                          child: AssetItem(
                            'assets/circle.png',
                            value.token[index].symbol ?? '',
                            'BEP-20',
                            value.token[index].balance ?? '0',
                            Colors.black,
                          ),
                        ),
                      );
                    })
                : Container();
          }),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
