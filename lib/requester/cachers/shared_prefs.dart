import 'package:hw_dashboard_client/requester/cachers/cacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsCacher implements Cacher {
  SharedPrefsCacher({
    required SharedPreferences cacher,
  }) : _cacher = cacher;

  final SharedPreferences _cacher;

  @override
  Future<String?> getCache(String key) async {
    return _cacher.getString(key);
  }

  @override
  Future<void> setCache(String key, String value) async {
    await _cacher.setString(key, value);
  }

  @override
  Future<void> removeCache(String key) async {
    await _cacher.remove(key);
  }
}
