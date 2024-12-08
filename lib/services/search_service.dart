import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/search_history.dart';

class ProductSearchService extends StateNotifier<List<SearchHistory>> {
  ProductSearchService(this.ref) : super([]);
  final Ref ref;
  final int _offset = 0;
  final int _limit = 5;
  bool _loadCompleted = false;
  String _productName = '';

  Future<void> searchProducts({String? productName}) async {
    if (productName != null) _productName = productName;
    if (!_loadCompleted) {
      try {
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: 'search',
              parameters: 'name=$_productName&offset=$_offset&limit=$_limit',
            ),
          ),
        );
        if (response.statusCode == 200) {
          List<SearchHistory> searchHistory = [];
          List<dynamic> data = json.decode(response.body);
          print('!!!!!!!Success: $data');
          if (data.isNotEmpty) {
            searchHistory =
                data.map((item) => SearchHistory.fromJson(item)).toList();
            state = searchHistory;
          }
        } else {
          _loadCompleted = !_loadCompleted;
          print('!!!!!!!!!!!!Error: ${response.statusCode}');
        }
      } catch (e) {
        print('!!!!!!!!!!!!Error: $e');
      }
    }
  }
}
