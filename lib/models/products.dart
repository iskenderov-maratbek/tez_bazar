class Products {
  final String? photo;
  final String name;
  final String? description;
  final double price;
  final String? location;
  final bool delivery;
  final String seller;
  final String number;
  final String? whatsapp;

  Products({
    required this.name,
    this.photo,
    required this.price,
    this.description,
    this.location,
    required this.delivery,
    required this.seller,
    required this.number,
    this.whatsapp,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'],
      photo: json['photo'],
      price: double.parse(json['price']),
      description: json['description'],
      location: json['location'],
      delivery: json['delivery'],
      seller: json['seller'],
      number: json['number'],
      whatsapp: json['whatsapp'],
    );
  }
}
