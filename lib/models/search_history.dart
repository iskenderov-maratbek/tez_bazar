class SearchHistory {
  final String? photo;
  final String name;
  final String description;
  final int price;
  final String priceType;
  final String location;
  final bool delivery;
  final String seller;
  final String phone;
  final String? whatsapp;

  SearchHistory({
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

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      name: json['name'],
      photo: json['photo'],
      price: json['price'],
      priceType: json['price_type'],
      description: json['description'],
      location: json['location'],
      delivery: json['delivery'],
      seller: json['seller'],
      phone: json['phone'],
      whatsapp: json['whatsapp'],
    );
  }
}
