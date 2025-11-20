import 'dart:math';

import 'package:flutter/material.dart';

/// [ParticleBackground] - Animated particle background with floating particles
/// Creates an immersive, dynamic background effect
class ParticleBackground extends StatefulWidget {
  /// Constructor for ParticleBackground
  /// [particleCount] - Number of particles to display
  /// [particleColor] - Color of the particles
  /// [particleSize] - Size range of particles
  /// [speed] - Animation speed multiplier
  /// [enableParallax] - Enable parallax scrolling effect
  const ParticleBackground({
    super.key,
    this.particleCount = 50,
    this.particleColor = Colors.white,
    this.particleSize = const Size(2, 4),
    this.speed = 1.0,
    this.enableParallax = true,
  });

  final int particleCount;
  final Color particleColor;
  final Size particleSize;
  final double speed;
  final bool enableParallax;

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        position: Offset(
          _random.nextDouble(),
          _random.nextDouble(),
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 0.0005 * widget.speed,
          (_random.nextDouble() - 0.5) * 0.0005 * widget.speed,
        ),
        size: widget.particleSize.width +
            _random.nextDouble() *
                (widget.particleSize.height - widget.particleSize.width),
        opacity: 0.3 + _random.nextDouble() * 0.4,
      ),
    );

    _controller.addListener(() {
      setState(() {
        for (final particle in _particles) {
          particle.update();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(
        particles: _particles,
        color: widget.particleColor,
      ),
      child: Container(),
    );
  }
}

/// [Particle] - Individual particle data
class Particle {
  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
  });

  Offset position;
  Offset velocity;
  double size;
  double opacity;

  void update() {
    position += velocity;

    // Wrap around screen edges
    if (position.dx < 0) position = Offset(1, position.dy);
    if (position.dx > 1) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, 1);
    if (position.dy > 1) position = Offset(position.dx, 0);
  }
}

/// [ParticlePainter] - Custom painter for rendering particles
class ParticlePainter extends CustomPainter {
  ParticlePainter({
    required this.particles,
    required this.color,
  });

  final List<Particle> particles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      final position = Offset(
        particle.position.dx * size.width,
        particle.position.dy * size.height,
      );

      // Draw particle as a circle
      canvas.drawCircle(position, particle.size, paint);

      // Draw subtle glow
      final glowPaint = Paint()
        ..color = color.withValues(alpha: particle.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(position, particle.size * 1.5, glowPaint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
