import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/categories.dart';

class CategoryService extends StateNotifier<List<Category>> {
  CategoryService() : super([]);

  int _offset = 0;
  final int _limit = 5;
  bool _loadCompleted = false;

  Future<void> fetchCategory() async {
    if (!_loadCompleted) {
      try {
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: 'categories',
              parameters: 'offset=$_offset&limit=$_limit',
            ),
          ),
        );
        if (response.statusCode == 200) {
          List<Category> categories = [];
          List<dynamic> data = json.decode(response.body);
          print('!!!!!!!Success: $data');
          if (data.isNotEmpty) {
            categories = data.map((item) => Category.fromJson(item)).toList();
            state = [...state, ...categories];
            _offset += _limit;
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
