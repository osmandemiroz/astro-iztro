import 'package:astro_iztro/app/modules/analysis/analysis_controller.dart';
import 'package:get/get.dart';

class AnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalysisController>(AnalysisController.new);
  }
}
