import 'package:flutter/material.dart';
import 'package:bible_app/models/book.dart';
import 'package:bible_app/models/chapter.dart';
import '../models/bible_version.dart';
import '../services/api_service.dart';

Future<void> showBookMenu(
  BuildContext context,
  BibleVersion selectedBibleVersion,
  Book selectedBook,
  Function(Book) onBookSelected,
  Function(Chapter) onChapterSelected,
) async {
  final ApiService apiService = ApiService();

  final List<Book> bibleBooks = await apiService.fetchBibleBooks(
    selectedBibleVersion.id,
  );

  if (!context.mounted) return; // Prevent execution if widget is unmounted

  Book? selectedBookForChapters;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with Back Button & Title
                    Row(
                      children: [
                        TextButton.icon(
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
                          icon: Icon(Icons.close),
                          label: Text(
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 48), // Align title properly
                      ],
                    ),

                    Divider(),

                    // Either show Books or Chapters based on selectedBook
                    Expanded(
                      child:
                          selectedBookForChapters == null
                              ? _buildBookList(bibleBooks, (book) {
                                setState(() {
                                  selectedBookForChapters = book;
                                });
                              })
                              : _buildChapterGrid(
                                selectedBookForChapters!,
                                onBookSelected,
                                onChapterSelected,
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

Widget _buildBookList(List<Book> books, Function(Book) onBookSelected) {
  return ListView.builder(
    itemCount: books.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(books[index].name),
        trailing: Text(books[index].abbreviation),
        onTap: () {
          // setState(() => books[index]); // Switch to chapter view

          print('Clicked Book: ${books[index].name}');
          onBookSelected(books[index]); // Updates state to show chapter grid
        },
      );
    },
  );
}

Widget _buildChapterGrid(
  Book selectedBook,
  Function(Book) onBookSelected,
  Function(Chapter) onChapterSelected,
) {
  int totalChapters = selectedBook.chapters.length;
  ApiService apiService = ApiService();

  return GridView.builder(
    itemCount: totalChapters,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    ),
    itemBuilder: (context, index) {
      return ElevatedButton(
        onPressed: () async {
          onBookSelected(selectedBook);
          Chapter newChapter = await apiService.fetchBibleChapter(
            selectedBook.bibleId,
            selectedBook.chapters[index].id,
          );
          onChapterSelected(newChapter);

          if (!context.mounted) {
            return; // Prevent execution if widget is unmounted
          }

          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          selectedBook.chapters[index].number,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    },
  );
}
