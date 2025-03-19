import 'dart:convert';

import 'package:bible_app/models/bible.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import 'package:bible_app/models/search_response.dart';
import 'package:bible_app/models/section.dart';
import 'package:bible_app/models/verse.dart';
import 'package:bible_app/utils/shared_preferences_helper.dart';
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
    String bibleId, {
    bool includeChapters = true,
  }) async {
    String url =
        '$baseUrl/bibles/$bibleId/books?include-chapters=$includeChapters';

    String cacheKey = 'bibleBooks_${bibleId}_$includeChapters';

    String logString =
        'fetchBibleBooks(bibleId: $bibleId, includeChapters: $includeChapters)';

    return ApiHelper.cachedApiCallList<Book>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: Book.fromJson,
    );
  }

  Future<Book> fetchBibleBook(String bibleId, String bibleBookId) async {
    String url = '$baseUrl/bibles/$bibleId/books/$bibleBookId';
    String cacheKey = 'bibleBook_${bibleId}_$bibleBookId';
    String logString =
        'fetchBibleBook(bibleId: $bibleId, bibleBookId: $bibleBookId)';

    return ApiHelper.cachedApiCallSingle<Book>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: Book.fromJson,
    );
  }

  Future<List<Chapter>> fetchBibleChapters(
    String bibleId,
    String bookId,
  ) async {
    String url = '$baseUrl/bibles/$bibleId/books/$bookId/chapters';
    String cacheKey = 'bibleChapters_${bibleId}_${bookId}';
    String logString =
        'fetchBibleChapters(bibleId: $bibleId, bibleId: $bibleId: $url';

    return ApiHelper.cachedApiCallList<Chapter>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: Chapter.fromJson,
    );
  }

  Future<Chapter> fetchBibleChapter(
    String bibleId,
    String chapterId, {
    String contentType = "html",
    bool includeTitles = true, // Include section titles in content
    bool includeChapterNumbers = false, // Include chapter numbers in content
    bool includeVerseNumbers = true, // Include verse numbers in content
    bool includeVerseSpans =
        false, //nclude spans that wrap verse numbers and verse text for bible content.
  }) async {
    bool includeNotes =
        await SharedPreferencesHelper.getIncludeFootnotesInContent(); // Include footnotes in content

    String url =
        '$baseUrl/bibles/$bibleId/chapters/$chapterId?content-type=$contentType&include-notes=$includeNotes&include-titles=$includeTitles&include-chapter-numbers=$includeChapterNumbers&include-verse-numbers=$includeVerseNumbers&include-verse-spans=$includeVerseSpans';
    String cacheKey =
        'bibleChapter_${bibleId}_${chapterId}_${contentType}_${includeNotes}_${includeTitles}_${includeChapterNumbers}_${includeVerseNumbers}_$includeVerseSpans';
    String logString =
        'fetchBibleChapter(bibleId: $bibleId, chapterId: $chapterId, contentType: $contentType, includeNotes: $includeNotes, includeTitles: $includeTitles, includeChapterNumbers: $includeChapterNumbers, includeVerseNumbers: $includeVerseNumbers, includeVerseSpans: $includeVerseSpans): $url';
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
        // Selected bible does not contain the requested chapter
        List<Book> validBooks = await fetchBibleBooks(bibleId);
        return await fetchBibleChapter(bibleId, validBooks[0].chapters[0].id);
      } else {
        rethrow;
      }
    }
  }

  Future<SearchResponse> fetchSearchResponse(
    String bibleId,
    String query, {
    int limit = 10,
    int offset = 0,
    String sort = 'relevance',
    String fuzziness = 'AUTO',
  }) async {
    String url =
        '$baseUrl/bibles/$bibleId/search?query=$query&limit=$limit&offset=$offset&sort=$sort&fuzziness=$fuzziness';
    String cacheKey = 'searchResponse_${bibleId}_$query';
    String logString =
        'fetchSearchResponse(bibleId: $bibleId, query: $query) | url: $url';

    return ApiHelper.cachedApiCallSingle<SearchResponse>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: SearchResponse.fromJson,
    );
  }

  Future<List<Section>> fetchBookSections(String bibleId, String bookId) async {
    String url =
        '$baseUrl/bibles/$bibleId/books/$bookId/sections?content-type=json';
    String cacheKey = 'bookSections_${bibleId}_$bookId';
    String logString = 'fetchBookSections(bibleId: $bibleId, bookId: $bookId)';

    return ApiHelper.cachedApiCallList<Section>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: Section.fromJson,
    );
  }

  Future<Verse> fetchVerse(String bibleId, String verseId) async {
    String url = '$baseUrl/bibles/$bibleId/verses/$verseId';
    String cacheKey = 'verse_${bibleId}_$verseId';
    String logString = 'fetchVerse(bibleId: $bibleId, verseId: $verseId)';

    return ApiHelper.cachedApiCallSingle<Verse>(
      url: url,
      cacheKey: cacheKey,
      logString: logString,
      fromJson: Verse.fromJson,
    );
  }
}
