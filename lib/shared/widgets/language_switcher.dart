import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/services/language_service.dart';
import 'package:astro_iztro/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [LanguageSwitcher] - Floating language switcher widget
/// Provides a beautiful, Apple-inspired language selection interface
/// Following Apple Human Interface Guidelines for modern, sleek design
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageService>(
      builder: (languageService) {
        return FloatingActionButton(
          onPressed: () => _showLanguageDialog(context, languageService),
          backgroundColor: AppColors.primaryPurple,
          child: const Icon(
            Icons.language,
            color: AppColors.white,
          ),
        );
      },
    );
  }

  /// [showLanguageDialog] - Show language selection dialog
  /// Beautiful, modern dialog following Apple HIG principles
  void _showLanguageDialog(
    BuildContext context,
    LanguageService languageService,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Select Language',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageService.supportedLocales.map((locale) {
              final isSelected = languageService.isCurrentLanguage(locale);
              final languageName =
                  LanguageService.languageNames[locale.languageCode] ??
                      'Unknown';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(
                    languageName,
                    style: AppTheme.bodyLarge.copyWith(
                      color: isSelected
                          ? AppColors.primaryPurple
                          : AppColors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryPurple,
                        )
                      : null,
                  onTap: () {
                    languageService.changeLanguage(locale);
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isSelected
                      ? AppColors.primaryPurple.withValues(alpha: 0.1)
                      : Colors.transparent,
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// [LanguageSwitcherButton] - Simple language switcher button
/// Can be used in settings or other UI components
class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageService>(
      builder: (languageService) {
        return InkWell(
          onTap: () => _showLanguageDialog(context, languageService),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.language,
                  color: AppColors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  languageService.getCurrentLanguageName(),
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// [showLanguageDialog] - Show language selection dialog
  /// Beautiful, modern dialog following Apple HIG principles
  void _showLanguageDialog(
    BuildContext context,
    LanguageService languageService,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Select Language',
            style: AppTheme.headingMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageService.supportedLocales.map((locale) {
              final isSelected = languageService.isCurrentLanguage(locale);
              final languageName =
                  LanguageService.languageNames[locale.languageCode] ??
                      'Unknown';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(
                    languageName,
                    style: AppTheme.bodyLarge.copyWith(
                      color: isSelected
                          ? AppColors.primaryPurple
                          : AppColors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryPurple,
                        )
                      : null,
                  onTap: () {
                    languageService.changeLanguage(locale);
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isSelected
                      ? AppColors.primaryPurple.withValues(alpha: 0.1)
                      : Colors.transparent,
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
