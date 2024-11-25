import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Модель данных
class Category {
  final int id;
  final String name;
  final String? photo;
  final int pieces;

  Category(
      {required this.id,
      required this.name,
      required this.photo,
      required this.pieces});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      pieces: json['pieces'],
    );
  }
}

class Products {
  final int id;
  final String name;
  final String? photo;
  final double price;
  final DateTime dateOfAdded;
  final String description;
  final String location;
  final bool delivery;

  Products({
    required this.id,
    required this.name,
    this.photo,
    required this.price,
    required this.dateOfAdded,
    required this.description,
    required this.location,
    required this.delivery,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      price: double.parse(json['price']),
      dateOfAdded: DateTime.parse(json['date_of_added']),
      description: json['description'],
      location: json['location'],
      delivery: json['delivery'],
    );
  }
}

// Провайдер для получения данных с пагинацией
final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  return CategoryNotifier();
});

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]);

  int _offset = 0;
  final int _limit = 5;

  Future<void> fetchCategory() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.103:3000/category?offset=$_offset&limit=$_limit'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('!!!!!!!Success: $data');
        List<Category> products =
            data.map((item) => Category.fromJson(item)).toList();
        state = [...state, ...products];
        _offset += _limit;
      }
    } catch (e) {
      print('!!!!!!!!!!!!Error: $e');
    }
  }
}

final productProvider =
    StateNotifierProvider<ProductNotifier, List<Products>>((ref) {
  return ProductNotifier();
});

class ProductNotifier extends StateNotifier<List<Products>> {
  ProductNotifier() : super([]);

  void searchProducts(int type) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.103:3000/products?type=$type'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('BEFORE ADDED: $data');
      List<Products> products =
          data.map((item) => Products.fromJson(item)).toList();
      state = products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}

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
