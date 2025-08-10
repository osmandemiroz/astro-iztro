import 'package:astro_iztro/app/modules/settings/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(SettingsController.new);
  }
}
