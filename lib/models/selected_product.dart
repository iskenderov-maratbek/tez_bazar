class SelectedProduct {
  final String seller;
  final String? location;
  final String number;
  final String? description;
  final bool delivery;

  SelectedProduct({
    required this.seller,
    this.location,
    required this.number,
    this.description,
    required this.delivery,
  });

  factory SelectedProduct.fromJson(Map<String, dynamic> json) {
    return SelectedProduct(
      seller: json['name'],
      location: json['location'],
      number: json['number'],
      description: json['description'],
      delivery: json['delivery'],
    );
  }
}
