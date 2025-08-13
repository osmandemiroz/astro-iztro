import 'package:astro_iztro/app/modules/settings/settings_controller.dart';
import 'package:get/get.dart';

/// [SettingsBinding] - Dependency injection for Settings module
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // [SettingsBinding] - Setting up SettingsController for app preferences
    Get.lazyPut<SettingsController>(
      SettingsController.new,
      fenix: true, // Allow recreation if disposed
    );
  }
}
