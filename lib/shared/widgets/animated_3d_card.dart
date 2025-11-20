import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// [Animated3DCard] - A modern 3D card widget with perspective transformations
/// Provides depth and interactive animations for a premium feel
class Animated3DCard extends StatefulWidget {
  /// Constructor for Animated3DCard
  /// [child] - The widget to display inside the card
  /// [width] - Card width
  /// [height] - Card height
  /// [depth] - 3D depth effect intensity (0.0 to 1.0)
  /// [enableTilt] - Enable tilt animation on hover/tap
  /// [shadowColor] - Color of the 3D shadow
  /// [borderRadius] - Border radius of the card
  /// [onTap] - Callback when card is tapped
  const Animated3DCard({
    required this.child,
    super.key,
    this.width,
    this.height,
    this.depth = 0.5,
    this.enableTilt = true,
    this.shadowColor = Colors.black,
    this.borderRadius = 16.0,
    this.onTap,
  });

  final Widget child;
  final double? width;
  final double? height;
  final double depth;
  final bool enableTilt;
  final Color shadowColor;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  State<Animated3DCard> createState() => _Animated3DCardState();
}

class _Animated3DCardState extends State<Animated3DCard> {
  bool _isHovered = false;
  Offset _tiltOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _tiltOffset = Offset.zero;
        });
      },
      onHover: (event) {
        if (!widget.enableTilt) return;
        final size = context.size;
        if (size == null) return;

        final dx = (event.localPosition.dx - size.width / 2) / size.width;
        final dy = (event.localPosition.dy - size.height / 2) / size.height;

        setState(() {
          _tiltOffset = Offset(dx, dy);
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onPanUpdate: (details) {
          if (!widget.enableTilt) return;
          final size = context.size;
          if (size == null) return;

          final dx = (details.localPosition.dx - size.width / 2) / size.width;
          final dy = (details.localPosition.dy - size.height / 2) / size.height;

          setState(() {
            _tiltOffset = Offset(dx, dy);
          });
        },
        onPanEnd: (_) {
          setState(() {
            _tiltOffset = Offset.zero;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          transform: _buildTransform(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: _buildShadows(),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: widget.child,
            ),
          ),
        ),
      ),
    )
        .animate(target: _isHovered ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.02, 1.02),
          duration: 200.ms,
        )
        .shimmer(
          duration: 1500.ms,
          color: Colors.white.withValues(alpha: 0.1),
        );
  }

  Matrix4 _buildTransform() {
    final rotationX = _tiltOffset.dy * 0.1 * widget.depth;
    final rotationY = -_tiltOffset.dx * 0.1 * widget.depth;

    return Matrix4.identity()
      ..setEntry(3, 2, 0.001) // perspective
      ..rotateX(rotationX)
      ..rotateY(rotationY);
  }

  List<BoxShadow> _buildShadows() {
    final baseElevation = _isHovered ? 20.0 : 10.0;
    final offsetX = _tiltOffset.dx * 10;
    final offsetY = _tiltOffset.dy * 10 + baseElevation;

    return [
      BoxShadow(
        color: widget.shadowColor.withValues(alpha: 0.2),
        blurRadius: baseElevation * 2,
        offset: Offset(offsetX, offsetY),
      ),
      BoxShadow(
        color: widget.shadowColor.withValues(alpha: 0.1),
        blurRadius: baseElevation,
        offset: Offset(offsetX / 2, offsetY / 2),
      ),
    ];
  }
}
