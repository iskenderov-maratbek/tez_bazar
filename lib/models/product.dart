class Products {
  final int id;
  final String name;
  final String? photo;
  final double price;
  final DateTime dateOfAdded;
  final String description;
  final String location;
  final bool delivery;

  Products({
    required this.id,
    required this.name,
    this.photo,
    required this.price,
    required this.dateOfAdded,
    required this.description,
    required this.location,
    required this.delivery,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      price: double.parse(json['price']),
      dateOfAdded: DateTime.parse(json['date_of_added']),
      description: json['description'],
      location: json['location'],
      delivery: json['delivery'],
    );
  }
}
