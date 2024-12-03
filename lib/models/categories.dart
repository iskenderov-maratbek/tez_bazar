class Category {
  final int id;
  final String name;
  final String? photo;
  final int pieces;

  Category(
      {required this.id,
      required this.name,
      required this.photo,
      required this.pieces});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      pieces: json['pieces'],
    );
  }
}
