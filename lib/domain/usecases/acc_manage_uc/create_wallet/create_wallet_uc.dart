import 'package:bitriel_wallet/index.dart';

abstract class CreateWalletUsecase {

  set setBuildContext(BuildContext ctx);

  Future<void> verifyLater();

  Future<void> addAndImport();
  
  Future<void> generateSeed();
  
  /// 1
  List<int> randomThreeEachNumber();
  /// 2
  void remove3Seeds();
  void onTapThreeSeeds(int index, int rmIndex);
  // void resetThreeSeed();

}