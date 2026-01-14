class HeroModel {
  final String id;
  final String name;
  final String power;
  final String alignment;

  HeroModel({
    required this.id,
    required this.name,
    required this.power,
    required this.alignment,
  });

  factory HeroModel.fromMap(Map<String, dynamic> map, String documentId) {
    return HeroModel(
      id: documentId,
      name: map['name'] ?? '',
      power: map['power'] ?? '',
      alignment: map['alignment'] ?? 'hero',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'power': power, 'alignment': alignment};
  }
}
