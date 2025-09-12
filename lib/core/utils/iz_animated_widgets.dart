import 'dart:ui' show lerpDouble;

import 'package:astro_iztro/core/utils/iz_animation_durations.dart';
import 'package:flutter/material.dart';

/// ==============================================
/// IZ Animated Widgets
/// ----------------------------------------------
/// Reusable animated building blocks for
/// micro-interactions and transitions.
///
/// ==============================================
/// Fades its child in using an [AnimationController].
class IzFadeIn extends StatelessWidget {
  const IzFadeIn({
    required this.child,
    super.key,
    this.duration = IzAnimDurations.standard,
    this.curve = IzAnimCurves.easeOut,
    this.delay = Duration.zero,
    this.begin = 0.0,
    this.alwaysIncludeSemantics = true,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final double begin;
  final bool alwaysIncludeSemantics;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: 1),
      duration: duration + delay,
      curve: Interval(
        delay.inMilliseconds == 0
            ? 0
            : delay.inMilliseconds / (duration + delay).inMilliseconds,
        1,
        curve: curve,
      ),
      builder: (context, value, child) => Opacity(
        opacity: value,
        alwaysIncludeSemantics: alwaysIncludeSemantics,
        child: child,
      ),
      child: child,
    );
  }
}

/// Slides and fades the child from a given offset.
class IzSlideFadeIn extends StatelessWidget {
  const IzSlideFadeIn({
    required this.child,
    super.key,
    this.offset = const Offset(0, 16),
    this.duration = IzAnimDurations.standard,
    this.curve = IzAnimCurves.easeOut,
    this.delay = Duration.zero,
    this.opacityBegin = 0.0,
  });

  final Widget child;
  final Offset offset;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final double opacityBegin;

  @override
  Widget build(BuildContext context) {
    final total = duration + delay;
    final start = delay.inMilliseconds /
        (total.inMilliseconds == 0 ? 1 : total.inMilliseconds);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(start, 1, curve: curve),
      builder: (context, t, child) {
        final dy = (1 - t) * offset.dy;
        final dx = (1 - t) * offset.dx;
        return Opacity(
          opacity: opacityBegin + (1 - opacityBegin) * t,
          child: Transform.translate(
            offset: Offset(dx, dy),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Scales in the child with optional fade.
class IzScaleIn extends StatelessWidget {
  const IzScaleIn({
    required this.child,
    super.key,
    this.duration = IzAnimDurations.quick,
    this.curve = IzAnimCurves.pop,
    this.scaleBegin = 0.9,
    this.fade = true,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double scaleBegin;
  final bool fade;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: curve,
      builder: (context, t, child) {
        final s = lerpDouble(scaleBegin, 1.0, t)!;
        return Opacity(
          opacity: fade ? t : 1.0,
          child: Transform.scale(
            scale: s,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Staggered list item builder that applies slide+fade for each item.
class IzStaggeredList extends StatelessWidget {
  const IzStaggeredList({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.baseOffset = const Offset(0, 16),
    this.durationPerItem = IzAnimDurations.quick,
    this.staggerOverlap = 0.15,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Offset baseOffset;
  final Duration durationPerItem;
  final double staggerOverlap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final delayMs =
            (index * durationPerItem.inMilliseconds * (1 - staggerOverlap))
                .round();
        return IzSlideFadeIn(
          delay: Duration(milliseconds: delayMs),
          duration: durationPerItem,
          offset: baseOffset,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Tap-scale interaction wrapper with subtle scale feedback.
class IzTapScale extends StatefulWidget {
  const IzTapScale({
    required this.child,
    super.key,
    this.onTap,
    this.pressScale = 0.97,
    this.durationDown = IzAnimDurations.micro,
    this.durationUp = IzAnimDurations.quick,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.enableHaptics = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressScale;
  final Duration durationDown;
  final Duration durationUp;
  final HitTestBehavior hitTestBehavior;
  final bool enableHaptics;

  @override
  State<IzTapScale> createState() => _IzTapScaleState();
}

class _IzTapScaleState extends State<IzTapScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    value: 0,
    duration: widget.durationDown,
    reverseDuration: widget.durationUp,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _controller
      ..duration = widget.durationDown
      ..forward();
  }

  void _onTapCancel() {
    _controller
      ..reverseDuration = widget.durationUp
      ..reverse();
  }

  void _onTapUp(_) {
    _onTapCancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.hitTestBehavior,
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTapUp: _onTapUp,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final scale = lerpDouble(1.0, widget.pressScale, t)!;
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
