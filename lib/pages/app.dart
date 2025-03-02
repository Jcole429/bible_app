import 'package:flutter/material.dart';
import 'package:flutter_tutorial/data/default_bible_version.dart';
import 'package:flutter_tutorial/data/default_book.dart';
import 'package:flutter_tutorial/data/default_chapter.dart';
import 'package:flutter_tutorial/data/default_language.dart';
import 'package:flutter_tutorial/models/bible_version.dart';
import 'package:flutter_tutorial/models/book.dart';
import 'package:flutter_tutorial/models/chapter.dart';
import 'package:flutter_tutorial/models/language.dart';
import 'package:flutter_tutorial/pages/notes.dart';
import 'package:flutter_tutorial/pages/reader.dart';
import 'package:flutter_tutorial/pages/search.dart';
import 'package:flutter_tutorial/widgets/bible_version_menu.dart';
import 'package:flutter_tutorial/widgets/book_menu.dart';
import '../services/api_service.dart';

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _fetchInitialChapter();
  }

  void _fetchInitialChapter() async {
    final fetchedChapter = await apiService.fetchBibleChapter(
      selectedBibleVersion.id,
      selectedBibleChapter.id,
    );
    setState(() {
      selectedBibleChapter = fetchedChapter;
    });
  }

  final ApiService apiService = ApiService();

  int _selectedIndex = 0;

  Language selectedLanguage = defaultLanguage;

  BibleVersion selectedBibleVersion = defaultBibleVersion;

  Book selectedBibleBook = defaultBook;

  Chapter selectedBibleChapter = defaultChapter;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List pages = [
      ReaderPage(
        selectedBibleVersion: selectedBibleVersion,
        selectedBibleBook: selectedBibleBook,
        selectedBibleChapter: selectedBibleChapter,
        onChapterChange: (newChapter) async {
          final fetchedChapter = await apiService.fetchBibleChapter(
            selectedBibleVersion.id,
            newChapter.id,
          );
          setState(() {
            selectedBibleChapter = fetchedChapter;
          });
        },
      ),
      SearchPage(),
      NotesPage(),
      NotesPage(),
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
                  showBookMenu(
                    context,
                    selectedBibleVersion,
                    selectedBibleBook,
                    (newBook) {
                      setState(() {
                        selectedBibleBook = newBook;
                      });
                    },
                    (newChapter) {
                      setState(() {
                        selectedBibleChapter = newChapter;
                      });
                    },
                  );
                },
                // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "${selectedBibleBook.name} ${selectedBibleChapter.number}",
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
                  showBibleVersionMenu(
                    context,
                    selectedLanguage,
                    selectedBibleVersion,
                    (newBibleVersion) async {
                      final fetchedChapter = await apiService.fetchBibleChapter(
                        newBibleVersion.id,
                        selectedBibleChapter.id,
                      );
                      final fetchedBibleBook =
                          selectedBibleBook.id == fetchedChapter.bookId
                              ? selectedBibleBook
                              : await apiService.fetchBibleBook(
                                newBibleVersion.id,
                                fetchedChapter.bookId,
                              );
                      setState(() {
                        selectedBibleVersion = newBibleVersion;
                        selectedBibleBook = fetchedBibleBook;
                        selectedBibleChapter = fetchedChapter;
                      });
                    },
                  );
                },
                // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  selectedBibleVersion.abbreviation,
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
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
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
