import 'dart:convert';
import 'package:bible_app/models/bible.dart';
import 'package:flutter/services.dart';

final biblesFile = 'assets/data/bibles.json';

Future<List<Bible>> loadBiblesFromJson() async {
  try {
    // Load the JSON file as a string
    final String jsonString = await rootBundle.loadString(biblesFile);

    // Decode JSON into a List
    final List<dynamic> jsonList = jsonDecode(jsonString);

    // Convert JSON data to List<Bible>
    List<Bible> bibles = jsonList.map((json) => Bible.fromJson(json)).toList();

    return bibles;
  } catch (e) {
    print("Error loading bibles from JSON: $e");
    return [];
  }
}
