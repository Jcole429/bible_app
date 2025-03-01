import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../services/api_service.dart';

class BiblesScreen extends StatefulWidget {
  const BiblesScreen({super.key});

  @override
  BiblesScreenState createState() => BiblesScreenState();
}

class BiblesScreenState extends State<BiblesScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.fetchBibleVersions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bibles")),
      body: FutureBuilder<List<dynamic>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No posts found"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['name']),
                  subtitle: Column(
                    children: [
                      Text("id: ${snapshot.data![index]['id']}"),
                      Text(
                        "abbreviation: ${snapshot.data![index]['abbreviation']}",
                      ),
                      Text(
                        "description: ${snapshot.data![index]['description']}",
                      ),
                      Html(data: snapshot.data![index]['info']),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
