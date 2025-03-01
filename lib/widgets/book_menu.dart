import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/book.dart';
import '../models/bible_version.dart';
import '../services/api_service.dart';

void showBookMenu(
  BuildContext context,
  BibleVersion selectedBibleVersion,
  Book selectedBibleBook,
  Function(Book) onBookSelected,
) async {
  final ApiService apiService = ApiService();
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
