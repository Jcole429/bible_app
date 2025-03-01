class Chapter {
  final String id;
  final String bibleId;
  final String number;
  final String bookId;
  final String? reference;

  Chapter({
    required this.id,
    required this.bibleId,
    required this.number,
    required this.bookId,
    this.reference,
  });

  // Convert a JSON map to a BibleVersion object
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as String,
      bibleId: json['bibleId'] as String,
      number: //Capitalize first letter
          json['number'][0].toUpperCase() + json['number'].substring(1),
      bookId: json['bookId'] as String,
      reference: json['reference'] as String?,
    );
  }

  // Convert a BibleVersion object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': bibleId,
      'number': number,
      'bookId': bookId,
      'reference': reference,
    };
  }
}
