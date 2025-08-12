import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// [FortuneCycleCard] - Beautiful card displaying fortune cycle information
/// Shows cycle name, value, and strength with visual indicators
class FortuneCycleCard extends StatelessWidget {
  const FortuneCycleCard({
    required this.cycleName,
    required this.cycleValue,
    required this.cycleDescription,
    required this.strength,
    required this.showChineseNames,
    super.key,
  });
  final String cycleName;
  final String cycleValue;
  final String cycleDescription;
  final double strength;
  final bool showChineseNames;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.white,
              _getStrengthColor().withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cycle name and strength indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      cycleName,
                      style: AppTheme.headingSmall.copyWith(
                        color: AppColors.primaryPurple,
                        fontFamily: showChineseNames
                            ? AppConstants.chineseFont
                            : AppConstants.primaryFont,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStrengthColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _getStrengthColor().withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _getStrengthText(),
                      style: AppTheme.caption.copyWith(
                        color: _getStrengthColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.smallPadding),

              // Cycle value
              Text(
                cycleValue,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppColors.grey900,
                  fontFamily: showChineseNames
                      ? AppConstants.chineseFont
                      : AppConstants.primaryFont,
                ),
              ),

              const SizedBox(height: AppConstants.smallPadding),

              // Description
              Text(
                cycleDescription,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.grey700,
                ),
              ),

              const SizedBox(height: AppConstants.smallPadding),

              // Strength bar
              LinearProgressIndicator(
                value: strength,
                backgroundColor: AppColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor()),
                minHeight: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStrengthColor() {
    if (strength >= 0.8) return Colors.green;
    if (strength >= 0.6) return Colors.lightGreen;
    if (strength >= 0.4) return Colors.orange;
    if (strength >= 0.2) return Colors.red;
    return AppColors.grey500;
  }

  String _getStrengthText() {
    if (strength >= 0.8) return 'Very Strong';
    if (strength >= 0.6) return 'Strong';
    if (strength >= 0.4) return 'Moderate';
    if (strength >= 0.2) return 'Weak';
    return 'Very Weak';
  }
}
