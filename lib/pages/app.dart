import 'package:bible_app/utils/bible_state.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/pages/more.dart';
import 'package:bible_app/pages/notes.dart';
import 'package:bible_app/pages/reader.dart';
import 'package:bible_app/pages/search.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey,
            selectedItemColor: Colors.white,
            currentIndex: bibleState.selectedPage,
            onTap: (newPage) {
              bibleState.updateSelectedPage(newPage);
            },
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
          body: pages[bibleState.selectedPage],
        );
      },
    );
  }
}
