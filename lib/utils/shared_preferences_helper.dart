import 'dart:convert';
import 'package:bible_app/data/default_bible.dart';
import 'package:bible_app/data/default_book.dart';
import 'package:bible_app/data/default_chapter.dart';
import 'package:bible_app/data/default_language.dart';
import 'package:bible_app/models/bible.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import 'package:bible_app/models/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  static const String _languageKey = 'selectedLanguage';
  static const String _bibleKey = 'selectedBible';
  static const String _bookKey = 'selectedBook';
  static const String _chapterKey = 'selectedChapter';

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

  static Future<void> saveSelectedLanguage(Language language) async {
    return saveString(_languageKey, jsonEncode(language.toJson()));
  }

  static Future<Language> getSelectedLanguage() async {
    String? data = getString(_languageKey);
    if (data != null) {
      return Language.fromJson(jsonDecode(data));
    } else {
      return defaultLanguage;
    }
  }

  static Future<void> saveSelectedBible(Bible bible) async {
    return saveString(_bibleKey, jsonEncode(bible.toJson()));
  }

  static Future<Bible> getSelectedBible() async {
    String? data = getString(_bibleKey);
    if (data != null) {
      return Bible.fromJson(jsonDecode(data));
    } else {
      return defaultBible;
    }
  }

  static Future<void> saveSelectedBook(Book book) async {
    return saveString(_bookKey, jsonEncode(book.toJson()));
  }

  static Future<Book> getSelectedBook() async {
    String? data = getString(_bookKey);
    if (data != null) {
      return Book.fromJson(jsonDecode(data));
    } else {
      return defaultBook;
    }
  }

  static Future<void> saveSelectedChapter(Chapter chapter) async {
    return saveString(_chapterKey, jsonEncode(chapter.toJson()));
  }

  static Future<Chapter> getSelectedChapter() async {
    String? data = getString(_chapterKey);
    if (data != null) {
      return Chapter.fromJson(jsonDecode(data));
    } else {
      return defaultChapter;
    }
  }
}
