import 'package:astro_iztro/app/modules/chart/chart_controller.dart';
import 'package:get/get.dart';

/// [ChartBinding] - Dependency injection for Chart module
class ChartBinding extends Bindings {
  @override
  void dependencies() {
    // [ChartBinding] - Setting up ChartController for Purple Star chart display
    Get.lazyPut<ChartController>(
      ChartController.new,
      fenix: true, // Allow recreation if disposed
    );
  }
}
