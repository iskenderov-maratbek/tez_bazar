class Products {
  final int id;
  final String name;
  final String? photo;
  final double price;

  Products({
    required this.id,
    required this.name,
    this.photo,
    required this.price,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      price: double.parse(json['price']),
    );
  }
}
