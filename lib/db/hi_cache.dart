// 缓存 单例模式
import 'package:shared_preferences/shared_preferences.dart';

class HiCache {
  SharedPreferences? prefs;
  static HiCache? _instance;

  // 初始化
  HiCache._() {
    init();
  }
  // 预初始化
  HiCache._pre(SharedPreferences prefsInstance) {
    prefs = prefsInstance;
  }
  // 获取实例
  static HiCache getInstance() {
    _instance ??= HiCache._();
    return _instance!;
  }

  // 为了避免没有实例然后执行Init获取实例，因为异步可能导致的问题
  // 所以提供一个预初始化的方法
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }

  // 初始化
  void init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  setBool(String key, bool value) {
    return prefs?.setBool(key, value);
  }

  setInt(String key, int value) {
    return prefs?.setInt(key, value);
  }

  setDouble(String key, double value) {
    return prefs?.setDouble(key, value);
  }

  setString(String key, String value) {
    return prefs?.setString(key, value);
  }

  setStringList(String key, List<String> value) {
    return prefs?.setStringList(key, value);
  }

  remove(String key) {
    prefs?.remove(key);
  }

  // get方法就不再一一举出，通过泛型的方式来简化代码，提高通用性
  // 可以获取任意类型的数据
  // getBool(String key) {
  //   return prefs.get(key);
  // }
  T get<T>(String key) {
    return prefs?.get(key) as T;
  }
}
