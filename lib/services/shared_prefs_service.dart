import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tez_bazar/common/logging.dart';

final spServiceProvider = Provider<SharedPrefsService>((ref) {
  final service = SharedPrefsService();
  service.init();
  return service;
});

class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  SharedPreferences? _preferences;
  factory SharedPrefsService() {
    logInfo('SharedPrefsService');
    return _instance;
  }
  SharedPrefsService._internal();
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveTokenSP(String accessToken) async {
    await _preferences?.setString('accessToken', accessToken);
  }

  String? loadTokenSP() {
    logInfo('loadTokenSP');
    return _preferences?.getString('accessToken');
  }

  Future<void> clearSP() async {
    logInfo('clearSP');
    await _preferences?.clear();
  }
}
