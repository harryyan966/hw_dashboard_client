import 'package:hw_dashboard_client/requester/cachers/cacher.dart';

class InMemoryCacher implements Cacher {
  final _cache = <String, String>{};

  @override
  Future<String?> getCache(String key) async {
    return _cache[key];
  }

  @override
  Future<void> setCache(String key, String value) async {
    _cache[key] = value;
  }

  @override
  Future<void> removeCache(String key) async {
    _cache.remove(key);
  }
}
