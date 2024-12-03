import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/forms/text_field_forms.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/providers/providers.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(150.0);
}

class CustomAppBarState extends ConsumerState<CustomAppBar> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final title = ref.watch(appBarTitleProvider);
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: text32bold(title),
          ),
          textFieldSearch(controller),
        ],
      ),
    );
  }
}
