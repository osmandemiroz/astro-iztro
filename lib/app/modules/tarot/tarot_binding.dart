import 'package:astro_iztro/app/modules/tarot/tarot_controller.dart';
import 'package:get/get.dart';

/// [TarotBinding] - Dependency injection binding for Tarot module
/// Provides controller instance to the view
class TarotBinding extends Bindings {
  @override
  void dependencies() {
    // Bind the TarotController to the GetX dependency injection system
    Get.lazyPut<TarotController>(TarotController.new);
  }
}
