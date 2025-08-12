import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';

/// [ElementStrengthCard] - Beautiful card displaying element strength
/// Shows element name, count, and strength with visual indicators
class ElementStrengthCard extends StatelessWidget {
  const ElementStrengthCard({
    required this.element,
    required this.count,
    required this.maxCount,
    required this.showChineseNames,
    required this.description,
    super.key,
  });
  final String element;
  final int count;
  final int maxCount;
  final bool showChineseNames;
  final String description;

  @override
  Widget build(BuildContext context) {
    final strength = count / maxCount;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.white,
              _getElementColor().withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Element name and count
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getElementColor(),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        element,
                        style: AppTheme.headingSmall.copyWith(
                          color: AppColors.white,
                          fontFamily: AppConstants.chineseFont,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getElementName(),
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getElementColor(),
                          ),
                        ),
                        Text(
                          'Count: $count',
                          style: AppTheme.caption.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getElementColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _getElementColor().withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _getStrengthText(strength),
                      style: AppTheme.caption.copyWith(
                        color: _getElementColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.smallPadding),

              // Description
              Text(
                description,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.grey700,
                ),
              ),

              const SizedBox(height: AppConstants.smallPadding),

              // Strength bar
              LinearProgressIndicator(
                value: strength,
                backgroundColor: AppColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(_getElementColor()),
                minHeight: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getElementColor() {
    switch (element) {
      case '木':
        return Colors.green;
      case '火':
        return Colors.red;
      case '土':
        return Colors.brown;
      case '金':
        return Colors.grey.shade600;
      case '水':
        return Colors.blue;
      default:
        return AppColors.grey500;
    }
  }

  String _getElementName() {
    if (!showChineseNames) {
      switch (element) {
        case '木':
          return 'Wood';
        case '火':
          return 'Fire';
        case '土':
          return 'Earth';
        case '金':
          return 'Metal';
        case '水':
          return 'Water';
        default:
          return 'Unknown';
      }
    }
    return element;
  }

  String _getStrengthText(double strength) {
    if (strength >= 0.8) return 'Very Strong';
    if (strength >= 0.6) return 'Strong';
    if (strength >= 0.4) return 'Moderate';
    if (strength >= 0.2) return 'Weak';
    return 'Very Weak';
  }
}
