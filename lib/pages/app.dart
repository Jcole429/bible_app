import 'package:flutter/material.dart';
import 'package:flutter_tutorial/data/bible_versions.dart';
import 'package:flutter_tutorial/pages/bibles.dart';
import 'package:flutter_tutorial/pages/notes.dart';
import 'package:flutter_tutorial/pages/reader.dart';
import 'package:flutter_tutorial/pages/search.dart';

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  Map<String, String> selectedLanguage = {
    "language_id": "eng",
    "language_name": "English",
  };

  final List _pages = [ReaderPage(), SearchPage(), NotesPage(), NotesPage()];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showBibleVersionMenu(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    List<Map<String, String>> filteredItems =
        bibleVersions.where((bibleVersion) {
          return bibleVersion["language_id"]! ==
              selectedLanguage['language_id'];
        }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows it to take more space
      backgroundColor: Colors.transparent, // Makes the background transparent
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void filterList(String query) {
              setState(() {
                filteredItems =
                    bibleVersions.where((item) {
                      String name = item["name"]!.toLowerCase();
                      String abbreviation = item["abbreviation"]!.toLowerCase();
                      return name.contains(query.toLowerCase()) ||
                          abbreviation.contains(query.toLowerCase());
                    }).toList();
              });
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.9, // Start at 60% of screen height
              minChildSize: 0.4, // Minimum height (40%)
              maxChildSize: 0.9, // Maximum height (90%)
              builder: (context, scrollController) {
                return Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Ensure sheet has a background
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(padding: EdgeInsets.all(5)),
                        // Header with "Done" button
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                              child: Text(
                                "Done",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Choose a Version",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Versions: ${bibleVersions.length} in ${bibleVersions.map((item) => item["language_id"]) // or "language_name"
                                      .toSet() // Removes duplicates
                                      .length} languages",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 60), // Balancing spacing
                          ],
                        ),
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              filterList(value);
                            },
                            decoration: InputDecoration(
                              hintText: "Name or abbreviation",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),

                        // Language selector
                        ListTile(
                          title: Text("Language"),
                          leading: Icon(Icons.language),
                          trailing: Text(selectedLanguage['language_name']!),
                          onTap: () {
                            showLanguageMenu(context, (newLanguage) {
                              setState(() {
                                selectedLanguage = newLanguage;
                              });
                            });
                          },
                        ),

                        Divider(),

                        // List of items
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  filteredItems[index]["abbreviation"]!,
                                ),
                                subtitle: Text(filteredItems[index]["name"]!),
                                onTap: () => Navigator.pop(context),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<Map<String, String>> getUniqueLanguages() {
    Set<String> uniqueLanguageIds = {}; // Track unique language IDs

    return bibleVersions
        .where((bibleVersion) {
          return uniqueLanguageIds.add(
            bibleVersion["language_id"]!,
          ); // Adds only if unique
        })
        .map((bibleVersion) {
          return {
            "language_id": bibleVersion["language_id"]!,
            "language_name": bibleVersion["language_name"]!,
            "language_name_local": bibleVersion["language_name"]!,
          };
        })
        .toList();
  }

  void showLanguageMenu(
    BuildContext context,
    Function(Map<String, String>) onLanguageSelected,
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
            final List<Map<String, String>> languages = getUniqueLanguages();

            return DraggableScrollableSheet(
              initialChildSize: 0.9, // Start at 60% of screen height
              minChildSize: 0.4, // Minimum height (40%)
              maxChildSize: 0.9, // Maximum height (90%)
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white, // Ensure sheet has a background
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with Back Button
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(
                                context,
                              ); // Close this sheet to return to first one
                            },
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Sub Menu",
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
                              title: Text(languages[index]["language_name"]!),
                              trailing:
                                  selectedLanguage['language_id'] ==
                                          languages[index]["language_id"]
                                      ? Icon(Icons.check)
                                      : null,
                              onTap: () {
                                setState(() {
                                  selectedLanguage =
                                      languages[index]; // Update selected language
                                });
                                onLanguageSelected(
                                  languages[index],
                                ); // Update main modal
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("My Bible"),
        backgroundColor: Colors.grey,
        leadingWidth: 200,
        leading: Container(
          margin: EdgeInsets.only(left: 5, bottom: 5, top: 10),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Hebrews 9",
                textAlign: TextAlign.end,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                // height: 20.0,
                width: 2,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () {
                  _showBibleVersionMenu(context);
                },
                // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "NLT",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Bible"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Notes"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "More"),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
