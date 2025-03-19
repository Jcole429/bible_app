class Verse {
  final String id;
  final String orgId;
  final String bookId;
  final String bibleId;
  final String chapterId;
  final String content;
  final String reference;
  final int verseCount;
  final String? text;

  Verse({
    required this.id,
    required this.orgId,
    required this.bookId,
    required this.bibleId,
    required this.chapterId,
    required this.content,
    required this.reference,
    required this.verseCount,
    this.text,
  });

  // Convert a JSON map to a Country object
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      bookId: json['bookId'] as String,
      bibleId: json['bibleId'] as String,
      chapterId: json['chapterId'] as String,
      content: json['content'] as String,
      reference: json['reference'] as String,
      verseCount: json['verseCount'] as int,
      text: json['text'] as String?,
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
      'content': content,
      'reference': reference,
      'verseCount': verseCount,
      'text': text,
    };
  }
}
