import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/views/home/widgets/carousel_sliding.dart';
import 'package:tez_bazar/views/home/widgets/list_of_category.dart';
import 'package:tez_bazar/views/page_builder.dart';

class HomeView extends ConsumerWidget {
  HomeView({super.key});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logView(runtimeType);
    return PageBuilder(
      onRefresh: () async =>
          ref.read(versionProvider.notifier).checkHomeVersion(),
      child: ListView(
        children: [
          SizedBox(height: 10),
          CarouselSliding(),
          // PinButtons(),
          _categoryBuild(),
        ],
      ),
    );
  }

  Container _categoryBuild() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.content,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          textForm(TextConstants.categories, 22),
          SizedBox(height: 20),
          ListOfCategory(),
        ],
      ),
    );
  }
}
