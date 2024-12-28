class Products {
  final String name;
  final String? photo;
  final String description;
  final int price;
  final String priceType;
  final String location;
  final bool delivery;
  final String seller;
  final String? phone;
  final String? whatsapp;

  Products({
    required this.name,
    this.photo,
    required this.price,
    required this.priceType,
    required this.description,
    required this.location,
    required this.delivery,
    required this.seller,
    required this.phone,
    this.whatsapp,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      name: json['name'],
      photo: json['photo'],
      description: json['description'],
      price: json['price'],
      priceType: json['price_type'],
      seller: json['seller'],
      location: json['location'],
      delivery: json['delivery'],
      phone: json['phone'],
      whatsapp: json['whatsapp'],
    );
  }
}
