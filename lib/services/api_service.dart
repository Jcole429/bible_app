import 'dart:convert';

import 'package:bible_app/models/bible.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bible_app/utils/api_helper.dart';

class ApiService {
  final String baseUrl = "https://api.scripture.api.bible/v1";
  final String apiKey = dotenv.env['API_KEY']!;

  Future<List<Bible>> fetchBibles({
    String? languageId,
    includeFullDetails = true,
  }) async {
    String url = '$baseUrl/bibles?include-full-details=$includeFullDetails';
    if (languageId != null) {
      url = '$url&language=$languageId';
    }
    String cacheKey = 'bibles_${includeFullDetails}_$languageId';
    String logString =
        'fetchBibles(includeFullDetails: $includeFullDetails, languageId: $languageId)';

    return ApiHelper.cachedApiCallList<Bible>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: Bible.fromJson,
    );
  }

  Future<List<Book>> fetchBibleBooks(
    String bibleVersionId, {
    bool includeChapters = true,
  }) async {
    String url =
        '$baseUrl/bibles/$bibleVersionId/books?include-chapters=$includeChapters';

    String cacheKey = 'bibleBooks_${bibleVersionId}_$includeChapters';

    String logString =
        'fetchBibleBooks(bibleVersionId: $bibleVersionId, includeChapters: $includeChapters)';

    return ApiHelper.cachedApiCallList<Book>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: Book.fromJson,
    );
  }

  Future<Book> fetchBibleBook(String bibleVersionId, String bibleBookId) async {
    String url = '$baseUrl/bibles/$bibleVersionId/books/$bibleBookId';
    String cacheKey = 'bibleBook_${bibleVersionId}_$bibleBookId';
    String logString =
        'fetchBibleBook(bibleVersionId: $bibleVersionId, bibleBookId: $bibleBookId)';

    return ApiHelper.cachedApiCallSingle<Book>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: Book.fromJson,
    );
  }

  Future<List<Chapter>> fetchBibleChapters(
    String bibleVersionId,
    String bookId,
  ) async {
    String url = '$baseUrl/bibles/$bibleVersionId/books/$bookId/chapters';
    String cacheKey = 'bibleChapters_${bibleVersionId}_${bookId}';
    String logString =
        'fetchBibleChapters(bibleVersionId: $bibleVersionId, bibleVersionId: $bibleVersionId: $url';

    return ApiHelper.cachedApiCallList<Chapter>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: Chapter.fromJson,
    );
  }

  Future<Chapter> fetchBibleChapter(
    String bibleVersionId,
    String chapterId, {
    String contentType = "html",
    bool includeNotes = true, // Include footnotes in content
    bool includeTitles = true, // Include section titles in content
    bool includeChapterNumbers = false, // Include chapter numbers in content
    bool includeVerseNumbers = true, // Include verse numbers in content
    bool includeVerseSpans =
        false, //nclude spans that wrap verse numbers and verse text for bible content.
  }) async {
    String url =
        '$baseUrl/bibles/$bibleVersionId/chapters/$chapterId?content-type=$contentType&include-notes=$includeNotes&include-titles=$includeTitles&include-chapter-numbers=$includeChapterNumbers&include-verse-numbers=$includeVerseNumbers&include-verse-spans=$includeVerseSpans';
    String cacheKey =
        'bibleChapter_${bibleVersionId}_${chapterId}_${contentType}_${includeNotes}_${includeTitles}_${includeChapterNumbers}_${includeVerseNumbers}_$includeVerseSpans';
    String logString =
        'fetchBibleChapter(bibleVersionId: $bibleVersionId, chapterId: $chapterId, contentType: $contentType, includeNotes: $includeNotes, includeTitles: $includeTitles, includeChapterNumbers: $includeChapterNumbers, includeVerseNumbers: $includeVerseNumbers, includeVerseSpans: $includeVerseSpans): $url';
    try {
      return await ApiHelper.cachedApiCallSingle<Chapter>(
        url: url,
        cacheKey: cacheKey,
        logString: logString,
        fromJson: Chapter.fromJson,
      );
    } catch (e) {
      String errorString = e.toString();
      String jsonString = errorString.replaceFirst('Exception: ', '');
      Map<String, dynamic> errorJson = jsonDecode(jsonString);
      int statusCode = errorJson['statusCode'] as int;

      if (statusCode == 404) {
        // Selected bibleVersion does not contain the requested chapter
        List<Book> validBooks = await fetchBibleBooks(bibleVersionId);
        return await fetchBibleChapter(
          bibleVersionId,
          validBooks[0].chapters[0].id,
        );
      } else {
        rethrow;
      }
    }
  }
}
