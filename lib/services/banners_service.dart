import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/constants/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/banners.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/request_service.dart';

class BannersService extends StateNotifier<List<Banners>> {
  final Ref ref;
  final RequestService requestService;
  BannersService(this.ref)
      : requestService = ref.read(requestServiceProvider),
        super([]);

  setData(List<Banners> data) {
    state = data;
  }

  Future<void> fetchData() async {
    return await requestService.sendRequest<void>(
      () async {
        logServer('Send Post Requests: /${DbFields.getBanners}');
        final response = await http.get(
          Uri.parse(
            Network.getUrl(
              path: DbFields.getBanners,
            ),
          ),
        );
        if (response.statusCode == 200) {
          List<Banners> banners = [];
          List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            banners =
                data.map<Banners>((item) => Banners.fromJson(item)).toList();
            state = banners;
          } else {
            logServer('No data');
            throw Exception('No data');
          }
        }
      },
    );
  }
}
