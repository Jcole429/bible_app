class Country {
  final String id;
  final String name;
  final String nameLocal;

  Country({required this.id, required this.name, required this.nameLocal});

  // Convert a JSON map to a Country object
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as String,
      name: json['name'] as String,
      nameLocal: json['nameLocal'] as String,
    );
  }

  // Convert a Country object to a JSON map
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'nameLocal': nameLocal};
  }
}
