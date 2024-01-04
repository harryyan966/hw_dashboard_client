abstract class Cacher {
  Future<void> setCache(String key, String value);

  Future<void> removeCache(String key);

  Future<String?> getCache(String key);
}
