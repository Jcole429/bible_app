import 'package:bible_app/services/api_service.dart';
import 'package:bible_app/utils/bible_state.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/models/chapter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  ReaderPageState createState() => ReaderPageState();
}

class ReaderPageState extends State<ReaderPage> {
  final ApiService apiService = ApiService();
  final ScrollController _readerScrollController = ScrollController();

  String snapshotContent = "No Data";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ReaderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _goToPreviousChapter(BibleState bibleState) async {
    Chapter? previousChapter = bibleState.selectedChapter!.previous;
    if (previousChapter != null) {
      final fetchedChapter = await apiService.fetchBibleChapter(
        bibleState.selectedBible!.id,
        previousChapter.id,
      );
      bibleState.updateChapter(fetchedChapter);
      _readerScrollController.jumpTo(0);
    }
  }

  void _goToNextChapter(BibleState bibleState) async {
    Chapter? nextChapter = bibleState.selectedChapter!.next;
    if (nextChapter != null) {
      final fetchedChapter = await apiService.fetchBibleChapter(
        bibleState.selectedBible!.id,
        nextChapter.id,
      );
      bibleState.updateChapter(fetchedChapter);
      _readerScrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BibleState>(
      builder: (context, bibleState, _) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: double.infinity,
                child: SingleChildScrollView(
                  controller: _readerScrollController,
                  child: Column(
                    children: [
                      Html(
                        data:
                            '<span class="scripture-styles">${bibleState.selectedChapter!.content}</span>',
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
                          left: 30,
                          right: 30,
                          top: 15,
                          bottom: 80,
                        ),
                        child: Text(
                          bibleState.selectedChapter!.copyright ?? "",
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
                    _goToPreviousChapter(bibleState);
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
                    _goToNextChapter(bibleState);
                  },
                  shape: CircleBorder(),
                  foregroundColor: Colors.white,
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
