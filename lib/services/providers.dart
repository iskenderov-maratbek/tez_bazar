import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tez_bazar/models/category.dart';
import 'package:tez_bazar/models/product.dart';
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
  return ProductService();
});

// Провайдер для состояния авторизации
final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  // Метод для авторизации пользователя
  void login() {
    state = true;
  }

  // Метод для выхода пользователя
  void logout() {
    state = false;
  }
}

enum SelectedMenu { home, products, settings }

final currentIndexProvider =
    StateProvider<SelectedMenu>((ref) => SelectedMenu.home);

final gridViewStateProvider = StateProvider<bool>((ref) => true);
