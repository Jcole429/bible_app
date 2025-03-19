import 'package:bible_app/models/audio_bible.dart';
import 'package:bible_app/models/country.dart';
import 'package:bible_app/models/language.dart';

class Bible {
  final String id;
  final String dblId;
  final String? relatedDbl;
  final String name;
  final String nameLocal;
  final String abbreviation;
  final String abbreviationLocal;
  final String? description;
  final String? descriptionLocal;
  final Language language;
  final List<Country> countries;
  final String type;
  final DateTime updatedAt;
  final String copyright;
  final String info;
  final List<AudioBible> audioBibles;
  final int? bookCount;
  final String category;
  final bool enabled;

  Bible({
    required this.id,
    required this.dblId,
    this.relatedDbl,
    required this.name,
    required this.nameLocal,
    required String abbreviation,
    required String abbreviationLocal,
    String? description,
    String? descriptionLocal,
    required this.language,
    required this.countries,
    required this.type,
    required this.updatedAt,
    required this.copyright,
    required this.info,
    required this.audioBibles,
    this.bookCount,
    required this.category,
    required this.enabled,
  }) : abbreviation = abbreviation.toUpperCase(),
       abbreviationLocal = abbreviationLocal.toUpperCase(),
       description =
           description != null && description.isNotEmpty
               ? description[0].toUpperCase() + description.substring(1)
               : description,
       descriptionLocal =
           descriptionLocal != null && descriptionLocal.isNotEmpty
               ? descriptionLocal[0].toUpperCase() +
                   descriptionLocal.substring(1)
               : descriptionLocal;

  // Convert a JSON map to a Bible object
  factory Bible.fromJson(Map<String, dynamic> json) {
    return Bible(
      id: json['id'] as String,
      dblId: json['dblId'] as String,
      relatedDbl: json['relatedDbl'] as String?,
      name: json['name'] as String,
      nameLocal: json['nameLocal'] as String,
      abbreviation: json['abbreviation'] as String,
      abbreviationLocal: json['abbreviationLocal'] as String,
      description: json['description'] ?? "",
      descriptionLocal: json['descriptionLocal'] ?? "",
      language: Language.fromJson(json['language']),
      countries:
          (json['countries'] as List<dynamic>?)
              ?.map((c) => Country.fromJson(c))
              .toList() ??
          [], // Handle null case with empty list
      type: json['type'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      copyright: json['copyright'] as String,
      info: json['info'] ?? "[No Info]",
      audioBibles:
          (json['audioBibles'] as List<dynamic>?)
              ?.map((c) => AudioBible.fromJson(c))
              .toList() ??
          [], // Handle null case with empty list,
      bookCount: json['bookCount'] as int?,
      category: json['category'] as String,
      enabled: json['enabled'] as bool,
    );
  }

  // Convert a Bible object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dblId': dblId,
      'relatedDbl': relatedDbl,
      'name': name,
      'nameLocal': nameLocal,
      'abbreviation': abbreviation,
      'abbreviationLocal': abbreviationLocal,
      'description': description,
      'descriptionLocal': descriptionLocal,
      'language': language.toJson(),
      'countries': countries.map((c) => c.toJson()).toList(),
      'type': type,
      'updatedAt': updatedAt.toIso8601String(),
      'copyright': copyright,
      'info': info,
      'audioBibles': audioBibles.map((c) => c.toJson()).toList(),
      'bookCount': bookCount,
      'category': category,
      'enabled': enabled,
    };
  }
}
