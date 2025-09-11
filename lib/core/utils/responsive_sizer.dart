import 'package:flutter/material.dart';

/// A utility class for responsive sizing in Flutter applications.
/// This class provides methods to calculate sizes relative to screen dimensions.
class ResponsiveSizer {
  /// Private constructor to prevent instantiation
  ResponsiveSizer._();

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late bool isTablet;
  static late bool isPhone;
  static late double devicePixelRatio;

  /// Initialize responsive sizer with BuildContext
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    isTablet = screenWidth > 600;
    isPhone = screenWidth <= 600;
  }

  /// Get responsive width based on screen width percentage
  static double w(double percentage) {
    return percentage * blockSizeHorizontal;
  }

  /// Get responsive height based on screen height percentage
  static double h(double percentage) {
    return percentage * blockSizeVertical;
  }

  /// Get responsive width based on safe area width percentage
  static double sw(double percentage) {
    return percentage * safeBlockHorizontal;
  }

  /// Get responsive height based on safe area height percentage
  static double sh(double percentage) {
    return percentage * safeBlockVertical;
  }

  /// Get responsive font size based on screen width
  static double sp(double size) {
    return size * (blockSizeHorizontal + blockSizeVertical) / 2;
  }

  /// Get adaptive value based on screen size
  /// Returns different values for phone and tablet
  static T adaptive<T>({required T mobile, required T tablet}) {
    return isTablet ? tablet : mobile;
  }
}
