import 'package:flutter/material.dart';
import 'package:bible_app/models/language.dart';
import '../models/bible_version.dart'; // Import the BibleVersion model

List<Language> getUniqueLanguages(List<BibleVersion> bibleVersions) {
  Set<String> seenLanguageIds = {};
  List<Language> uniqueLanguages = [];

  for (var version in bibleVersions) {
    if (!seenLanguageIds.contains(version.language.id)) {
      seenLanguageIds.add(version.language.id);
      uniqueLanguages.add(version.language);
    }
  }

  uniqueLanguages.sort((a, b) {
    if (a.id == "eng") return -1;
    if (b.id == "eng") return 1;
    if (a.id == "spa") return -1;
    if (b.id == "spa") return 1;
    return a.name.compareTo(b.name);
  });

  return uniqueLanguages;
}

void showLanguageMenu(
  BuildContext context,
  List<BibleVersion> bibleVersions,
  Language selectedLanguage,
  Function(Language) onLanguageSelected,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Makes the background transparent
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final List<Language> languages = getUniqueLanguages(bibleVersions);

          return DraggableScrollableSheet(
            initialChildSize: 0.9, // Start at 60% of screen height
            minChildSize: 0.4, // Minimum height (40%)
            maxChildSize: 0.9, // Maximum height (90%)
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white, // Ensure sheet has a background
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with Back Button
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            ); // Close this sheet to return to the first one
                          },
                          icon: Icon(Icons.chevron_left),
                          // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          label: Text(
                            "Versions",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                        Center(
                          child: Center(
                            child: Text(
                              "Bible Languages",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),

                    // List of languages
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: languages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(languages[index].nameLocal),
                            trailing:
                                selectedLanguage.id == languages[index].id
                                    ? Icon(Icons.check)
                                    : Text(languages[index].name),
                            onTap: () {
                              setState(() {
                                selectedLanguage =
                                    languages[index]; // Update selected language
                              });
                              onLanguageSelected(selectedLanguage);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}
