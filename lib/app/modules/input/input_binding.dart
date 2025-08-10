import 'package:astro_iztro/app/modules/input/input_controller.dart';
import 'package:get/get.dart';

/// [InputBinding] - Dependency injection for Input module
class InputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputController>(InputController.new);
  }
}
