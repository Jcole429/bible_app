import 'package:bible_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/models/language.dart';
import 'package:bible_app/models/bible_version.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import 'package:bible_app/utils/shared_preferences_helper.dart'; // Your SharedPreferences helper

// BibleState class to manage state
class BibleState extends ChangeNotifier {
  ApiService apiService = ApiService();

  Language? _selectedLanguage;
  BibleVersion? _selectedBibleVersion;
  Book? _selectedBook;
  Chapter? _selectedChapter;

  // Getters
  Language? get selectedLanguage => _selectedLanguage;
  BibleVersion? get selectedBibleVersion => _selectedBibleVersion;
  Book? get selectedBook => _selectedBook;
  Chapter? get selectedChapter => _selectedChapter;

  // Initialize state from SharedPreferences
  Future<void> initialize() async {
    _selectedLanguage = await SharedPreferencesHelper.getSelectedLanguage();
    _selectedBibleVersion = await SharedPreferencesHelper.getSelectedBible();
    _selectedBook = await SharedPreferencesHelper.getSelectedBook();
    _selectedChapter = await SharedPreferencesHelper.getSelectedChapter();
    notifyListeners();
  }

  // Update methods
  void updateBook(Book newBook) {
    _selectedBook = newBook;
    SharedPreferencesHelper.saveSelectedBook(newBook);
    notifyListeners();
  }

  void updateChapter(Chapter newChapter) {
    _selectedChapter = newChapter;
    SharedPreferencesHelper.saveSelectedChapter(newChapter);
    notifyListeners();
  }

  void updateBibleVersion(BibleVersion newVersion) async {
    Chapter newChapter = await apiService.fetchBibleChapter(
      newVersion.id,
      selectedChapter!.id,
    );
    Book newBook = await apiService.fetchBibleBook(
      newVersion.id,
      newChapter.bookId,
    );

    _selectedBibleVersion = newVersion;
    _selectedChapter = newChapter;
    _selectedBook = newBook;

    SharedPreferencesHelper.saveSelectedBible(newVersion);
    SharedPreferencesHelper.saveSelectedBook(newBook);
    SharedPreferencesHelper.saveSelectedChapter(newChapter);

    notifyListeners();
  }

  void updateLanguage(Language newLanguage) {
    _selectedLanguage = newLanguage;
    SharedPreferencesHelper.saveSelectedLanguage(newLanguage);
    notifyListeners();
  }
}
