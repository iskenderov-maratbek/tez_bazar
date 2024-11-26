import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService extends StateNotifier<List<Products>> {
  ProductService() : super([]);

  bool _loadCompleted = false;
  void searchProducts(int type) async {
    if (!_loadCompleted) {
      try {
        final response = await http
            .get(Uri.parse('http://192.168.1.103:3000/products?type=$type'));
        if (response.statusCode == 200) {
          List<Products> products = [];
          List<dynamic> data = json.decode(response.body);
          print('BEFORE ADDED: $data');
          if (data.isNotEmpty) {
            products = data.map((item) => Products.fromJson(item)).toList();
            state = products;
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
