import 'package:flutter/material.dart';
import 'package:tez_bazar/common/forms/text_field_forms.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(150.0);
}

class CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(101, 0, 0, 0),
            spreadRadius: 10.0,
            offset: Offset(0, 5.0),
            blurRadius: 10.0,
          )
        ],
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text('TEZ Bazar', style: TextStyle(fontSize: 30)),
          ),
          textFieldSearch(controller),
        ],
      ),
    );
  }
}
