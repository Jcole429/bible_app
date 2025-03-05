import 'package:bible_app/models/verse.dart';

class SearchResponse {
  final String query;
  final int limit;
  final int offset;
  final int total;
  final int verseCount;
  final List<Verse> verses;

  SearchResponse({
    required this.query,
    required this.limit,
    required this.offset,
    required this.total,
    required this.verseCount,
    required this.verses,
  });

  // Convert a JSON map to a SearchResponse object
  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      query: json['query'] as String,
      limit: json['limit'] as int,
      offset: json['offset'] as int,
      total: json['total'] as int,
      verseCount: json['verseCount'] as int,
      verses:
          (json['verses'] as List<dynamic>?)
              ?.map((c) => Verse.fromJson(c))
              .toList() ??
          [],
    );
  }

  // Convert a SearchResponse object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'limit': limit,
      'offset': offset,
      'total': total,
      'verseCount': verseCount,
      'verses': verses,
    };
  }
}
