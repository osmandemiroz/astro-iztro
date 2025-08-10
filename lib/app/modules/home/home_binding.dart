import 'package:astro_iztro/app/modules/home/home_controller.dart';
import 'package:get/get.dart';

/// [HomeBinding] - Dependency injection for Home module
/// Sets up the HomeController with proper lifecycle management
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // [HomeBinding] - Setting up HomeController for dashboard functionality
    // Using Get.lazyPut for efficient memory management
    Get.lazyPut<HomeController>(
      HomeController.new,
      fenix: true, // Allow recreation if disposed
    );
  }
}
