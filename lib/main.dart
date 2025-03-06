import 'package:bible_app/utils/bible_state.dart';
import 'package:bible_app/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/pages/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready
  await dotenv.load();
  await SharedPreferencesHelper.init(); // Initialize storage
  // SharedPreferencesHelper.clear(); // Clear SharedPreferences

  runApp(
    ChangeNotifierProvider(
      create: (_) => BibleState()..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: App());
  }
}
