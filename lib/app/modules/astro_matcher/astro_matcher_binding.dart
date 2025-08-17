import 'package:astro_iztro/app/modules/astro_matcher/astro_matcher_controller.dart';
import 'package:get/get.dart';

/// [AstroMatcherBinding] - Dependency injection binding for Astro Matcher module
/// Provides controller and service dependencies for astrological compatibility analysis
class AstroMatcherBinding extends Bindings {
  @override
  void dependencies() {
    // Bind the Astro Matcher controller
    Get.lazyPut<AstroMatcherController>(
      AstroMatcherController.new,
    );
  }
}
