class Category {
  final int id;
  final String name;
  final String? photo;

  Category({
    required this.id,
    required this.name,
    this.photo,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
    );
  }
}
