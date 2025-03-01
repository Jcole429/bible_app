import 'package:flutter/material.dart';
import 'package:flutter_tutorial/pages/app.dart';
import 'package:flutter_tutorial/pages/notes.dart';
import 'package:flutter_tutorial/pages/reader.dart';
import 'package:flutter_tutorial/pages/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: App(),
      routes: {
        '/reader': (context) => ReaderPage(),
        '/search': (context) => SearchPage(),
        '/notes': (context) => NotesPage(),
      },
    );
  }
}
