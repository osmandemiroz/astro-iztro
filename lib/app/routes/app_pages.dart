import 'package:astro_iztro/app/modules/analysis/analysis_binding.dart';
import 'package:astro_iztro/app/modules/analysis/analysis_view.dart';
import 'package:astro_iztro/app/modules/bazi/bazi_binding.dart';
import 'package:astro_iztro/app/modules/bazi/bazi_view.dart';
import 'package:astro_iztro/app/modules/chart/chart_binding.dart';
import 'package:astro_iztro/app/modules/chart/chart_view.dart';
import 'package:astro_iztro/app/modules/home/home_binding.dart';
import 'package:astro_iztro/app/modules/home/home_view.dart';
import 'package:astro_iztro/app/modules/input/input_binding.dart';
import 'package:astro_iztro/app/modules/input/input_view.dart';
import 'package:astro_iztro/app/modules/settings/settings_binding.dart';
import 'package:astro_iztro/app/modules/settings/settings_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

/// [AppPages] - Navigation configuration for the entire app
/// Defines all routes and their corresponding pages with bindings
class AppPages {
  AppPages._();

  static const String INITIAL = Routes.HOME;

  static final List<GetPage<dynamic>> routes = [
    // Home screen - Main dashboard
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // User input screen - Birth data entry
    GetPage(
      name: _Paths.INPUT,
      page: () => const InputView(),
      binding: InputBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Purple Star chart screen
    GetPage(
      name: _Paths.CHART,
      page: () => const ChartView(),
      binding: ChartBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // BaZi calculation screen
    GetPage(
      name: _Paths.BAZI,
      page: () => const BaZiView(),
      binding: BaZiBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Detailed analysis screen
    GetPage(
      name: _Paths.ANALYSIS,
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Settings screen
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
