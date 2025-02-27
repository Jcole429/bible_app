import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.scripture.api.bible/v1";

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bibles?language=ENG&include-full-details=true'),
      headers: {"api-key": "b30ca5e2d584010694eb2747ac25c1e1"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      for (int i = 0; i < data.length; i++) {
        if (data[i]["description"] == null ||
            data[i]["description"].toString().toUpperCase() == "NULL") {
          data[i]["description"] = "No Description Provided";
        }
        if (data[i]["info"] == null) {
          data[i]["info"] = "No Info Provided";
        }

        if (data[i]["abbreviation"] == null) {
          data[i]["abbreviation"] = "No Abbreviation Provided";
        }
      }
      print("data: $data");
      data.sort((a, b) => a["description"].compareTo(b["description"]));
      return data;
    } else {
      throw Exception("Failed to load posts");
    }
  }
}
