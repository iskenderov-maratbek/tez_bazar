import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/views/home/routes/products/widgets/list_of_products.dart';

class ProductsView extends ConsumerStatefulWidget {
  const ProductsView({super.key});

  @override
  ProductsPageState createState() => ProductsPageState();
}

class ProductsPageState extends ConsumerState<ProductsView> {
  @override
  Widget build(BuildContext context) {
    logView(runtimeType);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListOfProducts(),
        ),
      ],
    );
  }
}
