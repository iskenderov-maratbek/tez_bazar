import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tez_bazar/models/categories.dart';
import 'package:tez_bazar/models/products.dart';
import 'package:tez_bazar/models/selected_product.dart';
import 'package:tez_bazar/services/category_service.dart';
import 'package:tez_bazar/services/product_service.dart';

// Модель данных

// Провайдер для получения данных с пагинацией
final categoryProvider =
    StateNotifierProvider<CategoryService, List<Category>>((ref) {
  return CategoryService();
});

final productProvider =
    StateNotifierProvider<ProductService, List<Products>>((ref) {
  return ProductService(ref);
});

// Провайдер для состояния авторизации

enum SelectedMenu { home, products, settings }

final currentIndexProvider =
    StateProvider<SelectedMenu>((ref) => SelectedMenu.home);

final gridViewStateProvider = StateProvider<bool>((ref) => true);

final scrollProductsProvider = StateProvider<bool>((ref) => true);

final appBarTitleProvider = StateProvider<String>((ref) => 'Tez Bazar');

final selectedProductProvider = StateProvider<SelectedProduct>((ref) =>
    SelectedProduct(
        seller: 'loading...', number: 'loading...', delivery: false));
