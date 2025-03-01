import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/language.dart';
import 'package:flutter_tutorial/widgets/language_menu.dart';
import '../models/bible_version.dart'; // Import the BibleVersion model
import '../services/api_service.dart';

void showBibleVersionMenu(
  BuildContext context,
  Language selectedLanguage,
  BibleVersion selectedBibleVersion,
  Function(BibleVersion) onBibleVersionSelected,
) async {
  final ApiService apiService = ApiService();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode(); // Add FocusNode

  final List<BibleVersion> bibleVersions = await apiService.fetchBibleVersions(
    selectedLanguage.id,
  );

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
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),

                      // Language selector
                      ListTile(
                        title: Text("Language"),
                        leading: Icon(Icons.language),
                        trailing: Text(selectedLanguage.name),
                        onTap: () {
                          showLanguageMenu(
                            context,
                            bibleVersions,
                            selectedLanguage,
                            (newLanguage) {
                              setState(() {
                                selectedLanguage = newLanguage;
                              });
                              filteredBibleVersions =
                                  bibleVersions.where((bibleVersion) {
                                    return bibleVersion.language.id ==
                                        selectedLanguage.id;
                                  }).toList();
                            },
                          );
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
                              subtitle: Text(filteredBibleVersions[index].name),
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
