import 'package:bible_app/models/language.dart';
import 'package:bible_app/utils/bible_state.dart';
import 'package:bible_app/utils/json_loader.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/widgets/language_menu.dart';
import '../models/bible.dart';
import 'package:provider/provider.dart';

Future<void> showBibleMenu(BuildContext context) async {
  if (!context.mounted) return; // Ensure context is valid before starting

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  final bibleState = Provider.of<BibleState>(context, listen: false);

  Language startingLanguage = bibleState.selectedLanguage!;
  Language selectedLanguage = startingLanguage;

  final List<Bible> bibles = await loadBiblesFromJson();

  bool isLoading = false;

  List<Bible> filteredBibles =
      bibles.where((bible) {
        return bible.language.id == selectedLanguage.id;
      }).toList();

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
          void filterListFromSearch(String query) {
            setState(() {
              filteredBibles =
                  bibles.where((bible) {
                    String name = bible.nameLocal.toLowerCase();
                    String abbreviation = bible.abbreviationLocal.toLowerCase();
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
              return Stack(
                children: [
                  Padding(
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
                                        "Versions: ${bibles.length} in ${bibles.map((bible) => bible.language.id).toSet() // Removes duplicates
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
                              onChanged: filterListFromSearch,
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(selectedLanguage.name),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                            onTap: () {
                              showLanguageMenu(
                                context,
                                bibles,
                                selectedLanguage,
                                (newLanguage) {
                                  setState(() {
                                    selectedLanguage = newLanguage;
                                    filteredBibles =
                                        bibles.where((bible) {
                                          return bible.language.id ==
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
                                String description =
                                    version.category ?? "No Category";
                                if (version.descriptionLocal != null &&
                                    version.descriptionLocal!.isNotEmpty &&
                                    ![
                                      "Bible",
                                      version.nameLocal,
                                      version.category,
                                    ].contains(version.descriptionLocal)) {
                                  description +=
                                      " - ${version.descriptionLocal!}";
                                }
                                return ListTile(
                                  title: Text(version.abbreviationLocal),
                                  titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        version.nameLocal,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        description,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          // fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text(
                                        "${version.bookCount} Books",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          // fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await bibleState.updateBible(version);
                                    bibleState.updateLanguage(version.language);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
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
                  ),
                  if (isLoading) Center(child: CircularProgressIndicator()),
                ],
              );
            },
          );
        },
      );
    },
  );
}
