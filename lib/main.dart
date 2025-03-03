import 'package:flutter/material.dart';
import 'package:bible_app/data/default_bible_version.dart';
import 'package:bible_app/data/default_book.dart';
import 'package:bible_app/data/default_chapter.dart';
import 'package:bible_app/pages/app.dart';
import 'package:bible_app/pages/notes.dart';
import 'package:bible_app/pages/reader.dart';
import 'package:bible_app/pages/search.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: App(),
      // routes: {
      //   '/reader':
      //       (context) => ReaderPage(
      //         selectedBibleVersion: defaultBibleVersion,
      //         selectedBibleBook: defaultBook,
      //         selectedBibleChapter: defaultChapter,
      //         onChapterChange: {() => {}},
      //       ),
      //   '/search': (context) => SearchPage(),
      //   '/notes': (context) => NotesPage(),
      // },
    );
  }
}
