import 'package:flutter_tutorial/models/chapter_info.dart';

class Chapter {
  final String id;
  final String? bibleId;
  final String number;
  final String bookId;
  final String? reference;
  final String? copyright;
  final int? verseCount;
  final String? content;
  final Chapter? next;
  final Chapter? previous;

  Chapter({
    required this.id,
    this.bibleId,
    required this.number,
    required this.bookId,
    this.reference,
    this.copyright,
    this.verseCount,
    this.content,
    this.next,
    this.previous,
  });

  // Convert a JSON map to a Chapter object
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String,
      bibleId: json['bibleId'] as String?,
      number: //Capitalize first letter
          json['number'][0].toUpperCase() + json['number'].substring(1),
      bookId: json['bookId'] as String,
      reference: json['reference'] as String?,
      copyright: json['copyright'] as String?,
      verseCount: json['verseCount'] as int?,
      content: json['content'] as String?,
      next:
          json.containsKey('next') && json['next'] != null
              ? Chapter.fromJson(json['next'])
              : null,
      previous:
          json.containsKey('previous') && json['previous'] != null
              ? Chapter.fromJson(json['previous'])
              : null,
    );
  }

  // Convert a Chapter Chapter to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bibleId': bibleId,
      'number': number,
      'bookId': bookId,
      'reference': reference,
      'copyright': copyright,
      'verseCount': verseCount,
      'content': content,
      'next': next,
      'previous': previous,
    };
  }
}
