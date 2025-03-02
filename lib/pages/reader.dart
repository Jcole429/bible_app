import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/bible_version.dart';
import 'package:flutter_tutorial/models/book.dart';
import 'package:flutter_tutorial/models/chapter.dart';
import 'package:flutter_tutorial/services/api_service.dart';
import 'package:flutter_html/flutter_html.dart';

class ReaderPage extends StatefulWidget {
  final BibleVersion selectedBibleVersion;
  final Book selectedBibleBook;
  final Chapter selectedBibleChapter;

  const ReaderPage({
    super.key,
    required this.selectedBibleVersion,
    required this.selectedBibleBook,
    required this.selectedBibleChapter,
  });
  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final ApiService apiService = ApiService();
  late Future<Chapter> _futureChapter;
  String snapshotContent = "No Data";

  @override
  void initState() {
    super.initState();
    _fetchChapterText();
  }

  void _fetchChapterText() {
    setState(() {
      _futureChapter = apiService.fetchBibleChapter(
        widget.selectedBibleVersion.id,
        widget.selectedBibleChapter.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reader")),
      body: FutureBuilder<Chapter>(
        future: _futureChapter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data available."));
          } else {
            snapshotContent = snapshot.data!.content!;
          }

          return Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Html(
                    data: snapshotContent,
                    style: {
                      ".s1": Style(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.larger,
                      ),
                      ".s2": Style(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.large,
                      ),
                      ".v": Style(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.small,
                        verticalAlign: VerticalAlign.sup,
                      ),
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: FloatingActionButton(
                  backgroundColor: Colors.grey[700],
                  onPressed: () {},
                  shape: CircleBorder(),
                  foregroundColor: Colors.white,
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: Colors.grey[700],
                  onPressed: () {},
                  shape: CircleBorder(),
                  foregroundColor: Colors.white,
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
