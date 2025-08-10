part of 'app_pages.dart';

/// [Routes] - Route name constants for type-safe navigation
/// Contains all route names used throughout the application
abstract class Routes {
  Routes._();

  static const String HOME = _Paths.HOME;
  static const String INPUT = _Paths.INPUT;
  static const String CHART = _Paths.CHART;
  static const String BAZI = _Paths.BAZI;
  static const String ANALYSIS = _Paths.ANALYSIS;
  static const String SETTINGS = _Paths.SETTINGS;
}

/// [_Paths] - Internal path constants
/// Used internally by Routes class
abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const INPUT = '/input';
  static const CHART = '/chart';
  static const BAZI = '/bazi';
  static const ANALYSIS = '/analysis';
  static const SETTINGS = '/settings';
}
