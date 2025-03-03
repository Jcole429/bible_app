import 'package:bible_app/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/pages/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready
  await dotenv.load();
  await SharedPreferencesHelper.init(); // Initialize storage

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
