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
        sortedBooks.sort((a, b) => a.name.compareTo(b.name));
      } else {
        sortedBooks = List.from(books); // Traditional order
      }

      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller:
                  ScrollController(), // Add controller to ensure scrolling
              itemCount: sortedBooks.length,
              itemBuilder: (context, index) {
                final book = sortedBooks[index];
                return ListTile(
                  title: Text(book.name),
                  titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (book.name != book.nameLong)
                        Text(
                          book.nameLong,
                          style: const TextStyle(color: Colors.black),
                        ),
                      Text("${book.chapters.length} Chapters"),
                    ],
                  ),
                  trailing:
                      bibleState.selectedBook!.id == book.id
                          ? const Icon(Icons.check)
                          : null,
                  onTap: () {
                    print('Clicked Book: ${book.name}');
                    onBookSelected(book);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              color: Colors.black,
              children: const [Text("Traditional"), Text("Alphabetical")],
              isSelected: [
                !bibleState.sortAlphabetical,
                bibleState.sortAlphabetical,
              ],
              onPressed: (int index) {
                setState(() {
                  bibleState.updateSortAlphabetical(index == 1);
                });
              },
            ),
          ),
        ],
      );
    },
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
