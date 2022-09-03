import 'package:get_storage/get_storage.dart';

class CacheStorage {
  CacheStorage._();
  static final _box = GetStorage();

  static Future<void> save(String key, dynamic value) async {
    await _box.write(key, value);
  }

  static dynamic get(String key) {
    return _box.read(key);
  }

  static Future<void> remove(String key) async {
    await _box.remove(key);
  }

  static Future<void> erase() async {
    await _box.erase();
  }
}
