import 'package:bible_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/models/language.dart';
import 'package:bible_app/models/bible.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import 'package:bible_app/utils/shared_preferences_helper.dart'; // Your SharedPreferences helper

// BibleState class to manage state
class BibleState extends ChangeNotifier {
  ApiService apiService = ApiService();

  Language? _selectedLanguage;
  Bible? _selectedBible;
  Book? _selectedBook;
  Chapter? _selectedChapter;

  bool _sortAlphabetical = false;
  int _selectedPage = 0;

  // Getters
  Language? get selectedLanguage => _selectedLanguage;
  Bible? get selectedBible => _selectedBible;
  Book? get selectedBook => _selectedBook;
  Chapter? get selectedChapter => _selectedChapter;

  bool get sortAlphabetical => _sortAlphabetical;
  int get selectedPage => _selectedPage;

  // Initialize state from SharedPreferences
  Future<void> initialize() async {
    _selectedLanguage = await SharedPreferencesHelper.getSelectedLanguage();
    _selectedBible = await SharedPreferencesHelper.getSelectedBible();
    _selectedBook = await SharedPreferencesHelper.getSelectedBook();
    _selectedChapter = await SharedPreferencesHelper.getSelectedChapter();
    _sortAlphabetical = await SharedPreferencesHelper.getSortAlphabetical();
    _selectedPage = await SharedPreferencesHelper.getSelectedPage();
    notifyListeners();
  }

  void updateLanguage(Language newLanguage) {
    _selectedLanguage = newLanguage;
    SharedPreferencesHelper.saveSelectedLanguage(newLanguage);
    notifyListeners();
  }

  void updateBible(Bible newVersion) async {
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
  }

  void updateBook(Book newBook) {
    _selectedBook = newBook;
    SharedPreferencesHelper.saveSelectedBook(newBook);
    notifyListeners();
  }

  void updateBookById(String bookId) async {
    Book newBook = await apiService.fetchBibleBook(selectedBible!.id, bookId);

    _selectedBook = newBook;
    SharedPreferencesHelper.saveSelectedBook(newBook);
    notifyListeners();
  }

  void updateChapter(Chapter newChapter) {
    _selectedChapter = newChapter;
    SharedPreferencesHelper.saveSelectedChapter(newChapter);
    notifyListeners();
  }

  void updateChapterById(String chapterId) async {
    Chapter newChapter = await apiService.fetchBibleChapter(
      selectedBible!.id,
      chapterId,
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
}
