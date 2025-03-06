import 'package:bible_app/services/api_service.dart';
import 'package:bible_app/utils/bible_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MorePage extends StatelessWidget {
  MorePage({super.key});

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Consumer<BibleState>(
      builder: (context, bibleState, _) {
        return Scaffold(
          appBar: AppBar(title: Text("More")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    const Text(
                      'Include Footnotes',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(), // Pushes the switch to the right
                    Switch(
                      value: bibleState.includeFootnotesInContent,
                      onChanged: (value) {
                        bibleState.updateIncludeFootnotesInContent(value);
                        bibleState.updateChapterById(
                          bibleState.selectedChapter!.id,
                        ); // Fetch chapter again with new settings
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
