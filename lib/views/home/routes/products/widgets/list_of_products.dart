import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/models/products.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/common/grid_view_sets.dart';
import 'package:tez_bazar/views/home/routes/products/utils/bottom_sheet.dart';
import 'package:tez_bazar/views/page_builder.dart';

class ListOfProducts extends ConsumerStatefulWidget {
  const ListOfProducts({super.key});

  @override
  ProductsPageState createState() => ProductsPageState();
}

class ProductsPageState extends ConsumerState<ListOfProducts> {
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
    logView(runtimeType);
    final products = ref.watch(productProvider);
    return PageBuilder(
      onRefresh: () async {
        ref.read(productProvider.notifier).clear();
        ref.read(productProvider.notifier).getProductFromCategory();
      },
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: GridViewSets.padding(),
        controller: _scrollController,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildElements(context, product);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Количество столбцов
          crossAxisSpacing: 10, // Отступ между столбцами
          mainAxisSpacing: 10, // Отступ между строками
          childAspectRatio: 0.7, // Соотношение сторон элементов
        ),
      ),
    );
  }

  ElevatedButton _buildElements(BuildContext context, Products product) {
    final double priceFontSize = 16;
    return ElevatedButton(
      onPressed: () {
        bottomSheet(ref, context, product);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: GridViewSets.itemImageBorderRadius(top: true),
            child: product.photo != null
                ? Image.network(product.photo!, fit: BoxFit.cover, width: 120)
                : noImg(fit: BoxFit.cover),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: GridViewSets.itemImageBorderRadius(),
                color: AppColors.backgroundColor,
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
                    right: 10,
                    bottom: 10,
                    child: setPrice(product.price, priceFontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
