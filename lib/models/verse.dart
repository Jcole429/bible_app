class Verse {
  final String id;
  final String orgId;
  final String bookId;
  final String bibleId;
  final String chapterId;
  final String reference;
  final String text;

  Verse({
    required this.id,
    required this.orgId,
    required this.bookId,
    required this.bibleId,
    required this.chapterId,
    required this.reference,
    required this.text,
  });

  // Convert a JSON map to a Country object
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      bookId: json['bookId'] as String,
      bibleId: json['bibleId'] as String,
      chapterId: json['chapterId'] as String,
      reference: json['reference'] as String,
      text: json['text'] as String,
    );
  }

  // Convert a Country object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orgId': orgId,
      'bookId': bookId,
      'bibleId': bibleId,
      'chapterId': chapterId,
      'reference': reference,
      'text': text,
    };
  }
}
