import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/constants/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/categories.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/request_service.dart';

class CategoriesService extends StateNotifier<List<Category>> {
  Ref ref;
  final RequestService requestService;
  CategoriesService(this.ref)
      : requestService = ref.read(requestServiceProvider),
        super([]);

  setData(List<Category> data) {
    state = data;
  }

  Future<void> fetchData() async {
    return await requestService.sendRequest<void>(
      () async {
        logServer('Send Post Requests: /${DbFields.getCategories}');
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: DbFields.getCategories,
            ),
          ),
        );
        if (response.statusCode == 200) {
          List<Category> categories = [];
          List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            categories = data.map((item) => Category.fromJson(item)).toList();
            state = categories;
          } else {
            logServer('No data');
            throw Exception('No data');
          }
        }
      },
    );
  }

  
}
