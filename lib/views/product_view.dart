import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/widgets/bottom_sheet_sets.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/common/grid_view_sets.dart';
import 'package:tez_bazar/views/info_view.dart';

final List<int> colorCodes = <int>[600, 500, 100];

class ProductsView extends ConsumerStatefulWidget {
  const ProductsView({super.key});

  @override
  ProductsPageState createState() => ProductsPageState();
}

class ProductsPageState extends ConsumerState<ProductsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.read(productProvider.notifier).getProductFromCategory();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(productProvider.notifier).getProductFromCategory();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Build ProductsPage');
    final products = ref.watch(productProvider);
    return GridView.builder(
      padding: GridViewSets.padding(),
      controller: _scrollController,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              enableDrag: BottomSheetSets.enableDrag,
              // scrollControlDisabledMaxHeightRatio: 4,
              backgroundColor: BottomSheetSets.backgroundColor,
              context: context,
              isScrollControlled: BottomSheetSets.fullScreenView,
              builder: (context) {
                return InfoView(
                  name: product.name,
                  price: product.price,
                  photo: product.photo,
                  description: product.description,
                  delivery: product.delivery,
                  seller: product.seller,
                  location: product.location,
                  number: product.number,
                  whatsapp: product.whatsapp,
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: GridViewSets.itemImageBorderRadius(top: true),
                child: Image.asset(
                  // product.photo ??
                  'lib/assets/images/200.png',
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: GridViewSets.itemImageBorderRadius(),
                    gradient: GridViewSets.itemInfoBackgroundColor(),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 5,
                        child: textForm(
                          product.name,
                          GridViewSets.itemTitleFontSize(),
                          color: GridViewSets.itemInfoTextColor(),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 65,
                          height: 20,
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            textForm('${product.price}', 16,
                                weight: FontWeight.w900,
                                textAlign: TextAlign.end),
                            SizedBox(
                              width: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: setCurrency(8),
                            ),
                          ],
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Количество столбцов
        crossAxisSpacing: 10, // Отступ между столбцами
        mainAxisSpacing: 10, // Отступ между строками
        childAspectRatio: 0.7, // Соотношение сторон элементов
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
