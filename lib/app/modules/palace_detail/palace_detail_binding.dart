import 'package:astro_iztro/app/modules/palace_detail/palace_detail_controller.dart';
import 'package:astro_iztro/core/models/chart_data.dart' hide StarData;
import 'package:astro_iztro/core/models/star_data.dart';
import 'package:get/get.dart';

/// [PalaceDetailBinding] - Dependency injection for Palace Detail module
class PalaceDetailBinding extends Bindings {
  @override
  void dependencies() {
    // [PalaceDetailBinding] - Setting up PalaceDetailController
    final args = Get.arguments as Map<String, dynamic>;
    final palace = args['palace'] as PalaceData;
    final stars = args['stars'] as List<StarData>;
    final showChineseNames = args['showChineseNames'] as bool;

    Get.lazyPut<PalaceDetailController>(
      () => PalaceDetailController(
        initialPalace: palace,
        initialStars: stars,
        initialLanguage: showChineseNames,
      ),
      fenix: true,
    );
  }
}
