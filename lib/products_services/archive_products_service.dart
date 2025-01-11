import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/constants/db_fields.dart';
import 'package:tez_bazar/models/archive_products.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/request_service.dart';
import 'package:http/http.dart' as http;

class ArchiveProductsService extends StateNotifier<List<ArchiveProducts>> {
  final Ref ref;
  final RequestService requestService;
  ArchiveProductsService(this.ref)
      : requestService = ref.read(requestServiceProvider),
        super([]);
  bool _loadCompleted = false;
  int _offset = 0;
  final int _limit = 10;

  void getUserProducts(String id) async {
    if (!_loadCompleted) {
      logInfo('loadCompleted: $_loadCompleted');
      await requestService.sendRequest<void>(() async {
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: DbFields.getArchiveProducts,
              parameters: 'id=$id&offset=$_offset&limit=$_limit',
            ),
          ),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          logServer('data: $data');
          if (data.isNotEmpty) {
            final result = data.map((item) {
              return ArchiveProducts.fromJson(item);
            }).toList();

            state = [...state, ...result];
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
