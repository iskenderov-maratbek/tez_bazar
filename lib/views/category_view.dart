import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';
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
  bool _isRefreshing = false;

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

  Future<void> _refreshAds() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(loadingProvider.notifier).state = true;

      if (!_isRefreshing) {
        setState(() {
          _isRefreshing = true;
        });
      } else {
        return;
      }
      // Имитация обновления данных
      await Future.delayed(Duration(seconds: ref.read(refreshTimerProvider)));
      setState(() {
        ref.read(categoryProvider.notifier).clear();
        ref.read(categoryProvider.notifier).fetchCategory();
        _isRefreshing = false;

        Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
          ref.read(loadingProvider.notifier).state = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    logInfo(ModalRoute.of(context)?.settings.name);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        logInfo('Popped: $didPop, Result: $result');
      },
      child: RefreshIndicator(
        onRefresh: _refreshAds,
        displacement: 85,
        color: AppColors.primaryColor,
        backgroundColor: AppColors.black,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: GridView.builder(
          padding: GridViewSets.padding(),
          controller: _scrollController,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ElevatedButton(
              onPressed: () {
                ref
                    .read(productProvider.notifier)
                    .selectedCategory(category.id, category.name);
                ref.read(appBarTitleProvider.notifier).state = category.name;
                ref.read(gridViewStateProvider.notifier).state =
                    GridPage.product;
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
                      borderRadius:
                          GridViewSets.itemImageBorderRadius(top: true),
                      child: category.photo != null
                          ? Image.network(category.photo!,
                              fit: BoxFit.cover, width: 120)
                          : noImg(height: 120, fit: BoxFit.cover)),
                  Expanded(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: GridViewSets.itemImageBorderRadius(),
                        color: AppColors.darkGrey,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: textForm(
                              category.name,
                              GridViewSets.itemTitleFontSize(),
                              color: GridViewSets.itemInfoTextColor(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          gridDelegate: GridViewSets.delegateCategory(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
