import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences once
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save data as String (for JSON storage)
  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  // Retrieve stored JSON data
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Save List of Objects (converted to JSON)
  static Future<void> saveList<T>(String key, List<T> list) async {
    String jsonString = jsonEncode(list);
    await _prefs?.setString(key, jsonString);
  }

  // Retrieve List of Objects (convert JSON back to List)
  static List<dynamic>? getList(String key) {
    String? jsonString = _prefs?.getString(key);
    return jsonString != null ? jsonDecode(jsonString) : null;
  }

  // Clear cache
  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
