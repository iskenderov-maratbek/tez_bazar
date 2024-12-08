import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tez_bazar/models/categories.dart';
import 'package:tez_bazar/models/products.dart';
import 'package:tez_bazar/models/search_history.dart';
import 'package:tez_bazar/services/category_service.dart';
import 'package:tez_bazar/services/product_service.dart';
import 'package:tez_bazar/services/search_service.dart';

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

final searchProvider =
    StateNotifierProvider<ProductSearchService, List<SearchHistory>>((ref) {
  return ProductSearchService(ref);
});

// Провайдер для состояния авторизации

enum SelectedMenu { home, products, settings }

final currentIndexProvider =
    StateProvider<SelectedMenu>((ref) => SelectedMenu.home);

enum GridPage { category, product, search }

final gridViewStateProvider =
    StateProvider<GridPage>((ref) => GridPage.category);

final scrollProductsProvider = StateProvider<bool>((ref) => true);

final appBarTitleProvider = StateProvider<String?>((ref) => 'Tez Bazar');

final searchActiveProvider = StateProvider<bool>((ref) => false);
