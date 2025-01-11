import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/constants/db_fields.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/request_service.dart';

import 'package:tez_bazar/services/secure_stogare_service.dart';

class VersionService extends StateNotifier<String?> {
  final RequestService requestService;
  Ref ref;

  VersionService(this.ref)
      : requestService = ref.read(requestServiceProvider),
        super(null);

//HomeVersion---------------------------------------------------------------------sssdasd

  Future<void> checkHomeVersion() async {
    await requestService.sendRequest<void>(() async {
      final homeVersion =
          await ref.read(spServiceProvider).loadData(DbFields.homeVersionKey) ??
              '0.0.0';
      logInfo('checkVersion state: $homeVersion');
      final response = await http.get(
          Uri.parse(
            Network.getUrl(path: DbFields.getHomeVersion),
          ),
          headers: {DbFields.homeVersionKey: homeVersion});

      if (response.statusCode == 200) {
        //load from db
      } else if (response.statusCode == 201) {
        logInfo('responseHeaders: ${response.headers}');
        final serverVersion = response.headers[DbFields.homeVersionKey];
        logInfo('serverVersion: $serverVersion');
        _homeVersionHandler(
            homeVersion, serverVersion!, DbFields.homeVersionKey);
      } else {
        throw Exception('Не удалось загрузить версию с сервера');
      }
    });
    // Замените на ваш URL
  }

  _homeVersionHandler(
      String clientVerion, String serverVersion, String key) async {
    List<int> oldVersion = clientVerion.split('.').map(int.parse).toList();
    List<int> newVersion = serverVersion.split('.').map(int.parse).toList();
    if (newVersion[0] > oldVersion[0]) {
      logInfo('New App Version');
    }
    if (newVersion[1] > oldVersion[1]) {
      if (newVersion[2] > oldVersion[2]) {
        ref.read(mainServiceProvider).getMainData();
      } else {
        ref.read(categoriesProvider.notifier).fetchData();
      }
    } else if (newVersion[2] > oldVersion[2]) {
      ref.read(bannersProvider.notifier).fetchData();
    }
    logServer('oldVersion: $oldVersion');
    logServer('newVersion: $newVersion');
    await ref
        .read(spServiceProvider)
        .updateData(key: DbFields.homeVersionKey, data: serverVersion);
  }
}
