import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/search_form.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/providers/providers.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(170);
}

class CustomAppBarState extends ConsumerState<CustomAppBar> {
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = ref.watch(appBarTitleProvider);
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 0),
      decoration: BoxDecoration(
        color: AppColors.darkgrey,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0, 0),
            spreadRadius: 3,
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 0,
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: AppColors.primaryColor,
                  size: 30,
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: textForm(
                      title ?? '',
                      24,
                      textAlign: TextAlign.center,
                      weight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 75,
                // color: AppColors.whatasapp,
                child: SearchForm(
                  focusNode: _focusNode,
                  controller: controller,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
