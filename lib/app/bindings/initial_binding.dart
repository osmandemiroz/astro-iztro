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

    // Additional route-specific dependencies can be added here if needed
    // For example: controllers that should be available app-wide
  }
}
