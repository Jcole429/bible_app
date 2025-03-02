import 'dart:convert';
import 'package:flutter_tutorial/models/bible_version.dart';
import 'package:flutter_tutorial/models/book.dart';
import 'package:flutter_tutorial/models/chapter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = "https://api.scripture.api.bible/v1";
  final String apiKey = dotenv.env['API_KEY']!;

  Future<List<BibleVersion>> fetchBibleVersions(String languageId) async {
    final response = await http.get(
      // Uri.parse(
      //   '$baseUrl/bibles?language=$languageId&include-full-details=true',
      // ),
      Uri.parse('$baseUrl/bibles?&include-full-details=true'),
      headers: {"api-key": apiKey},
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

  Future<List<Book>> fetchBibleBooks(String bibleVersionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bibles/$bibleVersionId/books?include-chapters=true'),
      headers: {"api-key": apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      final List<Book> books = [];

      for (int i = 0; i < data.length; i++) {
        books.add(Book.fromJson(data[i]));
      }

      return books;
    } else {
      throw Exception("Failed to load bible books");
    }
  }

  Future<List<Chapter>> fetchBibleChapters(String bibleVersionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bibles/$bibleVersionId/books'),
      headers: {"api-key": apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      final List<Chapter> chapters = [];

      for (int i = 0; i < data.length; i++) {
        chapters.add(Chapter.fromJson(data[i]));
      }
      return chapters;
    } else {
      throw Exception("Failed to load bible books");
    }
  }

  Future<Chapter> fetchBibleChapter(
    String bibleVersionId,
    String chapterId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bibles/$bibleVersionId/chapters/$chapterId'),
      headers: {"api-key": apiKey},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body)['data'];
      final Chapter chapter = Chapter.fromJson(data);

      return chapter;
    } else {
      throw Exception("Failed to load bible books");
    }
  }
}
