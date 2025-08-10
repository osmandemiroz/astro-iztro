import 'package:astro_iztro/core/services/iztro_service.dart';
import 'package:astro_iztro/core/services/storage_service.dart';
import 'package:get/get.dart';

/// [InitialBinding] - Initial dependency injection setup
/// Initializes core services that need to be available throughout the app
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // [InitialBinding] - Setting up core services for the entire app lifecycle
    // StorageService - handles all local data persistence
    Get
      ..putAsync<StorageService>(
        () async {
          final service = StorageService();
          await service.initialize();
          return service;
        },
        permanent: true, // Keep alive throughout app lifecycle
      )
      // IztroService - wrapper for dart_iztro calculations
      ..put<IztroService>(
        IztroService(),
        permanent: true, // Keep alive throughout app lifecycle
      );
  }
}
