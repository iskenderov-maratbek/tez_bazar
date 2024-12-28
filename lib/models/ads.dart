class Ads {
  final int id;
  final String? photo;
  final int categoryId;
  final String name;
  final String description;
  final int price;
  final String priceType;
  final String location;
  final bool delivery;
  final String status;

  Ads({
    required this.id,
    required this.name,
    required this.status,
    this.photo,
    required this.price,
    required this.categoryId,
    required this.priceType,
    required this.description,
    required this.location,
    required this.delivery,
  });

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      name: json['name'],
      photo: json['photo'],
      price: json['price'],
      categoryId: json['category_id'],
      priceType: json['price_type'],
      description: json['description'],
      location: json['location'],
      delivery: json['delivery'],
      status: json['status'],
      id: json['id'],
    );
  }

  
}
