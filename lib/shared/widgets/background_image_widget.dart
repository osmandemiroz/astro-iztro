import 'dart:ui';

import 'package:astro_iztro/core/constants/colors.dart';
import 'package:flutter/material.dart';

/// [BackgroundImageWidget] - Background image widget with blur effect
/// Provides blurred background images for different screens with performance optimization
/// Following Apple Human Interface Guidelines for modern, immersive design
class BackgroundImageWidget extends StatelessWidget {
  /// [BackgroundImageWidget] constructor
  /// [imagePath] - Path to the background image asset
  /// [blurRadius] - The blur radius for the background (default: 15.0)
  /// [child] - The widget to display over the background
  /// [overlayColor] - Optional overlay color for better text readability
  /// [fit] - How the image should fit the container (default: BoxFit.cover)
  /// [alignment] - How the image should be aligned (default: Alignment.center)
  const BackgroundImageWidget({
    required this.imagePath,
    required this.child,
    super.key,
    this.blurRadius = 10,
    this.overlayColor,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });
  final String imagePath;
  final double blurRadius;
  final Widget child;
  final Color? overlayColor;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background image
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(),
            child: Image.asset(
              imagePath,
              fit: fit,
              alignment: alignment,
              // Performance optimization: use cacheWidth and cacheHeight
              cacheWidth: MediaQuery.of(context).size.width.toInt(),
              cacheHeight: MediaQuery.of(context).size.height.toInt(),
            ),
          ),
        ),

        // Optional overlay for better text readability
        if (overlayColor != null)
          Positioned.fill(
            child: Container(
              color: overlayColor!.withValues(alpha: 0.3),
            ),
          ),

        // Content
        child,
      ],
    );
  }
}

/// [PurpleStarBackground] - Pre-configured background for Purple Star Chart screens
/// Uses the purple_star_chart.jpg image with optimal blur settings
class PurpleStarBackground extends StatelessWidget {
  const PurpleStarBackground({
    required this.child,
    super.key,
    this.blurRadius,
  });
  final Widget child;
  final double? blurRadius;

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      imagePath: 'assets/images/purple_star_chart.jpg',
      blurRadius: blurRadius ?? 20.0, // Stronger blur for chart screens
      overlayColor: AppColors.darkBackground.withValues(alpha: 0.4),
      child: child,
    );
  }
}

/// [BaZiBackground] - Pre-configured background for BaZi Analysis screens
/// Uses the bazi_analysis.jpg image with optimal blur settings
class BaZiBackground extends StatelessWidget {
  const BaZiBackground({
    required this.child,
    super.key,
    this.blurRadius,
  });
  final Widget child;
  final double? blurRadius;

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      imagePath: 'assets/images/bazi_analysis.jpg',
      blurRadius: blurRadius ?? 18.0, // Medium blur for analysis screens
      overlayColor: AppColors.darkBackground.withValues(alpha: 0.35),
      child: child,
    );
  }
}

/// [DetailedAnalysisBackground] - Pre-configured background for Detailed Analysis screens
/// Uses the detailed_analysis.jpg image with optimal blur settings
class DetailedAnalysisBackground extends StatelessWidget {
  const DetailedAnalysisBackground({
    required this.child,
    super.key,
    this.blurRadius,
  });
  final Widget child;
  final double? blurRadius;

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
      imagePath: 'assets/images/detailed_analysis.jpg',
      blurRadius: blurRadius ?? 16.0, // Lighter blur for detailed screens
      overlayColor: AppColors.darkBackground.withValues(alpha: 0.3),
      child: child,
    );
  }
}

/// [HomeBackground] - Pre-configured background for Home screen
/// Uses a gradient background instead of image for better performance
class HomeBackground extends StatelessWidget {
  const HomeBackground({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.darkSpaceGradient,
      ),
      child: child,
    );
  }
}
