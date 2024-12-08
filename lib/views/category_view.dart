import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/common/grid_view_sets.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

class CategoryView extends ConsumerStatefulWidget {
  const CategoryView({super.key});

  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends ConsumerState<CategoryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.read(categoryProvider.notifier).fetchCategory();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(categoryProvider.notifier).fetchCategory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);

    return GridView.builder(
      padding: GridViewSets.padding(),
      controller: _scrollController,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ElevatedButton(
          onPressed: () {
            ref.read(productProvider.notifier).selectedCategory = category.id;
            ref.read(appBarTitleProvider.notifier).state = category.name;
            ref.read(gridViewStateProvider.notifier).state = GridPage.product;
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: GridViewSets.itemImageBorderRadius(top: true),
                child: Image.asset(
                  'lib/assets/images/200.png',
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: GridViewSets.itemImageBorderRadius(),
                    gradient: GridViewSets.itemInfoBackgroundColor(),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 5,
                        right: 5,
                        child: textForm(
                          category.name,
                          GridViewSets.itemTitleFontSize(),
                          color: GridViewSets.itemInfoTextColor(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 20,
                          height: 15,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.backgroundColor,
                                offset: Offset(-3, -3),
                                spreadRadius: 15,
                                blurRadius: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: textForm('${category.pieces}', 16,
                            weight: FontWeight.w900, textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      gridDelegate: GridViewSets.delegate(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
