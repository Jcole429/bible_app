import 'package:bible_app/models/section.dart';
import 'package:bible_app/models/verse.dart';
import 'package:bible_app/utils/bible_state.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';

Future<void> showBookMenu(BuildContext context) async {
  final ApiService apiService = ApiService();

  final bibleState = Provider.of<BibleState>(context, listen: false);
  if (!context.mounted) return; // Prevent execution if widget is unmounted

  Book? selectedBookForChapters;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),

    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: FutureBuilder<List<Book>>(
                  future: apiService.fetchBibleBooks(
                    bibleState.selectedBible!.id,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error loading books"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No books found"));
                    }

                    final List<Book> bibleBooks = snapshot.data!;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                if (selectedBookForChapters == null) {
                                  Navigator.pop(context); // Close modal
                                } else {
                                  setState(() {
                                    selectedBookForChapters =
                                        null; // Go back to book selection
                                  });
                                }
                              },
                              child: Text(
                                selectedBookForChapters != null
                                    ? "Back"
                                    : "Cancel",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  selectedBookForChapters == null
                                      ? "Books"
                                      : selectedBookForChapters!.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "History",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Either show Books or Chapters based on selectedBook
                        Expanded(
                          child:
                              selectedBookForChapters == null
                                  ? _buildBookList(
                                    context,
                                    bibleBooks,
                                    setState,
                                    (book) {
                                      setState(() {
                                        selectedBookForChapters = book;
                                      });
                                    },
                                  )
                                  : _buildChapterMenu(
                                    selectedBookForChapters!,
                                    bibleState,
                                  ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      );
    },
  );
}

Widget _buildBookList(
  BuildContext context,
  List<Book> books,
  void Function(void Function()) setState,
  Function(Book) onBookSelected,
) {
  return Consumer<BibleState>(
    builder: (context, bibleState, _) {
      List<Book> sortedBooks = List.from(books);

      if (bibleState.sortAlphabetical) {
        // Alphabetical sort: No sections
        sortedBooks.sort((a, b) => a.name.compareTo(b.name));
        return _buildSimpleListView(sortedBooks, bibleState, onBookSelected);
      }

      // Traditional order: Check if categories exist
      final groupedBooks = groupBooksByCategory(sortedBooks, bibleState);
      bool hasValidCategories =
          groupedBooks.isNotEmpty &&
          groupedBooks.keys.any((key) => key.isNotEmpty);

      if (!hasValidCategories) {
        // If categories aren't available in the language, show a simple list
        return _buildSimpleListView(sortedBooks, bibleState, onBookSelected);
      }

      return Column(
        children: [
          Expanded(
            child: ListView(
              controller: ScrollController(),
              key: PageStorageKey('bibleBookTraditionalMenuPostion'),
              children:
                  groupedBooks.entries.expand((parentEntry) {
                    String parentCategory = parentEntry.key;
                    return [
                      _buildSectionHeader(parentCategory, Colors.grey[700]!),
                      ...parentEntry.value.entries.expand((categoryEntry) {
                        String category = categoryEntry.key;
                        return [
                          _buildSectionHeader(category, Colors.grey[400]!),
                          ...categoryEntry.value.map((book) {
                            return _buildBookTile(
                              book,
                              bibleState,
                              false,
                              onBookSelected,
                            );
                          }),
                        ];
                      }),
                    ];
                  }).toList(),
            ),
          ),
          SafeArea(child: _buildSortToggle(bibleState)),
        ],
      );
    },
  );
}

Widget _buildSimpleListView(
  List<Book> books,
  BibleState bibleState,
  Function(Book) onBookSelected,
) {
  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          controller: ScrollController(),
          key: PageStorageKey('bibleBookAlphabeticalMenuPostion'),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return _buildBookTile(
              books[index],
              bibleState,
              true,
              onBookSelected,
            );
          },
        ),
      ),
      SafeArea(child: _buildSortToggle((bibleState))),
    ],
  );
}

Widget _buildBookTile(
  Book book,
  BibleState bibleState,
  bool includeCategories,
  Function(Book) onBookSelected,
) {
  String? parentCategory = book.getParentCategory(
    bibleState.selectedLanguage!.id,
  );
  String? category = book.getCategory(bibleState.selectedLanguage!.id);

  return ListTile(
    title: Text(book.name),
    titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    dense: true,
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (includeCategories && parentCategory != null)
          Text("$parentCategory - $category"),
        Text("${book.chapters.length} Chapters"),
      ],
    ),
    trailing:
        bibleState.selectedBook!.id == book.id ? const Icon(Icons.check) : null,
    onTap: () => onBookSelected(book),
  );
}

Widget _buildSectionHeader(String title, Color color) {
  return Container(
    padding: EdgeInsets.all(8.0),
    color: color,
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

Widget _buildChapterMenu(Book selectedBook, BibleState bibleState) {
  bool showGrid = true;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Expanded(
            child:
                showGrid
                    ? _buildChapterGrid(selectedBook, bibleState)
                    : _buildSectionsMenu(selectedBook, bibleState),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ToggleButtons(
                isSelected: [showGrid, !showGrid],
                onPressed: (index) {
                  setState(() {
                    showGrid = index == 0;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                borderColor: Colors.grey,
                selectedBorderColor: Colors.blue,
                fillColor: Colors.blue.shade100,
                color: Colors.black,
                selectedColor: Colors.white,
                constraints: const BoxConstraints(minWidth: 100, minHeight: 40),
                children: const [
                  Text(
                    "Chapters",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sections",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildSectionsMenu(Book selectedBook, BibleState bibleState) {
  ApiService apiService = ApiService();
  bool isLoading = false;

  return FutureBuilder<List<Section>>(
    future: apiService.fetchBookSections(selectedBook.bibleId, selectedBook.id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(
          child: Text("Sections are not available for this bible version"),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text("No sections found"));
      }

      return StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final section = snapshot.data![index];
                  return ListTile(
                    title: Text(section.title),
                    subtitle: Text(
                      "${section.firstVerseId} - ${section.lastVerseId}",
                    ),
                    onTap: () async {
                      setState(() => isLoading = true);

                      Verse newVerse = await apiService.fetchVerse(
                        section.bibleId,
                        section.firstVerseId,
                      );

                      Chapter newChapter = await apiService.fetchBibleChapter(
                        newVerse.bibleId,
                        newVerse.chapterId,
                      );

                      Book newBook = await apiService.fetchBibleBook(
                        newVerse.bibleId,
                        newVerse.bookId,
                      );

                      bibleState.updateBook(newBook);
                      await bibleState.updateChapter(newChapter);

                      if (!context.mounted) return;
                      setState(() => isLoading = false);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      );
    },
  );
}

Widget _buildChapterGrid(Book selectedBook, BibleState bibleState) {
  int totalChapters = selectedBook.chapters.length;
  ApiService apiService = ApiService();
  bool isLoading = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GridView.builder(
                  itemCount: totalChapters,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final bibleState = Provider.of<BibleState>(
                      context,
                      listen: false,
                    );

                    return ElevatedButton(
                      onPressed:
                          isLoading
                              ? null // Disable button while loading
                              : () async {
                                setState(() => isLoading = true);

                                Chapter newChapter = await apiService
                                    .fetchBibleChapter(
                                      selectedBook.bibleId,
                                      selectedBook.chapters[index].id,
                                    );

                                Book newBook = await apiService.fetchBibleBook(
                                  selectedBook.bibleId,
                                  newChapter.bookId,
                                );

                                bibleState.updateBook(newBook);
                                await bibleState.updateChapter(newChapter);

                                setState(() => isLoading = false);

                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        selectedBook.chapters[index].number,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                if (isLoading) Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      );
    },
  );
}

// Helper function to group books by category
Map<String, Map<String, List<Book>>> groupBooksByCategory(
  List<Book> books,
  BibleState bibleState,
) {
  Map<String, Map<String, List<Book>>> groupedBooks = {};

  const String defaultParentCategory = 'Uncategorized';
  const String defaultCategory = 'Unknown Category';

  for (var book in books) {
    String parentCategory =
        book.getParentCategory(bibleState.selectedLanguage!.id) ??
        defaultParentCategory;
    String category =
        book.getCategory(bibleState.selectedLanguage!.id) ?? defaultCategory;

    groupedBooks.putIfAbsent(parentCategory, () => {});
    groupedBooks[parentCategory]!.putIfAbsent(category, () => []);
    groupedBooks[parentCategory]![category]!.add(book);
  }

  return groupedBooks;
}

Widget _buildSortToggle(BibleState bibleState) {
  return Container(
    height: 30,
    decoration: BoxDecoration(
      color: Colors.grey[700],
      border: Border.all(color: Colors.black, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return ToggleButtons(
          renderBorder: false,
          constraints: BoxConstraints.expand(width: constraints.maxWidth / 2),
          color: Colors.white,
          selectedColor: Colors.white,
          fillColor: Colors.grey,
          borderRadius: BorderRadius.circular(5),
          isSelected: [
            !bibleState.sortAlphabetical,
            bibleState.sortAlphabetical,
          ],
          onPressed: (index) {
            bibleState.updateSortAlphabetical(index == 1);
          },
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Traditional"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Alphabetical"),
            ),
          ],
        );
      },
    ),
  );
}
