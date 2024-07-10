class Adopts {
  int ids;
  String names;
  String types;
  String descriptions;
  String images;

  Adopts({required this.ids, required this.names, required this.types, required this.descriptions, required this.images });
  factory Adopts.fromJson(Map<String, dynamic> json) {
    return Adopts(
    ids: json['id'] as int,
    names: json['name'] as String,
    types: json['type'] as String,
    descriptions: json['description'] as String,
    images: json['image'] as String,
    );
  }
}