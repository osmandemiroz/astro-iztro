import 'package:astro_iztro/app/modules/bazi/bazi_controller.dart';
import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [BaZiView] - Four Pillars BaZi analysis screen
class BaZiView extends GetView<BaZiController> {
  const BaZiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.baziTitle)),
        backgroundColor: AppColors.primaryGold,
        foregroundColor: AppColors.white,
      ),
      body: Obx(_buildBody),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.hasBaZiData
            ? controller.refreshBaZi
            : controller.calculateBaZi,
        backgroundColor: AppColors.primaryGold,
        child: Obx(
          () => Icon(
            controller.isCalculating.value
                ? Icons.hourglass_empty
                : controller.hasBaZiData
                ? Icons.refresh
                : Icons.calculate,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
            ),
            SizedBox(height: AppConstants.defaultPadding),
            Text('Loading BaZi data...'),
          ],
        ),
      );
    }

    if (!controller.hasBaZiData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.view_column_outlined,
                size: 80,
                color: AppColors.grey400,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                'No BaZi Available',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                'Tap the calculate button to generate your Four Pillars chart',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final baziData = controller.baziData.value!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BaZi header with main info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  Text(
                    controller.getBaZiString(),
                    style: AppTheme.headingLarge.copyWith(
                      color: AppColors.primaryGold,
                      fontFamily: AppConstants.monoFont,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    '${baziData.chineseZodiac} • ${baziData.westernZodiac}',
                    style: AppTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Four Pillars display
          Text(
            'Four Pillars',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: AppConstants.smallPadding),

          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    child: Column(
                      children: [
                        Text(
                          controller.getPillarName(index),
                          style: AppTheme.caption,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          baziData.allPillars[index].pillarString,
                          style: AppTheme.headingSmall.copyWith(
                            fontFamily: AppConstants.chineseFont,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${baziData.allPillars[index].stemElement}/${baziData.allPillars[index].branchElement}',
                          style: AppTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Element analysis
          Text(
            'Element Analysis',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: AppConstants.smallPadding),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  ...baziData.elementCounts.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: Text(
                              entry.key,
                              style: AppTheme.bodyMedium.copyWith(
                                fontFamily: AppConstants.chineseFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value:
                                  entry.value / 8, // Max possible is around 8
                              backgroundColor: AppColors.grey200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                controller.getElementStrengthColor(entry.key),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${entry.value}'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.defaultPadding),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Strongest: ${baziData.strongestElement}',
                              style: AppTheme.bodyMedium.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Weakest: ${baziData.weakestElement}',
                              style: AppTheme.bodyMedium.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Balance: ${baziData.elementBalanceScore}%',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (baziData.recommendations.isNotEmpty) ...[
            const SizedBox(height: AppConstants.defaultPadding),

            Text(
              'Recommendations',
              style: AppTheme.headingMedium,
            ),
            const SizedBox(height: AppConstants.smallPadding),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: baziData.recommendations
                      .map(
                        (rec) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(child: Text(rec)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
