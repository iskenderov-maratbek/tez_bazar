import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/user.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/auth_service.dart';
import 'package:tez_bazar/services/shared_prefs_service.dart';
import 'package:tez_bazar/texts/text_constants.dart';

final userServiceProvider = StateNotifierProvider<UserService, User?>((ref) {
  return UserService(ref);
});

class UserService extends StateNotifier<User?> {
  final Ref ref;
  UserService(this.ref) : super(null);

  Future<void> addAd({
    File? image,
    required String name,
    required String description,
    required int price,
    required String priceType,
    required String location,
    required bool delivery,
    required int categoryId,
  }) async {
    ref.read(loadingProvider.notifier).state = true;
    try {
      final token = ref.read(spServiceProvider).loadTokenSP();
      final userId = ref.read(authServiceProvider)?.id;

      final jsonData = {
        DbFields.productNAME: name,
        DbFields.productDESCRIPTION: description,
        DbFields.productPRICE: price,
        DbFields.productPRICETYPE: priceType,
        DbFields.productLOCATION: location,
        DbFields.productDELIVERY: delivery,
        DbFields.productCATEGORYID: categoryId,
        DbFields.productUSERID: userId,
      };
      if (image != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse(
            Network.getUrl(
              path: DbFields.addAdWithFile,
            ),
          ),
        );
        request.files.add(
            await http.MultipartFile.fromPath(DbFields.imageKey, image.path));
        request.fields[DbFields.jsonDataKey] = jsonEncode(jsonData);
        request.headers[DbFields.authKey] = '${DbFields.secretStart} $token';
        request.headers[DbFields.userID] = userId!;
        request.headers[DbFields.contentTypeKey] = DbFields.multipartFormData;
        final response = await request.send();
        if (response.statusCode == 200) {
        } else {
          ref.read(errorDialogMessageProvider.notifier).state =
              'Что-то пошло не так!';
          ref.read(errorDialogProvider.notifier).state = true;
          ref.read(loadingProvider.notifier).state = false;

          return;
        }
      } else {
        jsonData[DbFields.productPHOTO] = 'null';
        final response = await http.post(
            Uri.parse(Network.getUrl(path: DbFields.addAd)),
            body: jsonEncode(jsonData),
            headers: {
              DbFields.contentTypeKey: DbFields.applicationJson,
              DbFields.authKey: '${DbFields.secretStart} $token',
              DbFields.userID: userId!,
            });
        if (response.statusCode == 200) {
        } else {
          ref.read(errorDialogMessageProvider.notifier).state =
              'Что-то пошло не так!';
          ref.read(errorDialogProvider.notifier).state = true;
          ref.read(loadingProvider.notifier).state = false;
          return;
        }
      }
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
    } catch (e) {
      ref.read(errorDialogMessageProvider.notifier).state =
          'Что-то пошло не так!';
      ref.read(errorDialogProvider.notifier).state = true;
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
      logError(e);
    }
  }

  editAd({
    File? image,
    required int id,
    required String name,
    required int categoryId,
    required String description,
    required int price,
    required String priceType,
    required String location,
    required bool delivery,
  }) async {
    ref.read(loadingProvider.notifier).state = true;
    try {
      final token = ref.read(spServiceProvider).loadTokenSP();
      final userId = ref.read(authServiceProvider)?.id;
      final jsonData = {
        DbFields.productID: id,
        DbFields.productNAME: name,
        DbFields.productCATEGORYID: categoryId,
        DbFields.productDESCRIPTION: description,
        DbFields.productPRICE: price,
        DbFields.productPRICETYPE: priceType,
        DbFields.productDELIVERY: delivery,
        DbFields.productLOCATION: location,
      };

      if (image != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse(
            Network.getUrl(
              path: DbFields.editAdWithFile,
            ),
          ),
        );
        request.files.add(
            await http.MultipartFile.fromPath(DbFields.imageKey, image.path));
        request.fields[DbFields.jsonDataKey] = jsonEncode(jsonData);
        request.headers[DbFields.authKey] = '${DbFields.secretStart} $token';
        request.headers[DbFields.userID] = userId!;
        request.headers[DbFields.productIDAUTH] = id.toString();
        request.headers[DbFields.contentTypeKey] = DbFields.multipartFormData;
        final response = await request.send();
        if (response.statusCode == 200) {
        } else {
          logError(response.stream.bytesToString());
        }
      } else {
        jsonData[DbFields.productPHOTO] = 'null';
        final response = await http.post(
          Uri.parse(
            Network.getUrl(
              path: DbFields.editAd,
            ),
          ),
          body: jsonEncode(jsonData),
          headers: {
            DbFields.contentTypeKey: DbFields.applicationJson,
            DbFields.authKey: '${DbFields.secretStart} $token',
            DbFields.userID: userId!,
            DbFields.productIDAUTH: id.toString(),
          },
        );
        if (response.statusCode == 200) {
        } else {
          ref.read(errorDialogMessageProvider.notifier).state =
              'Что-то пошло не так!';
          ref.read(errorDialogProvider.notifier).state = true;
        }
      }
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
    } catch (e) {
      ref.read(errorDialogMessageProvider.notifier).state =
          'Что-то пошло не так!';
      ref.read(errorDialogProvider.notifier).state = true;
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
    }
  }

  removeAd(
    int productId,
  ) async {
    ref.read(loadingProvider.notifier).state = true;
    try {
      final token = ref.read(spServiceProvider).loadTokenSP();
      final userId = ref.read(authServiceProvider)?.id;
      final response = await http.post(
          Uri.parse(
            Network.getUrl(
              path: DbFields.removeAd,
            ),
          ),
          headers: {
            DbFields.contentTypeKey: DbFields.applicationJson,
            DbFields.authKey: '${DbFields.secretStart} ${token!}',
            DbFields.productUSERID: userId!,
            DbFields.productID: productId.toString(),
          });
      if (response.statusCode == 200) {
        logInfo(response.body);
      } else {
        logError(response.body);
      }
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
    } catch (e) {
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
      logError(e);
    }
  }

  moderateAd(
    int productId,
  ) async {
    ref.read(loadingProvider.notifier).state = true;
    try {
      final token = ref.read(spServiceProvider).loadTokenSP();
      final userId = ref.read(authServiceProvider)?.id;
      final response = await http.post(
          Uri.parse(
            Network.getUrl(
              path: DbFields.moderateAd,
            ),
          ),
          headers: {
            DbFields.contentTypeKey: DbFields.applicationJson,
            DbFields.authKey: '${DbFields.secretStart} ${token!}',
            DbFields.productUSERID: userId!,
            DbFields.productID: productId.toString(),
          });
      if (response.statusCode == 200) {
        logInfo(response.body);
      } else {
        logError(response.body);
      }
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
    } catch (e) {
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });

      logError(e);
    }
  }

  archiveAd(
    int productId,
  ) async {
    ref.read(loadingProvider.notifier).state = true;
    try {
      final token = ref.read(spServiceProvider).loadTokenSP();
      final userId = ref.read(authServiceProvider)?.id;
      final response = await http.post(
          Uri.parse(
            Network.getUrl(
              path: DbFields.archivedAd,
            ),
          ),
          headers: {
            DbFields.contentTypeKey: DbFields.applicationJson,
            DbFields.authKey: '${DbFields.secretStart} ${token!}',
            DbFields.productUSERID: userId!,
            DbFields.productID: productId.toString(),
          });
      if (response.statusCode == 200) {
        logInfo(response.body);
      } else {
        logError(response.body);
      }
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
    } catch (e) {
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
      logError(e);
    }
  }

  Future<void> userdataUpdate({
    required File? image,
    required String name,
    required String number,
    required String whatsapp,
    required String location,
    required String id,
  }) async {
    ref.read(loadingProvider.notifier).state = true;
    try {
      final token = ref.read(spServiceProvider).loadTokenSP();
      final id = ref.read(authServiceProvider)?.id;
      final Map<String, dynamic> jsonData = {
        DbFields.userNAME: name,
        DbFields.userPHONE: number,
        DbFields.userWHATSAPP: whatsapp,
        DbFields.userLOCATION: location,
        DbFields.userID: id,
      };
      if (image != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse(
            Network.getUrl(
              path: DbFields.userProfileUpdateWithFile,
            ),
          ),
        );
        request.files.add(
            await http.MultipartFile.fromPath(DbFields.imageKey, image.path));
        request.fields[DbFields.jsonDataKey] = jsonEncode(jsonData);
        request.headers[DbFields.authKey] = '${DbFields.secretStart} $token';
        request.headers[DbFields.userID] = id!;
        request.headers[DbFields.contentTypeKey] = DbFields.multipartFormData;

        final response = await request.send();
        if (response.statusCode == 200) {
          logServer('Response: OK');
          ref.read(authServiceProvider.notifier).signOut();
          ref.read(authServiceProvider.notifier).signInWithGoogle();
        } else {
          logServer(
              '${response.statusCode}: ${response.stream.bytesToString()}');
          ref.read(errorDialogMessageProvider.notifier).state =
              'Что-то пошло не так!';
          ref.read(errorDialogProvider.notifier).state = true;
        }
      } else {
        jsonData[DbFields.userPROFILEPHOTO] = 'null';
        final response = await http.post(
            Uri.parse(Network.getUrl(path: DbFields.userProfileUpdate)),
            body: jsonEncode(jsonData),
            headers: {
              DbFields.contentTypeKey: DbFields.applicationJson,
              DbFields.authKey: '${DbFields.secretStart} $token',
              DbFields.userID: id!,
            });
        if (response.statusCode == 200) {
          ref.read(authServiceProvider.notifier).signOut();
          ref.read(authServiceProvider.notifier).signInWithGoogle();
        } else {
          ref.read(errorDialogMessageProvider.notifier).state =
              'Что-то пошло не так!';
          ref.read(errorDialogProvider.notifier).state = true;
        }
      }
    } catch (e) {
      logError('Image upload failed with: $e');
      ref.read(loadingProvider.notifier).state = false;
      ref.read(errorDialogMessageProvider.notifier).state =
          'Что-то пошло не так!';
      ref.read(errorDialogProvider.notifier).state = true;
    }
  }
}
