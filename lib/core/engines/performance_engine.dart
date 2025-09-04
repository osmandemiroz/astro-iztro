/// [PerformanceEngine] - Performance optimization and caching engine
/// Implements intelligent caching, memoization, and performance monitoring
/// Production-ready implementation for optimized astrological calculations

library;

import 'package:flutter/foundation.dart' show kDebugMode;

/// [PerformanceEngine] - Core performance optimization engine for all calculations
class PerformanceEngine {
  /// [CalculationCache] - Intelligent cache for calculation results
  static final Map<String, dynamic> _calculationCache = {};

  /// [MemoizationCache] - Memoization cache for expensive calculations
  static final Map<String, dynamic> _memoizationCache = {};

  /// [PerformanceMetrics] - Performance tracking and analytics
  static final Map<String, List<double>> _performanceMetrics = {};

  /// [CacheStats] - Cache statistics and hit rates
  static final Map<String, int> _cacheStats = {
    'hits': 0,
    'misses': 0,
    'total': 0,
  };

  /// [getCachedResult] - Retrieve cached calculation result
  static dynamic getCachedResult(String cacheKey) {
    try {
      if (kDebugMode) {
        print('[PerformanceEngine] Checking cache for key: $cacheKey');
      }

      _cacheStats['total'] = (_cacheStats['total'] ?? 0) + 1;

      if (_calculationCache.containsKey(cacheKey)) {
        _cacheStats['hits'] = (_cacheStats['hits'] ?? 0) + 1;

        if (kDebugMode) {
          print('[PerformanceEngine] Cache HIT for key: $cacheKey');
        }

        return _calculationCache[cacheKey];
      } else {
        _cacheStats['misses'] = (_cacheStats['misses'] ?? 0) + 1;

        if (kDebugMode) {
          print('[PerformanceEngine] Cache MISS for key: $cacheKey');
        }

        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Cache retrieval error: $e');
      }
      return null;
    }
  }

  /// [cacheResult] - Store calculation result in cache
  static void cacheResult(
    String cacheKey,
    dynamic result, {
    Duration? expiration,
  }) {
    try {
      if (kDebugMode) {
        print('[PerformanceEngine] Caching result for key: $cacheKey');
      }

      final cacheEntry = {
        'result': result,
        'timestamp': DateTime.now(),
        'expiration': expiration ?? const Duration(hours: 24),
      };

      _calculationCache[cacheKey] = cacheEntry;

      // Clean up expired cache entries
      _cleanupExpiredCache();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Cache storage error: $e');
      }
    }
  }

  /// [getMemoizedResult] - Retrieve memoized calculation result
  static dynamic getMemoizedResult(String memoKey) {
    try {
      if (kDebugMode) {
        print('[PerformanceEngine] Checking memoization for key: $memoKey');
      }

      if (_memoizationCache.containsKey(memoKey)) {
        if (kDebugMode) {
          print('[PerformanceEngine] Memoization HIT for key: $memoKey');
        }
        return _memoizationCache[memoKey];
      }

      if (kDebugMode) {
        print('[PerformanceEngine] Memoization MISS for key: $memoKey');
      }

      return null;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Memoization retrieval error: $e');
      }
      return null;
    }
  }

  /// [memoizeResult] - Store calculation result in memoization cache
  static void memoizeResult(String memoKey, dynamic result) {
    try {
      if (kDebugMode) {
        print('[PerformanceEngine] Memoizing result for key: $memoKey');
      }

      _memoizationCache[memoKey] = result;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Memoization storage error: $e');
      }
    }
  }

  /// [measurePerformance] - Measure and track calculation performance
  static T measurePerformance<T>(String operationName, T Function() operation) {
    final stopwatch = Stopwatch()..start();

    try {
      final result = operation();
      stopwatch.stop();

      final duration =
          stopwatch.elapsedMicroseconds / 1000.0; // Convert to milliseconds

      // Track performance metrics
      if (!_performanceMetrics.containsKey(operationName)) {
        _performanceMetrics[operationName] = [];
      }
      _performanceMetrics[operationName]!.add(duration);

      if (kDebugMode) {
        print(
          '[PerformanceEngine] $operationName completed in ${duration.toStringAsFixed(2)}ms',
        );
      }

      return result;
    } on Exception catch (e) {
      stopwatch.stop();

      if (kDebugMode) {
        print(
          '[PerformanceEngine] $operationName failed after ${stopwatch.elapsedMicroseconds / 1000.0}ms: $e',
        );
      }

      rethrow;
    }
  }

  /// [generateCacheKey] - Generate unique cache key for calculations
  static String generateCacheKey(
    String operation,
    Map<String, dynamic> parameters,
  ) {
    try {
      // Sort parameters for consistent key generation
      final sortedParams = Map.fromEntries(
        parameters.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );

      // Create a hash-based key for efficiency
      final keyString = '$operation:$sortedParams';
      return keyString.hashCode.toString();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Cache key generation error: $e');
      }

      // Fallback to simple key
      return '$operation:${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// [clearCache] - Clear all cached results
  static void clearCache() {
    try {
      if (kDebugMode) {
        print('[PerformanceEngine] Clearing calculation cache');
      }

      _calculationCache.clear();
      _memoizationCache.clear();
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Cache clearing error: $e');
      }
    }
  }

  /// [getCacheStats] - Get cache performance statistics
  static Map<String, dynamic> getCacheStats() {
    try {
      final total = _cacheStats['total'] ?? 0;
      final hits = _cacheStats['hits'] ?? 0;
      final misses = _cacheStats['misses'] ?? 0;
      final hitRate = total > 0 ? (hits / total * 100) : 0.0;

      return {
        'totalRequests': total,
        'cacheHits': hits,
        'cacheMisses': misses,
        'hitRate': '${hitRate.toStringAsFixed(2)}%',
        'cacheSize': _calculationCache.length,
        'memoizationSize': _memoizationCache.length,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Stats retrieval error: $e');
      }
      return {};
    }
  }

  /// [getPerformanceMetrics] - Get detailed performance metrics
  static Map<String, dynamic> getPerformanceMetrics() {
    try {
      final metrics = <String, dynamic>{};

      _performanceMetrics.forEach((operation, durations) {
        if (durations.isNotEmpty) {
          final avgDuration =
              durations.reduce((a, b) => a + b) / durations.length;
          final minDuration = durations.reduce((a, b) => a < b ? a : b);
          final maxDuration = durations.reduce((a, b) => a > b ? a : b);

          metrics[operation] = {
            'average': '${avgDuration.toStringAsFixed(2)}ms',
            'minimum': '${minDuration.toStringAsFixed(2)}ms',
            'maximum': '${maxDuration.toStringAsFixed(2)}ms',
            'count': durations.length,
          };
        }
      });

      return {
        'operations': metrics,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Metrics retrieval error: $e');
      }
      return {};
    }
  }

  /// [optimizeCalculation] - Optimize calculation with caching and memoization
  static T optimizeCalculation<T>({
    required String operationName,
    required Map<String, dynamic> parameters,
    required T Function() calculation,
    bool useCache = true,
    bool useMemoization = true,
    Duration? cacheExpiration,
  }) {
    try {
      if (kDebugMode) {
        print('[PerformanceEngine] Optimizing calculation: $operationName');
      }

      // Check memoization first (for expensive, deterministic calculations)
      if (useMemoization) {
        final memoKey = 'memo:$operationName:${parameters.toString().hashCode}';
        final memoizedResult = getMemoizedResult(memoKey);

        if (memoizedResult != null) {
          if (kDebugMode) {
            print(
              '[PerformanceEngine] Using memoized result for $operationName',
            );
          }
          return memoizedResult as T;
        }
      }

      // Check cache for recent calculations
      if (useCache) {
        final cacheKey = generateCacheKey(operationName, parameters);
        final cachedResult = getCachedResult(cacheKey);

        if (cachedResult != null) {
          if (kDebugMode) {
            print('[PerformanceEngine] Using cached result for $operationName');
          }
          final resultMap = cachedResult as Map<String, dynamic>;
          return resultMap['result'] as T;
        }
      }

      // Perform calculation with performance measurement
      final result = measurePerformance(operationName, calculation);

      // Store results in appropriate caches
      if (useMemoization) {
        final memoKey = 'memo:$operationName:${parameters.toString().hashCode}';
        memoizeResult(memoKey, result);
      }

      if (useCache) {
        final cacheKey = generateCacheKey(operationName, parameters);
        cacheResult(cacheKey, result, expiration: cacheExpiration);
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Optimization error for $operationName: $e');
      }
      rethrow;
    }
  }

  /// [_cleanupExpiredCache] - Remove expired cache entries
  static void _cleanupExpiredCache() {
    try {
      final now = DateTime.now();
      final expiredKeys = <String>[];

      _calculationCache.forEach((key, entry) {
        final entryMap = entry as Map<String, dynamic>;
        final timestamp = entryMap['timestamp'] as DateTime;
        final expiration = entryMap['expiration'] as Duration;

        if (now.difference(timestamp) > expiration) {
          expiredKeys.add(key);
        }
      });

      for (final key in expiredKeys) {
        _calculationCache.remove(key);
      }

      if (expiredKeys.isNotEmpty && kDebugMode) {
        if (kDebugMode) {
          print(
            '[PerformanceEngine] Cleaned up ${expiredKeys.length} expired cache entries',
          );
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Cache cleanup error: $e');
      }
    }
  }

  /// [preloadCache] - Preload cache with common calculations
  static void preloadCache() {
    try {
      if (kDebugMode) {
        print('[PerformanceEngine] Preloading cache with common calculations');
      }

      // Preload common lunar calendar calculations
      final commonDates = [
        DateTime.now(),
        DateTime.now().add(const Duration(days: 1)),
        DateTime.now().add(const Duration(days: 7)),
        DateTime.now().add(const Duration(days: 30)),
      ];

      for (final date in commonDates) {
        final cacheKey = generateCacheKey('lunar_date', {
          'year': date.year,
          'month': date.month,
          'day': date.day,
        });

        // Store placeholder for preloading
        cacheResult(cacheKey, null, expiration: const Duration(hours: 1));
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[PerformanceEngine] Cache preloading error: $e');
      }
    }
  }
}
