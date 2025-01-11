import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tez_bazar/common/logging.dart';

final spServiceProvider = Provider<SecureStorageService>((ref) {
  final service = SecureStorageService();
  service.init();
  return service;
});

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  factory SecureStorageService() {
    logInfo('SharedPrefsService');
    return _instance;
  }
  SecureStorageService._internal();
  Future<void> init() async {}

  Future<void> updateData({required String key, required String data}) async {
    await _secureStorage.write(key: key, value: data);
  }

  Future<String?> loadData(String key) async {
    logInfo('loadData: $key');
    return await _secureStorage.read(key: key);
  }

  Future<void> clearSP() async {
    logInfo('clearSP');
    await _secureStorage.deleteAll();
  }
}
