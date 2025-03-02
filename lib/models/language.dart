class Language {
  final String id;
  final String name;
  final String nameLocal;
  final String script;
  final String scriptDirection;

  Language({
    required this.id,
    required this.name,
    required this.nameLocal,
    required this.script,
    required this.scriptDirection,
  });

  // Convert a JSON map to a Language object
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as String,
      name: json['name'] as String,
      nameLocal: json['nameLocal'] as String,
      script: json['script'] as String,
      scriptDirection: json['scriptDirection'] as String,
    );
  }

  // Convert a Language object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameLocal': nameLocal,
      'script': script,
      'scriptDirection': scriptDirection,
    };
  }
}
