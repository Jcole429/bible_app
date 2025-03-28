import 'package:bible_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/models/language.dart';
import 'package:bible_app/models/bible.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import 'package:bible_app/utils/shared_preferences_helper.dart';

// BibleState class to manage state
class BibleState extends ChangeNotifier {
  ApiService apiService = ApiService();

  Language? _selectedLanguage;
  Bible? _selectedBible;
  Book? _selectedBook;
  Chapter? _selectedChapter;

  bool _sortAlphabetical = false;
  int _selectedPage = 0;
  bool _includeFootnotesInContent = true;

  // Getters
  Language? get selectedLanguage => _selectedLanguage;
  Bible? get selectedBible => _selectedBible;
  Book? get selectedBook => _selectedBook;
  Chapter? get selectedChapter => _selectedChapter;

  bool get sortAlphabetical => _sortAlphabetical;
  int get selectedPage => _selectedPage;
  bool get includeFootnotesInContent => _includeFootnotesInContent;

  // Initialize state from SharedPreferences
  Future<void> initialize() async {
    _selectedLanguage = await SharedPreferencesHelper.getSelectedLanguage();
    _selectedBible = await SharedPreferencesHelper.getSelectedBible();
    _selectedBook = await SharedPreferencesHelper.getSelectedBook();
    _selectedChapter = await SharedPreferencesHelper.getSelectedChapter();
    _sortAlphabetical = await SharedPreferencesHelper.getSortAlphabetical();
    _selectedPage = await SharedPreferencesHelper.getSelectedPage();
    _includeFootnotesInContent =
        await SharedPreferencesHelper.getIncludeFootnotesInContent();
    notifyListeners();
  }

  Future<bool> updateLanguage(Language newLanguage) async {
    _selectedLanguage = newLanguage;
    SharedPreferencesHelper.saveSelectedLanguage(newLanguage);
    notifyListeners();
    return true;
  }

  Future<bool> updateBible(Bible newVersion) async {
    Chapter newChapter = await apiService.fetchBibleChapter(
      newVersion.id,
      selectedChapter!.id,
    );
    Book newBook = await apiService.fetchBibleBook(
      newVersion.id,
      newChapter.bookId,
    );

    _selectedBible = newVersion;
    _selectedChapter = newChapter;
    _selectedBook = newBook;

    SharedPreferencesHelper.saveSelectedBible(newVersion);
    SharedPreferencesHelper.saveSelectedBook(newBook);
    SharedPreferencesHelper.saveSelectedChapter(newChapter);

    notifyListeners();
    return true;
  }

  void updateBook(Book newBook) {
    _selectedBook = newBook;
    SharedPreferencesHelper.saveSelectedBook(newBook);
    notifyListeners();
  }

  Future<bool> updateBookById(String bookId) async {
    Book newBook = await apiService.fetchBibleBook(selectedBible!.id, bookId);

    _selectedBook = newBook;
    SharedPreferencesHelper.saveSelectedBook(newBook);
    notifyListeners();
    return true;
  }

  Future<bool> updateChapter(Chapter newChapter) async {
    _selectedChapter = newChapter;
    SharedPreferencesHelper.saveSelectedChapter(newChapter);
    notifyListeners();
    return true;
  }

  Future<bool> updateChapterById(String chapterId) async {
    Chapter newChapter = await apiService.fetchBibleChapter(
      selectedBible!.id,
      chapterId,
    );

    _selectedChapter = newChapter;
    SharedPreferencesHelper.saveSelectedChapter(newChapter);
    notifyListeners();
    return true;
  }

  void refreshCurrentChapter() async {
    // Refetch the current chapter with new settings
    Chapter newChapter = await apiService.fetchBibleChapter(
      selectedBible!.id,
      selectedChapter!.id,
    );
    _selectedChapter = newChapter;
    SharedPreferencesHelper.saveSelectedChapter(newChapter);
    notifyListeners();
  }

  void updateSortAlphabetical(bool newSortAlphabetical) {
    _sortAlphabetical = newSortAlphabetical;
    SharedPreferencesHelper.saveSortAlphabetical(newSortAlphabetical);
    notifyListeners();
  }

  void updateSelectedPage(int newSelectedPage) {
    _selectedPage = newSelectedPage;
    SharedPreferencesHelper.saveSelectedPage(newSelectedPage);
    notifyListeners();
  }

  Future<bool> updateIncludeFootnotesInContent(
    bool newIncludeFootnotesInContent,
  ) async {
    _includeFootnotesInContent = newIncludeFootnotesInContent;
    SharedPreferencesHelper.saveIncludeFootnotesInContent(
      newIncludeFootnotesInContent,
    );
    notifyListeners();
    return true;
  }
}
