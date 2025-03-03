import 'package:bible_app/models/chapter.dart';

class Book {
  final String id;
  final String bibleId;
  final String abbreviation;
  final String name;
  final String nameLong;
  final List<Chapter> chapters;

  Book({
    required this.id,
    required this.bibleId,
    required this.abbreviation,
    required this.name,
    required this.nameLong,
    required this.chapters,
  });

  // Convert a JSON map to a Boook object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      bibleId: json['bibleId'] as String,
      abbreviation: json['abbreviation'] as String,
      name: json['name'] as String,
      nameLong: json['nameLong'] as String,
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((c) => Chapter.fromJson(c))
              .toList() ??
          [], // Handle null case with empty list,
    );
  }

  // Convert a Boook object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bibleId': bibleId,
      'abbreviation': abbreviation,
      'name': name,
      'nameLong': nameLong,
      'chapters': chapters.map((c) => c.toJson()).toList(),
    };
  }
}
