import 'dart:convert';
import 'dart:io';
import 'package:bible_app/models/bible.dart';
import 'package:bible_app/services/api_service.dart';
import 'package:path_provider/path_provider.dart';

Future<List<Bible>> loadBiblesFromJson() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/bibles.json');

  if (await file.exists()) {
    final String jsonString = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData.map((json) => Bible.fromJson(json)).toList();
  } else {
    await fetchAndWriteBiblesToJson();
    return await loadBiblesFromJson();
  }
}

Future<Null> fetchAndWriteBiblesToJson() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/bibles.json');

  final ApiService apiService = ApiService();
  final List<Bible> bibles = await apiService.fetchBibles();

  List<Bible> filteredBibles =
      bibles.where((bible) {
        return ['eng', 'spa', 'por'].contains(bible.language.id);
      }).toList();

  final String jsonString = jsonEncode(
    filteredBibles.map((bible) => bible.toJson()).toList(),
  );

  await file.writeAsString(jsonString);

  print("✅ Bibles saved to: ${file.path}");
}
