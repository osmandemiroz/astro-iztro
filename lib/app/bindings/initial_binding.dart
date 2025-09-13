import 'package:astro_iztro/core/services/language_service.dart';
import 'package:get/get.dart';

/// [InitialBinding] - Initial dependency injection setup
/// Core services are now initialized in main.dart to prevent initialization errors
/// This binding can be used for additional route-specific dependencies
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // [InitialBinding] - Core services (StorageService, IztroService) are now
    // initialized in main.dart before the app starts to prevent "service not found" errors
    // This ensures all services are available immediately when the app loads

    // Initialize language service for i18n support
    Get.lazyPut<LanguageService>(LanguageService.new, fenix: true);
  }
}
