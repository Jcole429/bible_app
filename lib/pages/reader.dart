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
  final Function(Chapter) onChapterChange;

  const ReaderPage({
    super.key,
    required this.selectedBibleVersion,
    required this.selectedBibleBook,
    required this.selectedBibleChapter,
    required this.onChapterChange,
  });

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final ApiService apiService = ApiService();
  String snapshotContent = "No Data";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ReaderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _goToPreviousChapter() {
    if (widget.selectedBibleChapter.previous != null) {
      widget.onChapterChange(widget.selectedBibleChapter.previous!);
    }
  }

  void _goToNextChapter() {
    if (widget.selectedBibleChapter.next != null) {
      widget.onChapterChange(widget.selectedBibleChapter.next!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Html(
                    data:
                        '<span class="scripture-styles">${widget.selectedBibleChapter.content}</span>',
                    style: {
                      // Global
                      ".scripture-styles": Style(fontFamily: "Noto Serif"),
                      // Chapter Section Title
                      ".s1": Style(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.larger,
                        margin: Margins.only(bottom: 0),
                      ),
                      // Related Verses (Under chapter title)
                      ".r": Style(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        margin: Margins.only(top: 0),
                      ),
                      // Chapter Sub-Section Titles
                      ".s2": Style(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.large,
                        margin: Margins.only(bottom: 0, top: 30),
                      ),
                      // Verse Numbers
                      ".v": Style(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.small,
                        verticalAlign: VerticalAlign.sup,
                      ),
                      // Footnotes
                      ".f": Style(
                        fontSize: FontSize.small,
                        fontStyle: FontStyle.italic,
                        display: Display.block,
                        margin: Margins.all(10),
                      ),
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 15,
                      bottom: 100,
                    ),
                    child: Text(
                      widget.selectedBibleChapter.copyright ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.grey[700],
              onPressed: () {
                _goToPreviousChapter();
              },
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
              onPressed: () {
                _goToNextChapter();
              },
              shape: CircleBorder(),
              foregroundColor: Colors.white,
              child: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
