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
    print('fetchBibleVersions(languageId: $languageId)');
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
    print('fetchBibleBooks(bibleVersionId: $bibleVersionId)');

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

  Future<Book> fetchBibleBook(String bibleVersionId, String bibleBookId) async {
    print(
      'fetchBibleBook(bibleVersionId: $bibleVersionId, bibleBookId: $bibleBookId)',
    );

    final response = await http.get(
      Uri.parse('$baseUrl/bibles/$bibleVersionId/books/$bibleBookId'),
      headers: {"api-key": apiKey},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body)['data'];
      final Book book = Book.fromJson(data);

      return book;
    } else {
      throw Exception("Failed to load bible book");
    }
  }

  Future<List<Chapter>> fetchBibleChapters(
    String bibleVersionId,
    String bookId,
  ) async {
    print(
      'fetchBibleChapters(bibleVersionId: $bibleVersionId, bookId: $bookId)',
    );

    final response = await http.get(
      Uri.parse('$baseUrl/bibles/$bibleVersionId/books/$bookId/chapters'),
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
      throw Exception("Failed to load bible chapters");
    }
  }

  Future<Chapter> fetchBibleChapter(
    String bibleVersionId,
    String chapterId, {
    String contentType = "html",
    bool includeNotes = true, // Inline footnotes
    bool includeTitles = true, // The titles of chapter sections
    bool includeChapterNumbers = false, // Display the chapter number
    bool includeVerseNumbers = true,
    bool includeVerseSpans = true,
  }) async {
    String url =
        '$baseUrl/bibles/$bibleVersionId/chapters/$chapterId?content-type=$contentType&include-notes=$includeNotes&include-titles=$includeTitles&include-chapter-numbers=$includeChapterNumbers&include-verse-numbers=$includeVerseNumbers&include-verse-spans=$includeVerseSpans';

    print(
      'fetchBibleChapter(bibleVersionId: $bibleVersionId, chapterId: $chapterId): $url',
    );

    final response = await http.get(
      Uri.parse(url),
      headers: {"api-key": apiKey},
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body)['data'];
      final Chapter chapter = Chapter.fromJson(data);

      return chapter;
    } else if (response.statusCode == 404) {
      // Chapter not found error
      // The chapter requested does not exist in the selected bible (translation/version)
      // Return first available chapter in the requested translation instead
      List<Book> validBooks = await fetchBibleBooks(bibleVersionId);
      return fetchBibleChapter(bibleVersionId, validBooks[0].chapters[0].id);
    } else {
      throw Exception(
        "Failed to load bible chapter - bibleVersionId: $bibleVersionId, chapterId: $chapterId",
      );
    }
  }
}
