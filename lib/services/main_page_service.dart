import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tez_bazar/constants/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/banners.dart';
import 'package:tez_bazar/models/categories.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/request_service.dart';

class MainService {
  final RequestService requestService;
  Ref ref;

  MainService(this.ref) : requestService = ref.read(requestServiceProvider);

  Future<void> getMainData() async {
    return await requestService.sendRequest<void>(
      () async {
        logServer('Send Post Requests: /${DbFields.getMainData}');
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: DbFields.getMainData,
            ),
          ),
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            final List<dynamic> categories = data[0]['categories'];
            final List<dynamic> banners = data[1]['banners'];

            ref.read(bannersProvider.notifier).setData(banners
                .map<Banners>((item) => Banners.fromJson(item))
                .toList());
            ref.read(categoriesProvider.notifier).setData(categories
                .map<Category>((item) => Category.fromJson(item))
                .toList());
          } else {
            logServer('No data');
            throw Exception('No data');
          }
        }
      },
    );
  }
}
