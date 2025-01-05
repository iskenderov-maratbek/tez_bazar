import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/constants/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/user_products.dart';
import 'package:http/http.dart' as http;
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/request_service.dart';

class UserProductService extends StateNotifier<List<UserProducts>> {
  int _offset = 0;
  final int _limit = 10;
  bool _loadCompleted = false;
  String? _categoryName;
  final Ref ref;
  final RequestService requestService;
  UserProductService(this.ref)
      : requestService = ref.read(requestServiceProvider),
        super([]);

  getSelectedCategory() => _categoryName;

  void getAds(String id) async {
    if (!_loadCompleted) {
      await requestService.sendRequest<void>(() async {
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: DbFields.getAds,
              parameters: 'id=$id&offset=$_offset&limit=$_limit',
            ),
          ),
        );
        if (response.statusCode == 200) {
          logServer('Response: OK');
          List<UserProducts> ads = [];
          List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            ads = data.map((item) => UserProducts.fromJson(item)).toList();
            state = [...state, ...ads];
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
