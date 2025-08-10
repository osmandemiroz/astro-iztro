import 'dart:math' as math;

import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:flutter/material.dart';

/// [AstroChartWidget] - Custom circular Purple Star chart widget
/// Displays 12 palaces in traditional circular layout with beautiful animations
class AstroChartWidget extends StatefulWidget {
  const AstroChartWidget({
    required this.chartData,
    required this.selectedPalaceIndex,
    required this.showStarDetails,
    required this.showChineseNames,
    required this.onPalaceTap,
    super.key,
  });
  final ChartData chartData;
  final int selectedPalaceIndex;
  final bool showStarDetails;
  final bool showChineseNames;
  final void Function(int) onPalaceTap;

  @override
  State<AstroChartWidget> createState() => _AstroChartWidgetState();
}

class _AstroChartWidgetState extends State<AstroChartWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // [AstroChartWidget.initState] - Setting up beautiful chart animations
    // Rotation animation for mystical effect
    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    _rotationAnimation =
        Tween<double>(
          begin: 0,
          end: 2 * math.pi,
        ).animate(
          CurvedAnimation(
            parent: _rotationController,
            curve: Curves.linear,
          ),
        );

    // Pulse animation for selected palace
    _pulseController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );
    _pulseAnimation =
        Tween<double>(
          begin: 1,
          end: 1.1,
        ).animate(
          CurvedAnimation(
            parent: _pulseController,
            curve: Curves.easeInOut,
          ),
        );

    // Start continuous rotation
    _rotationController.repeat();
  }

  @override
  void didUpdateWidget(AstroChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate when palace selection changes
    if (widget.selectedPalaceIndex != oldWidget.selectedPalaceIndex) {
      if (widget.selectedPalaceIndex != -1) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController
          ..stop()
          ..reset();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AstroChartPainter(
        chartData: widget.chartData,
        selectedPalaceIndex: widget.selectedPalaceIndex,
        showStarDetails: widget.showStarDetails,
        showChineseNames: widget.showChineseNames,
        rotationAnimation: _rotationAnimation,
        pulseAnimation: _pulseAnimation,
        onPalaceTap: widget.onPalaceTap,
      ),
      child: Container(),
    );
  }
}

/// [AstroChartPainter] - Custom painter for the Purple Star chart
/// Creates beautiful circular layout with palaces, stars, and interactions
class AstroChartPainter extends CustomPainter {
  AstroChartPainter({
    required this.chartData,
    required this.selectedPalaceIndex,
    required this.showStarDetails,
    required this.showChineseNames,
    required this.rotationAnimation,
    required this.pulseAnimation,
    required this.onPalaceTap,
  }) : super(repaint: Listenable.merge([rotationAnimation, pulseAnimation]));
  final ChartData chartData;
  final int selectedPalaceIndex;
  final bool showStarDetails;
  final bool showChineseNames;
  final Animation<double> rotationAnimation;
  final Animation<double> pulseAnimation;
  final void Function(int) onPalaceTap;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;

    // Draw background circle with mystical gradient
    _drawBackground(canvas, center, radius);

    // Draw palace divisions
    _drawPalaceDivisions(canvas, center, radius);

    // Draw palaces
    _drawPalaces(canvas, center, radius);

    // Draw center element
    _drawCenter(canvas, center);
  }

  /// Draw background with mystical gradient
  void _drawBackground(Canvas canvas, Offset center, double radius) {
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.ultraLightPurple.withValues(alpha: 0.3),
          AppColors.primaryPurple.withValues(alpha: 0.1),
          AppColors.primaryGold.withValues(alpha: 0.05),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw outer ring
    final ringPaint = Paint()
      ..color = AppColors.primaryPurple.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, ringPaint);
  }

  /// Draw division lines between palaces
  void _drawPalaceDivisions(Canvas canvas, Offset center, double radius) {
    final linePaint = Paint()
      ..color = AppColors.primaryPurple.withValues(alpha: 0.2)
      ..strokeWidth = 1;

    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180; // Start from top
      final startPoint = Offset(
        center.dx + math.cos(angle) * (radius * 0.3),
        center.dy + math.sin(angle) * (radius * 0.3),
      );
      final endPoint = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      canvas.drawLine(startPoint, endPoint, linePaint);
    }
  }

  /// Draw individual palaces
  void _drawPalaces(Canvas canvas, Offset center, double radius) {
    for (var i = 0; i < chartData.palaces.length; i++) {
      final palace = chartData.palaces[i];
      _drawPalace(canvas, center, radius, palace, i);
    }
  }

  /// Draw individual palace
  void _drawPalace(
    Canvas canvas,
    Offset center,
    double radius,
    PalaceData palace,
    int index,
  ) {
    // Calculate palace position
    final angle = (index * 30 - 90) * math.pi / 180;
    final palaceRadius = radius * 0.65;
    final palaceCenter = Offset(
      center.dx + math.cos(angle) * palaceRadius,
      center.dy + math.sin(angle) * palaceRadius,
    );

    // Palace size with animation for selected palace
    var palaceSize = AppConstants.palaceSize;
    if (index == selectedPalaceIndex) {
      palaceSize *= pulseAnimation.value;
    }

    // Draw palace background
    final palacePaint = Paint()
      ..color = index == selectedPalaceIndex
          ? AppColors.primaryGold.withValues(alpha: 0.8)
          : AppColors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    final palaceRect = Rect.fromCenter(
      center: palaceCenter,
      width: palaceSize,
      height: palaceSize * 0.8,
    );

    final rrect = RRect.fromRectAndRadius(
      palaceRect,
      const Radius.circular(8),
    );

    canvas.drawRRect(rrect, palacePaint);

    // Draw palace border
    final borderPaint = Paint()
      ..color = index == selectedPalaceIndex
          ? AppColors.primaryPurple
          : AppColors.primaryPurple.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = index == selectedPalaceIndex ? 2 : 1;

    canvas.drawRRect(rrect, borderPaint);

    // Draw palace name
    _drawPalaceName(canvas, palaceCenter, palace, index == selectedPalaceIndex);

    // Draw stars in palace
    if (showStarDetails) {
      _drawStarsInPalace(canvas, palaceCenter, palace, palaceSize);
    }
  }

  /// Draw palace name
  void _drawPalaceName(
    Canvas canvas,
    Offset center,
    PalaceData palace,
    bool isSelected,
  ) {
    final textStyle = TextStyle(
      fontFamily: showChineseNames
          ? AppConstants.chineseFont
          : AppConstants.primaryFont,
      fontSize: isSelected ? 12 : 10,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      color: isSelected ? AppColors.white : AppColors.primaryPurple,
    );

    final textSpan = TextSpan(
      text: showChineseNames ? palace.nameZh : palace.name,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  /// Draw stars within a palace
  void _drawStarsInPalace(
    Canvas canvas,
    Offset palaceCenter,
    PalaceData palace,
    double palaceSize,
  ) {
    final stars = chartData.getStarsInPalace(palace.name);

    for (var i = 0; i < stars.length && i < 3; i++) {
      // Show max 3 stars
      final star = stars[i];
      final starOffset = Offset(
        palaceCenter.dx + (i - 1) * 12,
        palaceCenter.dy + 15,
      );

      // Draw star indicator
      final starPaint = Paint()
        ..color = _getStarColor(star)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(starOffset, 4, starPaint);

      // Draw transformation indicator if present
      if (star.transformationType != null) {
        final transformPaint = Paint()
          ..color = AppColors.primaryGold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawCircle(starOffset, 6, transformPaint);
      }
    }

    // Show star count if more than 3
    if (stars.length > 3) {
      final countText = TextSpan(
        text: '+${stars.length - 3}',
        style: const TextStyle(
          fontSize: 8,
          color: AppColors.grey600,
          fontWeight: FontWeight.w500,
        ),
      );

      final textPainter = TextPainter(
        text: countText,
        textDirection: TextDirection.ltr,
      )..layout();

      final textOffset = Offset(
        palaceCenter.dx + 20,
        palaceCenter.dy + 10,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  /// Get color for star based on category
  Color _getStarColor(StarData star) {
    switch (star.category) {
      case '主星':
        return AppColors.primaryPurple;
      case '吉星':
        return AppColors.success;
      case '凶星':
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  /// Draw center element
  void _drawCenter(Canvas canvas, Offset center) {
    // Draw rotating mystical symbol
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(rotationAnimation.value);

    // Draw central symbol (simplified Yin-Yang style)
    final centerPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primaryPurple, AppColors.primaryGold],
      ).createShader(const Rect.fromLTWH(-15, -15, 30, 30));

    canvas.drawCircle(Offset.zero, 15, centerPaint);

    // Draw inner symbol
    final symbolPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, 8, symbolPaint);

    // Draw decorative elements
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final lineStart = Offset(
        math.cos(angle) * 8,
        math.sin(angle) * 8,
      );
      final lineEnd = Offset(
        math.cos(angle) * 12,
        math.sin(angle) * 12,
      );

      final decorativePaint = Paint()
        ..color = AppColors.primaryGold
        ..strokeWidth = 1;

      canvas.drawLine(lineStart, lineEnd, decorativePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(AstroChartPainter oldDelegate) {
    return oldDelegate.selectedPalaceIndex != selectedPalaceIndex ||
        oldDelegate.showStarDetails != showStarDetails ||
        oldDelegate.showChineseNames != showChineseNames;
  }

  @override
  bool hitTest(Offset position) => true;
}
