import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/bible_version.dart';
import 'package:flutter_tutorial/models/book.dart';
import 'package:flutter_tutorial/models/chapter.dart';
import 'package:flutter_tutorial/models/language.dart';
import 'package:flutter_tutorial/pages/notes.dart';
import 'package:flutter_tutorial/pages/reader.dart';
import 'package:flutter_tutorial/pages/search.dart';
import '../services/api_service.dart';

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ApiService apiService = ApiService();

  int _selectedIndex = 0;

  Language selectedLanguage = Language.fromJson({
    "id": "eng",
    "name": "English",
    "nameLocal": "English",
    "script": "Latin",
    "scriptDirection": "LTR",
  });

  BibleVersion selectedBibleVersion = BibleVersion.fromJson({
    "id": "bba9f40183526463-01",
    "dblId": "bba9f40183526463",
    "name": "Berean Standard Bible",
    "nameLocal": "English: Berean Standard Bible",
    "abbreviation": "BSB",
    "abbreviationLocal": "BSB",
    "description": "Berean Standard Bible",
    "descriptionLocal": "English: Berean Standard Bible",
    "language": {
      "id": "eng",
      "name": "English",
      "nameLocal": "English",
      "script": "Latin",
      "scriptDirection": "LTR",
    },
    "countries": [
      {
        "id": "US",
        "name": "United States of America",
        "nameLocal": "United States of America",
      },
    ],
    "type": "text",
    "updatedAt": "2024-06-29T00:44:58.000Z",
    "copyright":
        "The Holy Bible, Berean Standard Bible, BSB is produced in cooperation with Bible Hub, Discovery Bible, OpenBible.com, and the Berean Bible Translation Committee. This text of God's Word has been dedicated to the public domain",
    "info": "<p>https://berean.bible/</p>",
    "audioBibles": [],
  });

  Book selectedBibleBook = Book.fromJson({
    "id": "GEN",
    "bibleId": "bba9f40183526463-01",
    "abbreviation": "GEN",
    "name": "Genesis",
    "nameLong": "Genesis",
    "chapters": [
      {
        "id": "GEN.intro",
        "bibleId": "bba9f40183526463-01",
        "bookId": "GEN",
        "number": "intro",
        "position": 0,
      },
      {
        "id": "GEN.1",
        "bibleId": "bba9f40183526463-01",
        "bookId": "GEN",
        "number": "1",
        "position": 1,
      },
    ],
  });

  Chapter selectBibleChapter = Chapter.fromJson({
    "id": "GEN.intro",
    "bibleId": "bba9f40183526463-01",
    "bookId": "GEN",
    "number": "intro",
    "position": 0,
  });

  final List _pages = [ReaderPage(), SearchPage(), NotesPage(), NotesPage()];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showBibleVersionMenu(
    BuildContext context,
    Function(BibleVersion) onBibleVersionSelected,
  ) async {
    TextEditingController searchController = TextEditingController();
    FocusNode searchFocusNode = FocusNode(); // Add FocusNode

    final List<BibleVersion> bibleVersions = await apiService
        .fetchBibleVersions(selectedLanguage.id);

    List<BibleVersion> filteredBibleVersions =
        bibleVersions.where((bibleVersion) {
          return bibleVersion.language.id == selectedLanguage.id;
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
                filteredBibleVersions =
                    bibleVersions.where((bibleVersion) {
                      String name = bibleVersion.name.toLowerCase();
                      String abbreviation =
                          bibleVersion.abbreviation.toLowerCase();
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
                                      "Versions: ${bibleVersions.length} in ${bibleVersions.map((bibleVersion) => bibleVersion.language.id) // or "language_name"
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
                            focusNode: searchFocusNode,
                            onTap: () {
                              searchFocusNode
                                  .requestFocus(); // Make sure keyboard opens
                            },
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
                          trailing: Text(selectedLanguage.name),
                          onTap: () {
                            _showLanguageMenu(context, bibleVersions, (
                              newLanguage,
                            ) {
                              setState(() {
                                selectedLanguage = newLanguage;
                              });
                              filteredBibleVersions =
                                  bibleVersions.where((bibleVersion) {
                                    return bibleVersion.language.id ==
                                        selectedLanguage.id;
                                  }).toList();
                            });
                          },
                        ),

                        Divider(),

                        // List of items
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredBibleVersions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  filteredBibleVersions[index].abbreviation,
                                ),
                                subtitle: Text(
                                  filteredBibleVersions[index].name,
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedBibleVersion =
                                        filteredBibleVersions[index]; // Update selected bibleVersion
                                  });
                                  onBibleVersionSelected(
                                    filteredBibleVersions[index],
                                  );
                                  Navigator.pop(context);
                                },
                                trailing:
                                    selectedBibleVersion.abbreviation ==
                                            filteredBibleVersions[index]
                                                .abbreviation
                                        ? Icon(Icons.check)
                                        : null,
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

  void _showLanguageMenu(
    BuildContext context,
    List<BibleVersion> bibleVersions,
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

  void _showBookMenu(
    BuildContext context,
    Function(Book) onBookSelected,
  ) async {
    final List<Book> bibleBooks = await apiService.fetchBibleBooks(
      selectedBibleVersion.id,
    );

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
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(
                                context,
                              ); // Close this sheet to return to the first one
                            },
                            icon: Icon(Icons.chevron_left),
                            // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            label: Text(
                              "Cancel",
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
                            child: Text(
                              "Books",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Divider(),

                      // List of books
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: bibleBooks.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(bibleBooks[index].name),
                              trailing:
                                  selectedBibleBook.id == bibleBooks[index].id
                                      ? Icon(Icons.check)
                                      : Text(bibleBooks[index].abbreviation),
                              onTap: () {
                                setState(() {
                                  selectedBibleBook =
                                      bibleBooks[index]; // Update selected language
                                });
                                onBookSelected(
                                  bibleBooks[index],
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
              // Bible Book-Chapter-Verse menu
              TextButton(
                onPressed: () {
                  _showBookMenu(context, (newBibleBook) {
                    setState(() {
                      selectedBibleBook = newBibleBook;
                    });
                  });
                },
                // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "${selectedBibleBook.name} ${selectBibleChapter.number}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),

              // Divider
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                // height: 20.0,
                width: 2,
                color: Colors.grey,
              ),

              // Bible version menu
              TextButton(
                onPressed: () {
                  _showBibleVersionMenu(context, (newBibleVersion) {
                    setState(() {
                      selectedBibleVersion = newBibleVersion;
                    });
                  });
                },
                // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  selectedBibleVersion.abbreviation,
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
