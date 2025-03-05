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
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        book.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" (${book.abbreviation})"),
                    ],
                  ),
                  visualDensity: VisualDensity.compact,
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
          SafeArea(
            child: Container(
              // width: 150.0, // hardcoded for testing purpose
              height: 30,
              // color: Colors.grey[700],
              decoration: BoxDecoration(
                color: Colors.grey[700],
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              // borderRadius: BorderRadius.circular(5),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ToggleButtons(
                    renderBorder: false,
                    constraints: BoxConstraints.expand(
                      width: constraints.maxWidth / 2,
                    ),
                    color: Colors.white,
                    selectedColor: Colors.white,
                    fillColor: Colors.grey,
                    // splashColor: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                    isSelected: [
                      !bibleState.sortAlphabetical,
                      bibleState.sortAlphabetical,
                    ],
                    onPressed: (index) {
                      setState(() {
                        bibleState.updateSortAlphabetical(index == 1);
                      });
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
