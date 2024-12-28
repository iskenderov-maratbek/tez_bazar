import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/ads.dart';
import 'package:http/http.dart' as http;

class AdsService extends StateNotifier<List<Ads>> {
  int _offset = 0;
  final int _limit = 10;
  bool _loadCompleted = false;
  String? _categoryName;
  AdsService() : super([]);

  getSelectedCategory() => _categoryName;

  void getAds(String id) async {
    if (!_loadCompleted) {
      try {
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
          List<Ads> ads = [];
          List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            ads = data.map((item) => Ads.fromJson(item)).toList();
            state = [...state, ...ads];
            _offset += _limit;
          } else {
            _loadCompleted = !_loadCompleted;
          }
        }
      } catch (e) {
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
