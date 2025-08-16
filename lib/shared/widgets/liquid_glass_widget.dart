import 'dart:ui';

import 'package:astro_iztro/core/constants/colors.dart';
import 'package:flutter/material.dart';

/// [LiquidGlassWidget] - Custom liquid glass effect widget
/// Provides a modern, translucent glass appearance with customizable properties
/// Following Apple Human Interface Guidelines for modern, sleek design
class LiquidGlassWidget extends StatelessWidget {
  /// [LiquidGlassWidget] constructor
  /// [child] - The widget to display inside the glass effect
  /// [blurRadius] - The blur radius for the glass effect (default: 10.0)
  /// [glassColor] - The color of the glass (default: AppColors.glassSurface)
  /// [borderColor] - The color of the border (default: AppColors.glassBorder)
  /// [borderWidth] - The width of the border (default: 1.0)
  /// [borderRadius] - The border radius (default: AppConstants.borderRadius)
  /// [padding] - The padding inside the glass effect
  /// [margin] - The margin around the glass effect
  /// [width] - The width of the glass effect
  /// [height] - The height of the glass effect
  /// [alignment] - The alignment of the child widget
  /// [enableShadow] - Whether to enable shadow effect (default: true)
  const LiquidGlassWidget({
    required this.child,
    super.key,
    this.blurRadius = 10.0,
    this.glassColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment,
    this.enableShadow = true,
  });
  final Widget child;
  final double blurRadius;
  final Color? glassColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final bool enableShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? AppColors.glassBorder,
          width: borderWidth,
        ),
        boxShadow: enableShadow
            ? [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurRadius,
            sigmaY: blurRadius,
          ),
          child: Container(
            padding: padding,
            alignment: alignment,
            decoration: BoxDecoration(
              color: (glassColor ?? AppColors.glassSurface).withValues(
                alpha: 0.1,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(16),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// [LiquidGlassCard] - Pre-configured liquid glass card widget
/// Provides a consistent glass effect for cards throughout the app
class LiquidGlassCard extends StatelessWidget {
  /// [LiquidGlassCard] constructor
  /// [child] - The widget to display inside the glass card
  /// [padding] - The padding inside the glass card (default: 16px)
  /// [margin] - The margin around the glass card
  /// [width] - The width of the glass card
  /// [height] - The height of the glass card
  /// [onTap] - Callback when the card is tapped
  /// [borderRadius] - The border radius (default: 16px)
  const LiquidGlassCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final Widget glassWidget = LiquidGlassWidget(
      width: width,
      height: height,
      margin: margin,
      borderRadius: borderRadius,
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: glassWidget,
      );
    }

    return glassWidget;
  }
}

/// [LiquidGlassButton] - Pre-configured liquid glass button widget
/// Provides a consistent glass effect for buttons throughout the app
class LiquidGlassButton extends StatelessWidget {
  /// [LiquidGlassButton] constructor
  /// [child] - The widget to display inside the glass button
  /// [onPressed] - Callback when the button is pressed
  /// [padding] - The padding inside the glass button (default: 16px)
  /// [margin] - The margin around the glass button
  /// [width] - The width of the glass button
  /// [height] - The height of the glass button
  /// [borderRadius] - The border radius (default: 16px)
  /// [isEnabled] - Whether the button is enabled (default: true)
  const LiquidGlassButton({
    required this.child,
    super.key,
    this.onPressed,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.isEnabled = true,
  });
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassWidget(
      width: width,
      height: height,
      margin: margin,
      borderRadius: borderRadius,
      padding: padding,
      glassColor: isEnabled ? AppColors.glassPrimary : AppColors.glassSurface,
      borderColor: isEnabled ? AppColors.lightPurple : AppColors.darkBorder,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: child,
        ),
      ),
    );
  }
}
