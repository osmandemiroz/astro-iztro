import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// [ShimmerLoading] - Shimmer loading placeholders for various content types
/// Provides elegant loading states matching the app theme
class ShimmerLoading {
  ShimmerLoading._();

  /// Base shimmer colors for dark theme
  static const Color _baseColor = Color(0xFF1A1A2E);
  static const Color _highlightColor = Color(0xFF2D2D44);

  /// Card shimmer - for loading card content
  static Widget card({
    double? width,
    double? height,
    double borderRadius = 16.0,
  }) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        width: width,
        height: height ?? 120,
        decoration: BoxDecoration(
          color: _baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Text shimmer - for loading text content
  static Widget text({
    double width = 200,
    double height = 16,
    double borderRadius = 4.0,
  }) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Circle shimmer - for loading circular content (avatars, icons)
  static Widget circle({
    double size = 50,
  }) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: _baseColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// List item shimmer - for loading list items
  static Widget listItem({
    bool showAvatar = true,
    int lineCount = 2,
  }) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showAvatar) ...[
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: _baseColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _baseColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    lineCount - 1,
                    (index) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        width: double.infinity,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Grid item shimmer - for loading grid items
  static Widget gridItem({
    double? width,
    double? height,
  }) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        width: width,
        height: height ?? 150,
        decoration: BoxDecoration(
          color: _baseColor,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
