import 'package:flutter/animation.dart';

/// ==============================================
/// IZ Animations — Durations & Curves
/// ----------------------------------------------
/// Centralized durations and curves used by the
/// app's micro-interactions and transitions.
/// ==============================================
class IzAnimDurations {
  IzAnimDurations._();

  /// Very fast tap feedback or tiny state changes.
  static const Duration micro = Duration(milliseconds: 90);

  /// Quick UI responses (button hovers, small fades).
  static const Duration quick = Duration(milliseconds: 180);

  /// Default motion for most transitions.
  static const Duration standard = Duration(milliseconds: 300);

  /// Larger content transitions (lists, route content).
  static const Duration emphatic = Duration(milliseconds: 450);

  /// Heroic / complex sequences (rarely used).
  static const Duration epic = Duration(milliseconds: 700);
}

class IzAnimCurves {
  IzAnimCurves._();

  /// Smooth ease that feels natural for enter motions.
  static const Curve easeOut = Curves.easeOutCubic;

  /// Balanced curve for most property changes.
  static const Curve standard = Curves.easeInOutCubic;

  /// Snappy exit, great for dismissals.
  static const Curve easeIn = Curves.easeInCubic;

  /// Aggressive springy pop for small elements.
  static const Curve pop = Curves.easeOutBack;
}

/// Utility to derive an Interval for staggered animations.
Interval izStaggerInterval({
  required int index,
  required int itemCount,
  double start = 0.0,
  double end = 1.0,
  double overlap = 0.15,
}) {
  assert(itemCount > 0, 'itemCount must be > 0');
  final span = (end - start).clamp(0.0, 1.0);
  final step = (span / itemCount).clamp(0.001, 1.0);
  final s = start + (index * step * (1 - overlap));
  final e = (s + step).clamp(0.0, 1.0);
  return Interval(s, e, curve: IzAnimCurves.easeOut);
}
