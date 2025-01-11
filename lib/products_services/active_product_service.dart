import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/constants/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/user_products.dart';
import 'package:http/http.dart' as http;
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/request_service.dart';

class ActiveProductService extends StateNotifier<List<ActiveProducts>> {
  int _offset = 0;
  final int _limit = 10;
  bool _loadCompleted = false;
  final Ref ref;
  final RequestService requestService;
  ActiveProductService(this.ref)
      : requestService = ref.read(requestServiceProvider),
        super([]);

  void getUserProducts(String id) async {
    if (!_loadCompleted) {
      await requestService.sendRequest<void>(
        () async {
          final response = await http.get(
            Uri.parse(
              Network.getUrl(
                path: DbFields.getActiveProducts,
                parameters: 'id=$id&offset=$_offset&limit=$_limit',
              ),
            ),
          );
          if (response.statusCode == 200) {
            logServer('Response: OK');

            final data = json.decode(response.body);
            logServer('data: $data');
            if (data.isNotEmpty) {
              final activeProducts = data.map((item) {
                return ActiveProducts.fromJson(item);
              }).toList();

              state = [...state, ...activeProducts];
              _offset += _limit;
            } else {
              _loadCompleted = !_loadCompleted;
            }
          }
        },
      );
    }
  }

  void clear() {
    state = [];
    _offset = 0;
    _loadCompleted = false;
  }
}
