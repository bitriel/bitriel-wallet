import 'package:flutter/widgets.dart';

class SizeConfig{
  
  static double? _screenHeight;
  static double? _screenWidth;
  static double? _blockSizeHorizontal = 0;
  static double? _blockSizeVertical = 0;

  static double? textMultiplier;
  static double? imageSizeMultiplier;
  static double? heightMultiplier;

  void init(BoxConstraints constraints, Orientation orientation){
   
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    _blockSizeHorizontal = _screenWidth! / 100;
    _blockSizeVertical = _screenHeight! / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;


  }

  double get getVertical => _blockSizeVertical!;
  double get getHorizotal => _blockSizeHorizontal!;
  double get getWidth => _screenWidth!;
}