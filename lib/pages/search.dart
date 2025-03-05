import 'package:bible_app/models/search_response.dart';
import 'package:bible_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bible_app/utils/bible_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  ApiService apiService = ApiService();
  FocusNode searchFocusNode = FocusNode(canRequestFocus: true);
  SearchResponse? _searchResponse;

  void _onSearchChanged(BibleState bibleState, String query) async {
    SearchResponse? response;
    if (query.isNotEmpty) {
      response = await _performSearch(bibleState, query);
      setState(() {
        _searchResponse = response;
      });
    } else {
      setState(() {
        _searchResponse = null;
      });
    }
  }

  void _onSearchSubmitted(BibleState bibleState, String query) async {
    SearchResponse? response;
    if (query.isNotEmpty) {
      response = await _performSearch(bibleState, query);
      setState(() {
        _searchResponse = response;
      });
    } else {
      setState(() {
        _searchResponse = null;
      });
    }
  }

  Future<SearchResponse> _performSearch(
    BibleState bibleState,
    String query,
  ) async {
    // Replace with your actual search logic.
    // This is a placeholder example.
    return await apiService.fetchSearchResponse(
      bibleState.selectedBible!.id,
      query,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BibleState>(
      builder: (context, bibleState, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Search the Bible"),
            backgroundColor: Colors.grey,
            leadingWidth: 0,
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  autofocus: true,
                  controller: _searchController,
                  onSubmitted: (query) {
                    _onSearchSubmitted(bibleState, query);
                  },
                  focusNode: searchFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              if (_searchResponse != null)
                Text(
                  "Total results: ${_searchResponse!.total} | Displaying Top: ${_searchResponse!.verseCount}",
                ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      _searchResponse != null ? _searchResponse!.limit : 0,
                  itemBuilder: (context, index) {
                    return _buildBibleVerseTile(
                      _searchResponse!.verses[index].reference,
                      _searchResponse!.verses[index].text,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildBibleVerseTile(String reference, String text) {
  return ListTile(
    title: Text(text),
    horizontalTitleGap: -10,
    subtitle: Text(reference),

    // Style bar
    leading: Container(
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(30),
      ),
      width: 4,
      height: 100,
    ),
  );
}
