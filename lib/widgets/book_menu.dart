import 'package:bible_app/data/book_category_map.dart';
import 'package:bible_app/utils/bible_state.dart';
import 'package:flutter/material.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';

Future<void> showBookMenu(BuildContext context) async {
  final ApiService apiService = ApiService();

  final bibleState = Provider.of<BibleState>(context, listen: false);

  final List<Book> bibleBooks = await apiService.fetchBibleBooks(
    bibleState.selectedBible!.id,
  );

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with Back Button & Title
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
                            selectedBookForChapters != null ? "Back" : "Cancel",
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
                              selectedBookForChapters != null
                                  ? selectedBookForChapters!.name
                                  : "Books",
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
                              ? _buildBookList(context, bibleBooks, setState, (
                                book,
                              ) {
                                setState(() {
                                  selectedBookForChapters = book;
                                });
                              })
                              : _buildChapterGrid(selectedBookForChapters!),
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
                              onBookSelected,
                            );
                          }).toList(),
                        ];
                      }).toList(),
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
          itemCount: books.length,
          itemBuilder: (context, index) {
            return _buildBookTile(books[index], bibleState, onBookSelected);
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
  Function(Book) onBookSelected,
) {
  return ListTile(
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(book.name, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(" (${book.abbreviation})"),
      ],
    ),
    subtitle: Text("${book.chapters.length} Chapters"),
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

Widget _buildChapterGrid(Book selectedBook) {
  int totalChapters = selectedBook.chapters.length;
  ApiService apiService = ApiService();

  return GridView.builder(
    itemCount: totalChapters,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    ),
    itemBuilder: (context, index) {
      final bibleState = Provider.of<BibleState>(context, listen: false);

      return ElevatedButton(
        onPressed: () async {
          Chapter newChapter = await apiService.fetchBibleChapter(
            selectedBook.bibleId,
            selectedBook.chapters[index].id,
          );

          Book newBook = await apiService.fetchBibleBook(
            selectedBook.bibleId,
            newChapter.bookId,
          );

          bibleState.updateBook(newBook);
          bibleState.updateChapter(newChapter);

          if (!context.mounted) {
            return;
          }

          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          selectedBook.chapters[index].number,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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

  for (var book in books) {
    String parentCategory =
        getParentCategoryForBook(book.id)[bibleState.selectedLanguage?.id] ??
        '';
    String category =
        getCategoryForBook(book.id)[bibleState.selectedLanguage?.id] ?? '';

    if (parentCategory.isEmpty || category.isEmpty)
      continue; // Skip books without valid categories

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
