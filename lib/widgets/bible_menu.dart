import 'package:bible_app/models/language.dart';
import 'package:bible_app/utils/bible_state.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/widgets/language_menu.dart';
import '../models/bible.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';

Future<void> showBibleMenu(BuildContext context) async {
  final ApiService apiService = ApiService();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode(); // Add FocusNode

  final bibleState = Provider.of<BibleState>(context, listen: false);

  Language startingLanguage = bibleState.selectedLanguage!;
  Language selectedLanguage = startingLanguage;

  final List<Bible> bibleVersions = await apiService.fetchBibles();

  if (!context.mounted) return; // Prevent execution if widget is unmounted

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
          List<Bible> filteredBibles =
              bibleVersions.where((bibleVersion) {
                return bibleVersion.language.id == selectedLanguage.id;
              }).toList();

          void filterListFromSearch(String query) {
            setState(() {
              filteredBibles =
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
                            filterListFromSearch(value);
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
                                filteredBibles =
                                    bibleVersions.where((bibleVersion) {
                                      return bibleVersion.language.id ==
                                          newLanguage.id;
                                    }).toList();
                              });
                            },
                          );
                        },
                      ),

                      Divider(),

                      // List of Bibles
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredBibles.length,
                          itemBuilder: (context, index) {
                            final version = filteredBibles[index];
                            return ListTile(
                              title: Text(version.abbreviationLocal),
                              titleTextStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    version.nameLocal,
                                    style: TextStyle(
                                      color: Colors.black,
                                      // fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  if (version.descriptionLocal != null &&
                                      version.descriptionLocal!.isNotEmpty &&
                                      version.descriptionLocal !=
                                          version.nameLocal)
                                    Text(
                                      version.descriptionLocal!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        // fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                              onTap: () {
                                bibleState.updateBible(version);
                                bibleState.updateLanguage(selectedLanguage);
                                Navigator.pop(context);
                              },
                              trailing:
                                  bibleState.selectedBible!.id == version.id
                                      ? const Icon(Icons.check)
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
