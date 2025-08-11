import 'package:astro_iztro/app/modules/analysis/analysis_controller.dart';
import 'package:get/get.dart';

/// [AnalysisBinding] - Dependency injection for Analysis module
class AnalysisBinding extends Bindings {
  @override
  void dependencies() {
    // [AnalysisBinding] - Setting up AnalysisController for detailed analysis
    Get.lazyPut<AnalysisController>(
      AnalysisController.new,
      fenix: true, // Allow recreation if disposed
    );
  }
}
