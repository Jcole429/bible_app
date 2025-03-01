import 'dart:convert';
import 'package:flutter_tutorial/models/bible_version.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.scripture.api.bible/v1";

  Future<List<BibleVersion>> fetchBibleVersions(String languageId) async {
    final response = await http.get(
      // Uri.parse(
      //   '$baseUrl/bibles?language=$languageId&include-full-details=true',
      // ),
      Uri.parse('$baseUrl/bibles?&include-full-details=true'),
      headers: {"api-key": "b30ca5e2d584010694eb2747ac25c1e1"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      final List<BibleVersion> bibleVersions = [];

      for (int i = 0; i < data.length; i++) {
        bibleVersions.add(BibleVersion.fromJson(data[i]));
      }

      return bibleVersions;
    } else {
      throw Exception("Failed to load bible versions");
    }
  }

  Future<List<dynamic>> fetchBibleBooks(String bibleVersionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bibles/$bibleVersionId/books'),
      headers: {"api-key": "b30ca5e2d584010694eb2747ac25c1e1"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data;
    } else {
      throw Exception("Failed to load bible books");
    }
  }
}
