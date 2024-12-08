import 'package:flutter/material.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/profile_forms.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _whatsappNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 180, bottom: 100),
      children: [
        TFForms(controller: _usernameController),
        TFForms(controller: _usernameController),
        TFForms(controller: _usernameController),
      ],
    );
  }
}
