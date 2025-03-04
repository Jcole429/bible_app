import 'package:bible_app/utils/bible_state.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/pages/more.dart';
import 'package:bible_app/pages/notes.dart';
import 'package:bible_app/pages/reader.dart';
import 'package:bible_app/pages/search.dart';
import 'package:bible_app/widgets/bible_menu.dart';
import 'package:bible_app/widgets/book_menu.dart';
import 'package:provider/provider.dart';
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
  bool _isBibleMenuOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BibleState>(
      builder: (context, bibleState, _) {
        if (bibleState.selectedLanguage == null ||
            bibleState.selectedBible == null ||
            bibleState.selectedBook == null ||
            bibleState.selectedChapter == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final List pages = [
          ReaderPage(),
          SearchPage(),
          NotesPage(),
          MorePage(),
        ];
        return Scaffold(
          appBar: AppBar(
            // title: Text("My Bible"),
            backgroundColor: Colors.grey,
            leadingWidth: 250,
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
                      showBookMenu(context).then((_) {
                        _isBookMenuOpen = false; // Reset when menu is closed
                      });
                    },
                    // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(
                      "${bibleState.selectedBook!.name} ${bibleState.selectedChapter!.number}",
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
                      if (_isBibleMenuOpen) {
                        return; // Prevent duplicate opening
                      }
                      _isBibleMenuOpen = true;
                      showBibleMenu(context).then((_) {
                        _isBibleMenuOpen = false; // Reset when menu is closed
                      });
                    },
                    // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(
                      bibleState.selectedBible!.abbreviation,
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
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: "Bible",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: "Notes",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "More"),
            ],
          ),
          body: pages[_selectedIndex],
        );
      },
    );
  }
}
