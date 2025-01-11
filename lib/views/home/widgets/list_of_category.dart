import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/common/grid_view_sets.dart';

final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

class ListOfCategory extends ConsumerStatefulWidget {
  const ListOfCategory({super.key});

  @override
  CategoryPageState createState() => CategoryPageState();
}

class CategoryPageState extends ConsumerState<ListOfCategory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logView('CategoryPageState');
    final categories = ref.watch(categoriesProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        logInfo('Popped: $didPop, Result: $result');
      },
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 0, top: 0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ElevatedButton(
            onPressed: () {
              ref
                  .read(productProvider.notifier)
                  .selectedCategory(category.id, category.name);
              ref.read(appBarTitleProvider.notifier).state = category.name;
              ref.read(homeStateProvider.notifier).state = HomeState.category;
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                color: AppColors.transparent,
                child: Stack(
                  children: [
                    category.photo != null
                        ? networkImg(
                            src: category.photo!,
                            width: 200,
                            height: 150,
                            size: 40)
                        : noImg(width: 200, height: 150, fit: BoxFit.cover),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor.withOpacity(.8),
                        ),
                        child: Center(
                          child: textForm(
                            category.name,
                            14,
                            color: GridViewSets.itemInfoTextColor(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10.0, // Рассстояние между столбцами
          mainAxisSpacing: 10.0, // Рассстояние между строками
          childAspectRatio: 1.2, // Соотношение сторон
          crossAxisCount: 3, // Количество столбцов
        ),
      ),
    );
  }
}
