import 'package:bible_app/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

final String apiKey = dotenv.env['API_KEY']!;

class ApiHelper {
  // Helper function for making HTTP GET request
  static Future<dynamic> _makeHttpGetRequest(
    String url,
    String logString,
  ) async {
    print('$logString');
    final response = await http.get(
      Uri.parse(url),
      headers: {"api-key": apiKey, "Accept-Encoding": "gzip"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception("Failed to load data from $url");
    }
  }

  // Cached API call for single objects
  static Future<T> cachedApiCallSingle<T>({
    required String url,
    required String cacheKey,
    required String logString,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    // Check cache first
    String? cachedData = SharedPreferencesHelper.getString(cacheKey);
    if (cachedData != null) {
      print('CACHED - $logString');
      return fromJson(jsonDecode(cachedData) as Map<String, dynamic>);
    }

    // Cache miss - make API call
    final dynamic data = await _makeHttpGetRequest(url, logString);

    // Store in cache
    print('SAVING TO CACHE');
    await SharedPreferencesHelper.saveString(cacheKey, jsonEncode(data));

    return fromJson(data as Map<String, dynamic>);
  }

  // Cached API call for lists
  static Future<List<T>> cachedApiCallList<T>({
    required String url,
    required String cacheKey,
    required String logString,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    // Check cache first
    List<dynamic>? cachedData = SharedPreferencesHelper.getList(cacheKey);
    if (cachedData != null) {
      print('CACHED - $logString');
      return cachedData
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Cache miss - make API call
    final List<dynamic> data = await _makeHttpGetRequest(url, logString);

    // Store in cache
    print('SAVING TO CACHE');
    await SharedPreferencesHelper.saveList(cacheKey, data);

    return data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }
}
