
class User {
  final String id;
  final String? profilePhoto;
  final String name;
  final String email;
  final String? phone;
  final String? whatsapp;
  final String? location;
  User({
    required this.id,
    this.profilePhoto,
    required this.name,
    required this.email,
    this.phone,
    this.whatsapp,
    this.location,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      profilePhoto: json['profile_photo'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      whatsapp: json['whatsapp'].toString().isEmpty ? null : json['whatsapp'],
      location: json['location'],
    );
  }
}
