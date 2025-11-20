import 'package:flutter/material.dart';

/// [AnimatedGradientBackground] - Animated gradient background with smooth transitions
/// Provides dynamic, immersive backgrounds with multiple preset themes
class AnimatedGradientBackground extends StatefulWidget {
  /// Constructor for AnimatedGradientBackground
  /// [preset] - Predefined gradient theme
  /// [customColors] - Custom gradient colors (overrides preset)
  /// [animationDuration] - Duration for color transitions
  /// [child] - Widget to display on top of the background
  const AnimatedGradientBackground({
    super.key,
    this.preset = GradientPreset.cosmic,
    this.customColors,
    this.animationDuration = const Duration(seconds: 10),
    this.child,
  });

  final GradientPreset preset;
  final List<Color>? customColors;
  final Duration animationDuration;
  final Widget? child;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.customColors ?? _getPresetColors(widget.preset);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
              stops: [
                0.0,
                _animation.value * 0.5,
                _animation.value,
                1.0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }

  List<Color> _getPresetColors(GradientPreset preset) {
    switch (preset) {
      case GradientPreset.cosmic:
        return [
          const Color(0xFF0F0C29),
          const Color(0xFF302B63),
          const Color(0xFF24243E),
          const Color(0xFF0F0C29),
        ];
      case GradientPreset.mystical:
        return [
          const Color(0xFF1A1A2E),
          const Color(0xFF16213E),
          const Color(0xFF0F3460),
          const Color(0xFF1A1A2E),
        ];
      case GradientPreset.aurora:
        return [
          const Color(0xFF2E1F3D),
          const Color(0xFF3D2C5C),
          const Color(0xFF4A3B6B),
          const Color(0xFF2E1F3D),
        ];
      case GradientPreset.deepSpace:
        return [
          const Color(0xFF000000),
          const Color(0xFF1A1A2E),
          const Color(0xFF16213E),
          const Color(0xFF000000),
        ];
      case GradientPreset.twilight:
        return [
          const Color(0xFF232526),
          const Color(0xFF414345),
          const Color(0xFF2C3E50),
          const Color(0xFF232526),
        ];
    }
  }
}

/// [GradientPreset] - Predefined gradient themes
enum GradientPreset {
  /// Deep purple and blue cosmic theme
  cosmic,

  /// Dark mystical purple theme
  mystical,

  /// Aurora-inspired purple theme
  aurora,

  /// Deep space black and purple theme
  deepSpace,

  /// Twilight gray and blue theme
  twilight,
}
