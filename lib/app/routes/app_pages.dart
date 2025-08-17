import 'package:astro_iztro/app/modules/analysis/analysis_binding.dart';
import 'package:astro_iztro/app/modules/analysis/analysis_view.dart';
import 'package:astro_iztro/app/modules/astro_matcher/astro_matcher_binding.dart';
import 'package:astro_iztro/app/modules/astro_matcher/astro_matcher_view.dart';
import 'package:astro_iztro/app/modules/bazi/bazi_binding.dart';
import 'package:astro_iztro/app/modules/bazi/bazi_view.dart';
import 'package:astro_iztro/app/modules/chart/chart_binding.dart';
import 'package:astro_iztro/app/modules/chart/chart_view.dart';
import 'package:astro_iztro/app/modules/home/home_binding.dart';
import 'package:astro_iztro/app/modules/home/home_view.dart';
import 'package:astro_iztro/app/modules/input/input_binding.dart';
import 'package:astro_iztro/app/modules/input/input_view.dart';
import 'package:astro_iztro/app/modules/palace_detail/palace_detail_binding.dart';
import 'package:astro_iztro/app/modules/palace_detail/palace_detail_view.dart';
import 'package:astro_iztro/app/modules/settings/settings_binding.dart';
import 'package:astro_iztro/app/modules/settings/settings_view.dart';
import 'package:astro_iztro/app/routes/app_routes.dart';
import 'package:get/get.dart';

/// [AppPages] - Application page routes and bindings
abstract class AppPages {
  static const String INITIAL = AppRoutes.home;

  static final routes = [
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.input,
      page: () => const InputView(),
      binding: InputBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.chart,
      page: () => const ChartView(),
      binding: ChartBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.bazi,
      page: () => const BaZiView(),
      binding: BaZiBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.analysis,
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.astroMatcher,
      page: () => const AstroMatcherView(),
      binding: AstroMatcherBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.palaceDetail,
      page: () => const PalaceDetailView(),
      binding: PalaceDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),
  ];
}
