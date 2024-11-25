import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/app_bar.dart';
import 'package:tez_bazar/bottom_bar.dart';
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
    return Scaffold(
      appBar: customAppBar(context, context, currentIndex),
      body: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: showFirstGrid ? const CategoryPage() : const ProductsPage(),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
