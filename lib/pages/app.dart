import 'package:flutter/material.dart';
import 'package:bible_app/models/bible_version.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import 'package:bible_app/models/language.dart';
import 'package:bible_app/pages/more.dart';
import 'package:bible_app/pages/notes.dart';
import 'package:bible_app/pages/reader.dart';
import 'package:bible_app/pages/search.dart';
import 'package:bible_app/widgets/bible_version_menu.dart';
import 'package:bible_app/widgets/book_menu.dart';
import 'package:bible_app/utils/shared_preferences.dart';
import '../services/api_service.dart';

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ApiService apiService = ApiService();

  int _selectedIndex = 0;
  bool _isBookMenuOpen = false;
  bool _isBibleVersionMenuOpen = false;

  final ScrollController _readerScrollController = ScrollController();

  Language? selectedLanguage;
  BibleVersion? selectedBibleVersion;
  Book? selectedBook;
  Chapter? selectedChapter;

  bool _isInitialized = false; // Track initialization state

  @override
  void initState() {
    super.initState();
    _initializePreferencesAndData();
  }

  // Initialize SharedPreferences and load initial data
  Future<void> _initializePreferencesAndData() async {
    final savedLanguage = await SharedPreferencesHelper.getSelectedLanguage();
    final savedBibleVersion = await SharedPreferencesHelper.getSelectedBible();
    final savedBook = await SharedPreferencesHelper.getSelectedBook();
    final savedChapter = await SharedPreferencesHelper.getSelectedChapter();

    setState(() {
      selectedLanguage = savedLanguage;
      selectedBibleVersion = savedBibleVersion;
      selectedBook = savedBook;
      selectedChapter = savedChapter;
      _isInitialized = true;
    });
  }

  // Save the selected Language and update state
  void _updateSelectedLanguage(Language newLanguage) async {
    await SharedPreferencesHelper.saveSelectedLanguage(newLanguage);
    setState(() {
      selectedLanguage = newLanguage;
    });
  }

  // Save the selected Bible and update state
  void _updateSelectedBibleVersion(BibleVersion newBible) async {
    await SharedPreferencesHelper.saveSelectedBible(newBible);
    setState(() {
      selectedBibleVersion = newBible;
    });
  }

  // Save the selected Book and update state
  void _updateSelectedBook(Book newBook) async {
    await SharedPreferencesHelper.saveSelectedBook(newBook);
    setState(() {
      selectedBook = newBook;
    });
  }

  // Save the selected Chapter and update state
  void _updateSelectedChapter(Chapter newChapter) async {
    await SharedPreferencesHelper.saveSelectedChapter(newChapter);
    setState(() {
      selectedChapter = newChapter;
    });
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized ||
        selectedLanguage == null ||
        selectedBibleVersion == null ||
        selectedBook == null ||
        selectedChapter == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List pages = [
      ReaderPage(
        selectedBibleVersion: selectedBibleVersion!,
        selectedBibleBook: selectedBook!,
        selectedBibleChapter: selectedChapter!,
        onChapterChange: (newChapter) async {
          final fetchedChapter = await apiService.fetchBibleChapter(
            selectedBibleVersion!.id,
            newChapter.id,
          );
          _updateSelectedChapter(fetchedChapter);
          _readerScrollController.jumpTo(0);
        },
        scrollController: _readerScrollController,
      ),
      SearchPage(),
      NotesPage(),
      MorePage(),
    ];
    return Scaffold(
      appBar: AppBar(
        // title: Text("My Bible"),
        backgroundColor: Colors.grey,
        leadingWidth: 200,
        leading: Container(
          margin: EdgeInsets.only(left: 5, bottom: 5, top: 10),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bible Book-Chapter-Verse menu
              TextButton(
                onPressed: () {
                  if (_isBookMenuOpen) return; // Prevent duplicate opening
                  _isBookMenuOpen = true;
                  showBookMenu(
                    context,
                    selectedBibleVersion!,
                    selectedBook!,
                    (newBook) {
                      _updateSelectedBook(newBook);
                    },
                    (newChapter) {
                      _updateSelectedChapter(newChapter);
                    },
                  ).then((_) {
                    _isBookMenuOpen = false; // Reset when menu is closed
                  });
                },
                // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "${selectedBook!.name} ${selectedChapter!.number}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),

              // Divider
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                // height: 20.0,
                width: 2,
                color: Colors.grey,
              ),

              // Bible version menu
              TextButton(
                onPressed: () {
                  if (_isBibleVersionMenuOpen)
                    return; // Prevent duplicate opening
                  _isBibleVersionMenuOpen = true;
                  showBibleVersionMenu(
                    context,
                    selectedLanguage!,
                    selectedBibleVersion!,
                    (newBibleVersion) async {
                      final fetchedChapter = await apiService.fetchBibleChapter(
                        newBibleVersion.id,
                        selectedChapter!.id,
                      );
                      final fetchedBibleBook =
                          selectedBook!.id == fetchedChapter.bookId
                              ? selectedBook!
                              : await apiService.fetchBibleBook(
                                newBibleVersion.id,
                                fetchedChapter.bookId,
                              );
                      _updateSelectedBibleVersion(newBibleVersion);
                      _updateSelectedBook(fetchedBibleBook);
                      _updateSelectedChapter(fetchedChapter);
                    },
                  ).then((_) {
                    _isBibleVersionMenuOpen =
                        false; // Reset when menu is closed
                  });
                },
                // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  selectedBibleVersion!.abbreviation,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Bible"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Notes"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "More"),
        ],
      ),
      body: pages[_selectedIndex],
    );
  }
}
