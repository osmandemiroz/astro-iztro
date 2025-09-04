import 'dart:math' as math;

import 'package:astro_iztro/core/constants/app_constants.dart';
import 'package:astro_iztro/core/constants/colors.dart';
import 'package:astro_iztro/core/models/chart_data.dart';
import 'package:flutter/material.dart';

/// [AstroChartWidget] - Beautifully designed circular Purple Star chart widget
/// Features modern UI with sophisticated animations, glass effects, and enhanced visual hierarchy
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
  late AnimationController _glowController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // [AstroChartWidget.initState] - Setting up sophisticated chart animations
    // Smooth rotation animation for mystical effect
    _rotationController = AnimationController(
      duration: const Duration(seconds: 60), // Slower, more elegant rotation
      vsync: this,
    );
    _rotationAnimation =
        Tween<double>(
          begin: 0,
          end: 2 * math.pi,
        ).animate(
          CurvedAnimation(
            parent: _rotationController,
            curve: Curves.easeInOut,
          ),
        );

    // Enhanced pulse animation for selected palace
    _pulseController = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    );
    _pulseAnimation =
        Tween<double>(
          begin: 1,
          end: 1.15, // Slightly more pronounced pulse
        ).animate(
          CurvedAnimation(
            parent: _pulseController,
            curve: Curves.elasticOut,
          ),
        );

    // Glow animation for mystical effect
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation =
        Tween<double>(
          begin: 0.3,
          end: 0.8,
        ).animate(
          CurvedAnimation(
            parent: _glowController,
            curve: Curves.easeInOut,
          ),
        );

    // Start animations
    _rotationController.repeat();
    _glowController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AstroChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Enhanced animation when palace selection changes
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
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: EnhancedAstroChartPainter(
        chartData: widget.chartData,
        selectedPalaceIndex: widget.selectedPalaceIndex,
        showStarDetails: widget.showStarDetails,
        showChineseNames: widget.showChineseNames,
        rotationAnimation: _rotationAnimation,
        pulseAnimation: _pulseAnimation,
        glowAnimation: _glowAnimation,
        onPalaceTap: widget.onPalaceTap,
      ),
    );
  }
}

/// [EnhancedAstroChartPainter] - Sophisticated custom painter for the Purple Star chart
/// Creates beautiful circular layout with enhanced visual effects and modern design
class EnhancedAstroChartPainter extends CustomPainter {
  EnhancedAstroChartPainter({
    required this.chartData,
    required this.selectedPalaceIndex,
    required this.showStarDetails,
    required this.showChineseNames,
    required this.rotationAnimation,
    required this.pulseAnimation,
    required this.glowAnimation,
    required this.onPalaceTap,
  }) : super(
         repaint: Listenable.merge([
           rotationAnimation,
           pulseAnimation,
           glowAnimation,
         ]),
       );

  final ChartData chartData;
  final int selectedPalaceIndex;
  final bool showStarDetails;
  final bool showChineseNames;
  final Animation<double> rotationAnimation;
  final Animation<double> pulseAnimation;
  final Animation<double> glowAnimation;
  final void Function(int) onPalaceTap;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 30; // More padding

    // Draw enhanced background with sophisticated gradients
    _drawEnhancedBackground(canvas, center, radius);

    // Draw palace divisions with improved styling
    _drawEnhancedPalaceDivisions(canvas, center, radius);

    // Draw palaces with modern design
    _drawEnhancedPalaces(canvas, center, radius);

    // Draw enhanced center element
    _drawEnhancedCenter(canvas, center);

    // Draw connection lines between palaces
    _drawPalaceConnections(canvas, center, radius);
  }

  /// Draw enhanced background with sophisticated gradients and effects
  void _drawEnhancedBackground(Canvas canvas, Offset center, double radius) {
    // Main background gradient
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.darkCard.withValues(alpha: 0.8),
          AppColors.darkCardSecondary.withValues(alpha: 0.6),
          AppColors.darkBackground.withValues(alpha: 0.4),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, backgroundPaint);

    // Outer glow ring
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.lightPurple.withValues(alpha: glowAnimation.value * 0.3),
          AppColors.lightGold.withValues(alpha: glowAnimation.value * 0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 10));

    canvas.drawCircle(center, radius + 10, glowPaint);

    // Main outer ring with gradient
    final ringPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.lightPurple.withValues(alpha: 0.4),
          AppColors.lightGold.withValues(alpha: 0.2),
          AppColors.lightPurple.withValues(alpha: 0.4),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, ringPaint);

    // Inner ring for depth
    final innerRingPaint = Paint()
      ..color = AppColors.darkBorder.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius * 0.8, innerRingPaint);
  }

  /// Draw enhanced palace divisions with better styling
  void _drawEnhancedPalaceDivisions(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final linePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.lightPurple.withValues(alpha: 0.4),
          AppColors.lightPurple.withValues(alpha: 0.1),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

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

  /// Draw enhanced palaces with modern design
  void _drawEnhancedPalaces(Canvas canvas, Offset center, double radius) {
    for (var i = 0; i < chartData.palaces.length; i++) {
      final palace = chartData.palaces[i];
      _drawEnhancedPalace(canvas, center, radius, palace, i);
    }
  }

  /// Draw individual enhanced palace
  void _drawEnhancedPalace(
    Canvas canvas,
    Offset center,
    double radius,
    PalaceData palace,
    int index,
  ) {
    // Calculate palace position with better spacing
    final angle = (index * 30 - 90) * math.pi / 180;
    final palaceRadius =
        radius * 0.72; // Move palaces slightly outward for more space
    final palaceCenter = Offset(
      center.dx + math.cos(angle) * palaceRadius,
      center.dy + math.sin(angle) * palaceRadius,
    );

    // Calculate optimal palace size to prevent overlapping
    final basePalaceSize = math.min(
      0.12 * radius,
      50, // Scale with chart size, max 50px
    );
    var palaceSize = basePalaceSize;
    if (index == selectedPalaceIndex) {
      palaceSize *= pulseAnimation.value;
    }

    // Draw palace background with glass effect
    final palacePaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: index == selectedPalaceIndex
                ? [
                    AppColors.lightGold.withValues(alpha: 0.9),
                    AppColors.primaryGold.withValues(alpha: 0.7),
                  ]
                : [
                    AppColors.darkCard.withValues(alpha: 0.8),
                    AppColors.darkCardSecondary.withValues(alpha: 0.6),
                  ],
          ).createShader(
            Rect.fromLTWH(
              -palaceSize / 2,
              -palaceSize / 2,
              palaceSize.toDouble(),
              palaceSize.toDouble(),
            ),
          );

    final palaceRect = Rect.fromCenter(
      center: palaceCenter,
      width: palaceSize.toDouble(),
      height: palaceSize.toDouble() * 0.7, // More compact height
    );

    final rrect = RRect.fromRectAndRadius(
      palaceRect,
      const Radius.circular(12), // More rounded corners
    );

    canvas.drawRRect(rrect, palacePaint);

    // Enhanced palace border with gradient
    final borderPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: index == selectedPalaceIndex
                ? [
                    AppColors.lightGold,
                    AppColors.primaryGold,
                  ]
                : [
                    AppColors.lightPurple.withValues(alpha: 0.5),
                    AppColors.lightPurple.withValues(alpha: 0.3),
                  ],
          ).createShader(
            Rect.fromLTWH(
              -palaceSize / 2,
              -palaceSize / 2,
              palaceSize.toDouble(),
              palaceSize.toDouble(),
            ),
          )
      ..style = PaintingStyle.stroke
      ..strokeWidth = index == selectedPalaceIndex ? 3 : 1.5;

    canvas.drawRRect(rrect, borderPaint);

    // Draw palace name with enhanced styling
    _drawEnhancedPalaceName(
      canvas,
      palaceCenter,
      palace,
      index == selectedPalaceIndex,
    );

    // Draw enhanced stars in palace
    if (showStarDetails) {
      _drawEnhancedStarsInPalace(
        canvas,
        palaceCenter,
        palace,
        palaceSize.toDouble(),
      );
    }

    // Draw palace element indicator
    _drawPalaceElement(
      canvas,
      palaceCenter,
      palace,
      palaceSize.toDouble(),
    );
  }

  /// Draw enhanced palace name with better typography
  void _drawEnhancedPalaceName(
    Canvas canvas,
    Offset center,
    PalaceData palace,
    bool isSelected,
  ) {
    final textStyle = TextStyle(
      fontFamily: showChineseNames
          ? AppConstants.chineseFont
          : AppConstants.primaryFont,
      fontSize: isSelected ? 13 : 11,
      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
      color: isSelected ? AppColors.black : AppColors.darkTextPrimary,
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

  /// Draw enhanced stars within a palace
  void _drawEnhancedStarsInPalace(
    Canvas canvas,
    Offset palaceCenter,
    PalaceData palace,
    double palaceSize,
  ) {
    final stars = chartData.getStarsInPalace(palace.name);

    for (var i = 0; i < stars.length && i < 3; i++) {
      final star = stars[i];
      final starOffset = Offset(
        palaceCenter.dx + (i - 1) * 14,
        palaceCenter.dy + 18,
      );

      // Draw star with glow effect
      final starGlowPaint = Paint()
        ..color = _getStarColor(star).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(starOffset, 6, starGlowPaint);

      // Draw main star
      final starPaint = Paint()
        ..color = _getStarColor(star)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(starOffset, 4, starPaint);

      // Draw transformation indicator if present
      if (star.transformationType != null) {
        final transformPaint = Paint()
          ..shader = const RadialGradient(
            colors: [
              AppColors.lightGold,
              AppColors.primaryGold,
            ],
          ).createShader(Rect.fromCircle(center: starOffset, radius: 8))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(starOffset, 7, transformPaint);
      }
    }

    // Show star count if more than 3
    if (stars.length > 3) {
      final countText = TextSpan(
        text: '+${stars.length - 3}',
        style: const TextStyle(
          fontSize: 9,
          color: AppColors.darkTextSecondary,
          fontWeight: FontWeight.w600,
        ),
      );

      final textPainter = TextPainter(
        text: countText,
        textDirection: TextDirection.ltr,
      )..layout();

      final textOffset = Offset(
        palaceCenter.dx + 22,
        palaceCenter.dy + 12,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  /// Draw palace element indicator
  void _drawPalaceElement(
    Canvas canvas,
    Offset palaceCenter,
    PalaceData palace,
    double palaceSize,
  ) {
    final elementOffset = Offset(
      palaceCenter.dx,
      palaceCenter.dy - palaceSize * 0.25,
    );

    // Element background circle
    final elementBgPaint = Paint()
      ..color = AppColors.darkBorder.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      elementOffset,
      6,
      elementBgPaint,
    ); // Smaller element indicator

    // Element text
    final elementText = TextSpan(
      text: palace.element,
      style: const TextStyle(
        fontFamily: AppConstants.chineseFont,
        fontSize: 8, // Smaller font size for element
        fontWeight: FontWeight.w700,
        color: AppColors.lightPurple,
      ),
    );

    final elementTextPainter = TextPainter(
      text: elementText,
      textDirection: TextDirection.ltr,
    )..layout();

    final elementTextOffset = Offset(
      elementOffset.dx - elementTextPainter.width / 2,
      elementOffset.dy - elementTextPainter.height / 2,
    );

    elementTextPainter.paint(canvas, elementTextOffset);
  }

  /// Get enhanced color for star based on category
  Color _getStarColor(StarData star) {
    switch (star.category) {
      case '主星':
        return AppColors.lightPurple;
      case '吉星':
        return AppColors.emerald;
      case '凶星':
        return AppColors.cinnabar;
      default:
        return AppColors.lightGold;
    }
  }

  /// Draw enhanced center element with sophisticated design
  void _drawEnhancedCenter(Canvas canvas, Offset center) {
    // Save canvas state for rotation
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(rotationAnimation.value);

    // Draw outer glow ring
    final outerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.lightPurple.withValues(alpha: glowAnimation.value * 0.4),
          AppColors.lightGold.withValues(alpha: glowAnimation.value * 0.2),
          Colors.transparent,
        ],
      ).createShader(const Rect.fromLTWH(-25, -25, 50, 50));

    canvas.drawCircle(Offset.zero, 25, outerGlowPaint);

    // Draw main center circle with gradient
    final centerPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          AppColors.lightPurple,
          AppColors.primaryPurple,
          AppColors.darkPurple,
        ],
        stops: [0.0, 0.7, 1.0],
      ).createShader(const Rect.fromLTWH(-20, -20, 40, 40));

    canvas.drawCircle(Offset.zero, 20, centerPaint);

    // Draw inner circle
    final innerPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          AppColors.lightGold,
          AppColors.primaryGold,
        ],
      ).createShader(const Rect.fromLTWH(-12, -12, 24, 24));

    canvas.drawCircle(Offset.zero, 12, innerPaint);

    // Draw central symbol
    final symbolPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, 6, symbolPaint);

    // Draw decorative elements with enhanced styling
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final lineStart = Offset(
        math.cos(angle) * 10,
        math.sin(angle) * 10,
      );
      final lineEnd = Offset(
        math.cos(angle) * 16,
        math.sin(angle) * 16,
      );

      final decorativePaint = Paint()
        ..shader = const LinearGradient(
          colors: [
            AppColors.lightGold,
            AppColors.primaryGold,
          ],
        ).createShader(Rect.fromPoints(lineStart, lineEnd))
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(lineStart, lineEnd, decorativePaint);
    }

    // Restore canvas state
    canvas.restore();
  }

  /// Draw connection lines between palaces
  void _drawPalaceConnections(Canvas canvas, Offset center, double radius) {
    final connectionPaint = Paint()
      ..color = AppColors.lightPurple.withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    // Draw connections between adjacent palaces
    for (var i = 0; i < 12; i++) {
      final angle1 = (i * 30 - 90) * math.pi / 180;
      final angle2 = ((i + 1) * 30 - 90) * math.pi / 180;

      final point1 = Offset(
        center.dx + math.cos(angle1) * (radius * 0.85),
        center.dy + math.sin(angle1) * (radius * 0.85),
      );
      final point2 = Offset(
        center.dx + math.cos(angle2) * (radius * 0.85),
        center.dy + math.sin(angle2) * (radius * 0.85),
      );

      canvas.drawLine(point1, point2, connectionPaint);
    }
  }

  @override
  bool shouldRepaint(EnhancedAstroChartPainter oldDelegate) {
    return oldDelegate.selectedPalaceIndex != selectedPalaceIndex ||
        oldDelegate.showStarDetails != showStarDetails ||
        oldDelegate.showChineseNames != showChineseNames;
  }

  @override
  bool hitTest(Offset position) => true;
}
