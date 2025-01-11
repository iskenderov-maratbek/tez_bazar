import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/constants/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/products.dart';
import 'package:http/http.dart' as http;
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/request_service.dart';

class ProductService extends StateNotifier<List<Products>> {
  Ref ref;
  int _offset = 0;
  final int _limit = 10;
  bool _loadCompleted = false;
  int _selectedCategory = 0;
  String? _categoryName;
  final RequestService requestService;

  ProductService(this.ref)
      : requestService = ref.read(requestServiceProvider),
        super([]);

  selectedCategory(int categoryId, String? categoryName) {
    _selectedCategory = categoryId;
    _categoryName = categoryName;
    _offset = 0;
    _loadCompleted = false;
    state = [];
  }

  getSelectedCategory() => _categoryName;

  void getProductFromCategory({int? type}) async {
    if (type != null) _selectedCategory = type;
    if (!_loadCompleted) {
      await requestService.sendRequest(() async {
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: DbFields.getProducts,
              parameters:
                  'category_id=$_selectedCategory&offset=$_offset&limit=$_limit',
            ),
          ),
        );
        if (response.statusCode == 200) {
          List<Products> products = [];
          List<dynamic> data = json.decode(response.body);
          logServer(data);

          if (data.isNotEmpty) {
            products = data.map((item) => Products.fromJson(item)).toList();
            state = [...state, ...products];
            _offset += _limit;
          } else {
            _loadCompleted = !_loadCompleted;
          }
        }
      });
    }
  }

  void clear() {
    state = [];
    _offset = 0;
    _loadCompleted = false;
  }
}
