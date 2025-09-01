import 'package:astro_iztro/app/modules/onboarding/onboarding_controller.dart';
import 'package:get/get.dart';

/// [OnboardingBinding] - Dependency injection for onboarding module
/// Provides controller instances for the onboarding flow
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    // Register the onboarding controller
    Get.lazyPut<OnboardingController>(OnboardingController.new);
  }
}
