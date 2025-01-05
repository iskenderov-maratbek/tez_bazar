class Banners {
  final int id;
  final String photo;
  final String text;

  Banners({
    required this.id,
    required this.photo,
    required this.text,
  });

  factory Banners.fromJson(Map<String, dynamic> json) {
    return Banners(
      id: json['id'],
      photo: json['photo'],
      text: json['text'],
    );
  }
}
