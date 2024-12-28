import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/categories.dart';
import 'package:tez_bazar/providers/providers.dart';

class CategoryService extends StateNotifier<List<Category>> {
  CategoryService(this.ref) : super([]);
  Ref ref;
  int _offset = 0;
  final int _limit = 10;
  bool _loadCompleted = false;

  Future<void> fetchCategory() async {
    if (!_loadCompleted) {
      Future.delayed(Duration.zero, () {
        _offset == 0 ? ref.read(loadingProvider.notifier).state = true : null;
      });
      try {
      logServer('Send Post Requests: /${DbFields.getCategories}');
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: DbFields.getCategories,
              parameters: 'offset=$_offset&limit=$_limit',
            ),
          ),
        );
        if (response.statusCode == 200) {
          List<Category> categories = [];
          List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            categories = data.map((item) => Category.fromJson(item)).toList();
            state = [...state, ...categories];
            _offset += _limit;
          } else {
            _loadCompleted = !_loadCompleted;
          }
          Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
            ref.read(loadingProvider.notifier).state = false;
          });
        }
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
