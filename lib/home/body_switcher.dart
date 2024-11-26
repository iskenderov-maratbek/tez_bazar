import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/app_bar.dart';
import 'package:tez_bazar/bottom_bar.dart';
import 'package:tez_bazar/common/forms/text_field_forms.dart';
import 'package:tez_bazar/home/category_page.dart';
import 'package:tez_bazar/home/product_page.dart';
import 'package:tez_bazar/services/providers.dart';

class BodySwitcher extends ConsumerStatefulWidget {
  const BodySwitcher({super.key});

  @override
  ConsumerState<BodySwitcher> createState() => BodySwitcherState();
}

class BodySwitcherState extends ConsumerState<BodySwitcher> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final showFirstGrid = ref.watch(gridViewStateProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    print("BODY CONTENT");
    print('bodySwitcher state: $showFirstGrid');
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: showFirstGrid ? const CategoryPage() : const ProductsPage(),
    );
  }
}
