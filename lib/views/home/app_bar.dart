import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/forms/search_form.dart';
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appBarBackgroundColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          title != null
              ? textForm(
                  title,
                  24,
                  weight: FontWeight.bold,
                  color: AppColors.primaryColor,
                )
              : null,
          // text32bold(title),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SearchForm(
              controller: controller,
              
            ),
          ),
        ],
      ),
    );
  }
}
