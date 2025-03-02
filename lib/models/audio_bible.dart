class AudioBible {
  final String id;
  final String name;
  final String nameLocal;
  final String dblId;

  AudioBible({
    required this.id,
    required this.name,
    required this.nameLocal,
    required this.dblId,
  });

  // Convert a JSON map to a AudioBible object
  factory AudioBible.fromJson(Map<String, dynamic> json) {
    return AudioBible(
      id: json['id'] as String,
      name: json['name'] as String,
      nameLocal: json['nameLocal'] as String,
      dblId: json['dblId'] as String,
    );
  }

  // Convert a AudioBible object to a JSON map
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'nameLocal': nameLocal, 'dblId': dblId};
  }
}
