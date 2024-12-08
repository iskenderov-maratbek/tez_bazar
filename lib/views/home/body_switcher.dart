import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/views/category_view.dart';
import 'package:tez_bazar/views/search_view.dart';
import 'package:tez_bazar/views/product_view.dart';
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
    final gridPage = ref.watch(gridViewStateProvider);
    print("BODY CONTENT");
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
        child: switch (gridPage) {
          GridPage.category =>
            const CategoryView(key: PageStorageKey<String>('category_grid')),
          GridPage.product =>
            const ProductsView(key: PageStorageKey<String>('product_grid')),
          GridPage.search =>
            const SearchView(key: PageStorageKey<String>('search_grid')),
        });
  }
}
