class User {
  final String id;
  final String? name;
  final String? photo;
  final String email;
  final String? phone;
  User({
    required this.id,
    required this.name,
    required this.photo,
    required this.email,
    required this.phone,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
