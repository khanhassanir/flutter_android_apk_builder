import 'package:flutter/material.dart';

class SizeConfig {
  static double _screenW = 390;
  static double _screenH = 844;

  static void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    _screenW = size.width;
    _screenH = size.height;
  }

  /// Percentage of screen width (0–100)
  static double w(double percent) => _screenW * percent / 100;

  /// Percentage of screen height (0–100)
  static double h(double percent) => _screenH * percent / 100;

  /// Scale a pixel value relative to a 390px wide baseline
  static double sp(double px) => px * (_screenW / 390);

  static bool get isSmall => _screenW < 360;
  static bool get isMedium => _screenW >= 360 && _screenW <= 480;
  static bool get isLarge => _screenW > 480;

  static double get screenWidth => _screenW;
  static double get screenHeight => _screenH;
}
