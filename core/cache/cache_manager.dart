/// Generic cache manager with expiration support
class CacheManager<T> {
  final Map<String, _CacheEntry<T>> _cache = {};
  final Duration _defaultExpiration;
  final int _maxSize;

  CacheManager({
    Duration defaultExpiration = const Duration(minutes: 3),
    int maxSize = 100,
  })  : _defaultExpiration = defaultExpiration,
        _maxSize = maxSize;

  /// Get value from cache
  T? get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry.value;
  }

  /// Set value in cache
  void set(String key, T value, {Duration? expiration}) {
    if (_cache.length >= _maxSize) {
      _evictOldest();
    }

    _cache[key] = _CacheEntry(
      value: value,
      expiration: expiration ?? _defaultExpiration,
    );
  }

  /// Check if key exists and is not expired
  bool has(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    return true;
  }

  /// Remove specific key
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
  }

  /// Evict oldest entry (LRU)
  void _evictOldest() {
    if (_cache.isEmpty) return;
    final oldestKey = _cache.keys.first;
    _cache.remove(oldestKey);
  }

  /// Remove all expired entries
  void cleanExpired() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }
}

class _CacheEntry<T> {
  final T value;
  final DateTime createdAt;
  final Duration expiration;

  _CacheEntry({
    required this.value,
    required this.expiration,
  }) : createdAt = DateTime.now();

  bool get isExpired => DateTime.now().difference(createdAt) > expiration;
}
