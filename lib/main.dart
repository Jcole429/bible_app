import 'package:flutter/material.dart';
import 'package:flutter_tutorial/data/default_bible_version.dart';
import 'package:flutter_tutorial/data/default_book.dart';
import 'package:flutter_tutorial/data/default_chapter.dart';
import 'package:flutter_tutorial/pages/app.dart';
import 'package:flutter_tutorial/pages/notes.dart';
import 'package:flutter_tutorial/pages/reader.dart';
import 'package:flutter_tutorial/pages/search.dart';
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
      routes: {
        '/reader':
            (context) => ReaderPage(
              selectedBibleVersion: defaultBibleVersion,
              selectedBibleBook: defaultBook,
              selectedBibleChapter: defaultChapter,
            ),
        '/search': (context) => SearchPage(),
        '/notes': (context) => NotesPage(),
      },
    );
  }
}
