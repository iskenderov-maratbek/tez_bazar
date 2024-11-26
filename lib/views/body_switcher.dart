import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/views/home/category/category_page.dart';
import 'package:tez_bazar/views/home/product/product_page.dart';
import 'package:tez_bazar/providers/providers.dart';

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
      child: showFirstGrid
          ? const CategoryPage(key: PageStorageKey<String>('category_grid'))
          : const ProductsPage(key: PageStorageKey<String>('product_grid')),
    );
  }
}
