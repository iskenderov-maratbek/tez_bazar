import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/search_history.dart';
import 'package:tez_bazar/providers/providers.dart';

class ProductSearchService extends StateNotifier<List<SearchHistory>> {
  ProductSearchService(this.ref) : super([]);
  final Ref ref;
  int _offset = 0;
  final int _limit = 10;
  bool _loadCompleted = false;
  String _productName = '';

  getSearchValue() => _productName;

  Future<void> searchProducts({String? productName}) async {
    if (productName != null) _productName = productName;
    if (!_loadCompleted) {
      Future.delayed(Duration.zero, () {
        _offset == 0 ? ref.read(loadingProvider.notifier).state = true : null;
      });
      try {
        logServer('Send Post Requests: /${DbFields.search}');
        final response = await http.post(
          Uri.parse(
            Network.getUrl(
              path: DbFields.search,
            ),
          ),
          body: jsonEncode(
            {
              'name': _productName,
              'offset': _offset,
              'limit': _limit,
            },
          ),
        );

        if (response.statusCode == 200) {
          logServer('Response: OK');
          List<SearchHistory> searchHistory = [];
          List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            searchHistory =
                data.map((item) => SearchHistory.fromJson(item)).toList();
            state = [...state, ...searchHistory];
            _offset += _limit;
          } else {
            _loadCompleted = !_loadCompleted;
          }
        } else {
          logError('${response.statusCode}: ${response.body}');
        }
        Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
          ref.read(loadingProvider.notifier).state = false;
        });
      } catch (e) {
        Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
          ref.read(loadingProvider.notifier).state = false;
        });
        logError(e);
      }
    }
  }

  void clear() {
    state = [];
    _offset = 0;
    _loadCompleted = false;
  }
}
