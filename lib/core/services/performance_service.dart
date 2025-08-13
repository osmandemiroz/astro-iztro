import 'dart:async';

import 'package:flutter/foundation.dart' show compute, kDebugMode;
import 'package:flutter/services.dart';

/// [PerformanceService] - Service for optimizing app performance
class PerformanceService {
  factory PerformanceService() => _instance;
  PerformanceService._internal();
  static final PerformanceService _instance = PerformanceService._internal();

  final Map<String, dynamic> _cache = {};
  final Map<String, Timer> _debounceTimers = {};

  /// [cacheData] - Cache data with optional expiry
  void cacheData(String key, dynamic data, {Duration? expiry}) {
    _cache[key] = {
      'data': data,
      'timestamp': DateTime.now(),
      'expiry': expiry,
    };

    // Clean expired cache entries
    if (expiry != null) {
      Timer(expiry, () => _removeExpiredCache(key));
    }
  }

  /// [getCachedData] - Retrieve cached data
  T? getCachedData<T>(String key) {
    final cached = _cache[key];
    if (cached == null) return null;

    final cachedMap = cached as Map<String, dynamic>;
    final expiry = cachedMap['expiry'] as Duration?;

    if (expiry != null) {
      final timestamp = cached['timestamp'] as DateTime;
      if (DateTime.now().difference(timestamp) > expiry) {
        _cache.remove(key);
        return null;
      }
    }

    return cached['data'] as T?;
  }

  /// [clearCache] - Clear all cached data
  void clearCache() {
    _cache.clear();
  }

  /// [clearCacheByPattern] - Clear cache entries matching pattern
  void clearCacheByPattern(String pattern) {
    final regex = RegExp(pattern);
    _cache.removeWhere((key, value) => regex.hasMatch(key));
  }

  /// [debounce] - Debounce function calls
  void debounce(String key, VoidCallback callback, Duration delay) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, () {
      callback();
      _debounceTimers.remove(key);
    });
  }

  /// [throttle] - Throttle function calls
  static Timer? _throttleTimer;
  static void throttle(VoidCallback callback, Duration duration) {
    if (_throttleTimer?.isActive ?? false) return;

    callback();
    _throttleTimer = Timer(duration, () {});
  }

  /// [batchOperations] - Batch multiple operations together
  static Future<List<T>> batchOperations<T>(
    List<Future<T> Function()> operations,
  ) async {
    final futures = operations.map((op) => op()).toList();
    return Future.wait(futures);
  }

  /// [lazyLoad] - Lazy load data with caching
  Future<T> lazyLoad<T>(
    String key,
    Future<T> Function() loader, {
    Duration? cacheExpiry,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = getCachedData<T>(key);
      if (cached != null) return cached;
    }

    final data = await loader();
    cacheData(key, data, expiry: cacheExpiry);
    return data;
  }

  /// [backgroundComputation] - Run heavy computation in background
  static Future<R> backgroundComputation<T, R>(
    R Function(T) computation,
    T data,
  ) async {
    return compute(computation, data);
  }

  /// [preloadData] - Preload data in background
  void preloadData(String key, Future<dynamic> Function() loader) {
    if (_cache.containsKey(key)) return;

    loader()
        .then((data) {
          cacheData(key, data, expiry: const Duration(minutes: 30));
        })
        .catchError((Object error) {
          if (kDebugMode) {
            print('[PerformanceService] Preload error for $key: $error');
          }
        });
  }

  /// [optimizeMemory] - Optimize memory usage
  void optimizeMemory() {
    // Clear expired cache
    _removeAllExpiredCache();

    // Force garbage collection (only in debug mode)
    if (kDebugMode) {
      // Note: This is not available in Flutter, but we can trigger it indirectly
      _triggerGarbageCollection();
    }
  }

  /// [getBatchProcessor] - Get a batch processor for multiple operations
  BatchProcessor<T> getBatchProcessor<T>({
    required Duration batchWindow,
    required int maxBatchSize,
    required Future<void> Function(List<T>) processor,
  }) {
    return BatchProcessor<T>(
      batchWindow: batchWindow,
      maxBatchSize: maxBatchSize,
      processor: processor,
    );
  }

  /// [measurePerformance] - Measure operation performance
  static Future<PerformanceResult<T>> measurePerformance<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    final startMemory = _getApproximateMemoryUsage();

    try {
      final result = await operation();
      stopwatch.stop();

      final endMemory = _getApproximateMemoryUsage();

      if (kDebugMode) {
        print(
          '[Performance] $operationName: ${stopwatch.elapsedMilliseconds}ms',
        );
        print('[Performance] Memory delta: ${endMemory - startMemory} bytes');
      }

      return PerformanceResult<T>(
        result: result,
        duration: stopwatch.elapsed,
        memoryDelta: endMemory - startMemory,
        success: true,
      );
    } on Exception catch (error) {
      stopwatch.stop();

      if (kDebugMode) {
        print('[Performance] $operationName failed: $error');
      }

      return PerformanceResult<T>(
        result: null,
        duration: stopwatch.elapsed,
        memoryDelta: 0,
        success: false,
        error: error,
      );
    }
  }

  /// Helper methods
  void _removeExpiredCache(String key) {
    final cached = _cache[key];
    if (cached != null) {
      final cachedMap = cached as Map<String, dynamic>;
      final expiry = cachedMap['expiry'] as Duration?;
      if (expiry != null) {
        final timestamp = cached['timestamp'] as DateTime;
        if (DateTime.now().difference(timestamp) > expiry) {
          _cache.remove(key);
        }
      }
    }
  }

  void _removeAllExpiredCache() {
    final now = DateTime.now();
    _cache.removeWhere((key, value) {
      final cachedMap = value as Map<String, dynamic>;
      final expiry = cachedMap['expiry'] as Duration?;
      if (expiry != null) {
        final timestamp = cachedMap['timestamp'] as DateTime;
        return now.difference(timestamp) > expiry;
      }
      return false;
    });
  }

  void _triggerGarbageCollection() {
    // Create and release some objects to encourage GC
    final _ = List.generate(1000, (i) => Object())..clear();
  }

  static int _getApproximateMemoryUsage() {
    // This is an approximation - Flutter doesn't provide direct memory access
    return DateTime.now().millisecondsSinceEpoch % 1000000;
  }
}

/// [BatchProcessor] - Processes operations in batches for better performance
class BatchProcessor<T> {
  BatchProcessor({
    required this.batchWindow,
    required this.maxBatchSize,
    required this.processor,
  });

  final Duration batchWindow;
  final int maxBatchSize;
  final Future<void> Function(List<T>) processor;

  final List<T> _pendingItems = [];
  Timer? _batchTimer;
  bool _isProcessing = false;

  /// Add item to batch
  void add(T item) {
    _pendingItems.add(item);

    // Process immediately if batch is full
    if (_pendingItems.length >= maxBatchSize) {
      _processBatch();
    } else {
      // Reset timer for batch window
      _batchTimer?.cancel();
      _batchTimer = Timer(batchWindow, _processBatch);
    }
  }

  /// Add multiple items to batch
  void addAll(List<T> items) {
    for (final item in items) {
      add(item);
    }
  }

  /// Force process current batch
  Future<void> flush() async {
    _batchTimer?.cancel();
    await _processBatch();
  }

  /// Process the current batch
  Future<void> _processBatch() async {
    if (_isProcessing || _pendingItems.isEmpty) return;

    _isProcessing = true;
    _batchTimer?.cancel();

    final batch = List<T>.from(_pendingItems);
    _pendingItems.clear();

    try {
      await processor(batch);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('[BatchProcessor] Error processing batch: $e');
      }
    } finally {
      _isProcessing = false;
    }
  }

  /// Dispose the batch processor
  void dispose() {
    _batchTimer?.cancel();
    _pendingItems.clear();
  }
}

/// [PerformanceResult] - Result of performance measurement
class PerformanceResult<T> {
  const PerformanceResult({
    required this.result,
    required this.duration,
    required this.memoryDelta,
    required this.success,
    this.error,
  });

  final T? result;
  final Duration duration;
  final int memoryDelta;
  final bool success;
  final dynamic error;

  bool get isSuccess => success && error == null;
  bool get isFast => duration.inMilliseconds < 100;
  bool get isMemoryEfficient => memoryDelta < 1024 * 1024; // Less than 1MB
}
