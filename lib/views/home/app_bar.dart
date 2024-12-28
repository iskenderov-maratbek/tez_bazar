import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
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
  @override
  Widget build(BuildContext context) {
    final title = ref.watch(appBarTitleProvider);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.appBarBackgroundColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            textForm(
              title,
              24,
              weight: FontWeight.bold,
              color: AppColors.primaryColor,
            )
          else
            Container(),
          // text32bold(title),
        ],
      ),
    );
  }
}
