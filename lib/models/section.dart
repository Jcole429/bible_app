class Section {
  final String id;
  final String bibleId;
  final String bookId;
  final String title;
  final String firstVerseId;
  final String lastVerseId;
  final String firstVerseOrgId;
  final String lastVerseOrgId;

  Section({
    required this.id,
    required this.bibleId,
    required this.bookId,
    required this.title,
    required this.firstVerseId,
    required this.lastVerseId,
    required this.firstVerseOrgId,
    required this.lastVerseOrgId,
  });

  // Convert a JSON map to a Section object
  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] as String,
      bibleId: json['bibleId'] as String,
      bookId: json['bookId'] as String,
      title: json['title'] as String,
      firstVerseId: json['firstVerseId'] as String,
      lastVerseId: json['lastVerseId'] as String,
      firstVerseOrgId: json['firstVerseOrgId'] as String,
      lastVerseOrgId: json['lastVerseOrgId'] as String,
    );
  }

  // Convert a Section object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bibleId': bibleId,
      'bookId': bookId,
      'title': title,
      'lastVerseId': lastVerseId,
      'firstVerseId': firstVerseId,
      'lastVerseOrgId': lastVerseOrgId,
      'firstVerseOrgId': firstVerseOrgId,
    };
  }
}
