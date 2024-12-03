import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/models/products.dart';
import 'package:http/http.dart' as http;
import 'package:tez_bazar/models/selected_product.dart';
import 'package:tez_bazar/providers/providers.dart';

class ProductService extends StateNotifier<List<Products>> {
  final Ref ref;
  int _offset = 0;
  final int _limit = 5;
  bool _loadCompleted = false;
  int _selectedCategory = 0;
  ProductService(this.ref) : super([]);

  set selectedCategory(int categoryId) {
    _selectedCategory = categoryId;
    _offset = 0;
    _loadCompleted = false;
    state = [];
  }

  void getProductFromCategory({int? type}) async {
    if (type != null) _selectedCategory = type;
    if (!_loadCompleted) {
      try {
        final response = await http.get(Uri.parse(
            'http://192.168.1.103:3000/products?type=$_selectedCategory&offset=$_offset&limit=$_limit'));
        if (response.statusCode == 200) {
          List<Products> products = [];
          print('PRODUCT INFO PRPR:');
          print(json.decode(response.body));
          List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            products = data.map((item) => Products.fromJson(item)).toList();
            state = [...state, ...products];
            _offset += _limit;
            print('ADDED: $products');
          } else {
            _loadCompleted = !_loadCompleted;
          }
        }
      } catch (e) {
        print('!!!!!!!!!!!!Error: $e');
      }
    }
  }

  getProductInfo(int selectedProduct) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.103:3000/getProductInfo?id=$selectedProduct'));
      print('RESPONSEED ${response.body}');
      if (response.statusCode == 200) {
        print('PRODUCT INFO SELSEL:');
        print(json.decode(response.body));
        final selectedProductData =
            SelectedProduct.fromJson(json.decode(response.body));
        ref.read(selectedProductProvider.notifier).state = selectedProductData;
      }
    } catch (e) {
      print('!!!!!!!!!!!!Error: $e');
    }
    return null;
  }
}
