import 'package:get/get.dart';
import 'tarot_controller.dart';

/// [TarotBinding] - Dependency injection binding for Tarot module
/// Provides controller instance to the view
class TarotBinding extends Bindings {
  @override
  void dependencies() {
    // Bind the TarotController to the GetX dependency injection system
    Get.lazyPut<TarotController>(() => TarotController());
  }
}
