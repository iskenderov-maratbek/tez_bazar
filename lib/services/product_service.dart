import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/products.dart';
import 'package:http/http.dart' as http;

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
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: 'products',
              parameters:
                  'type=$_selectedCategory&offset=$_offset&limit=$_limit',
            ),
          ),
        );
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
}
