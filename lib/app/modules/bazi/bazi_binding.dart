import 'package:astro_iztro/app/modules/bazi/bazi_controller.dart';
import 'package:get/get.dart';

/// [BaZiBinding] - Dependency injection for BaZi module
class BaZiBinding extends Bindings {
  @override
  void dependencies() {
    // [BaZiBinding] - Setting up BaZiController for Four Pillars analysis
    Get.lazyPut<BaZiController>(
      BaZiController.new,
      fenix: true, // Allow recreation if disposed
    );
  }
}
