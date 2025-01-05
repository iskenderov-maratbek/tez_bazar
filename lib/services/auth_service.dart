import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/constants/db_fields.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/user.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/shared_prefs_service.dart';
import 'package:tez_bazar/constants/text_constants.dart';

final authServiceProvider = StateNotifierProvider<AuthService, User?>((ref) {
  return AuthService(ref);
});

class AuthService extends StateNotifier<User?> {
  final Ref ref;

  AuthService(this.ref) : super(null);

  Future<void> signInWithGoogle() async {
    ref.read(loadingProvider.notifier).state = true;
    logInfo('Signing in with Google...');
    final googleSignIn = ref.read(googleSignInProvider);
    final accountState = ref.read(accountStateProvider.notifier);
    final spProvider = ref.read(spServiceProvider);

    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {

        Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
          ref.read(loadingProvider.notifier).state = false;
        });
        return;
      }
      final googleAuth = await googleUser.authentication;
      logServer('Send Post Requests: /${DbFields.authWithGoogle}');
      final response = await http.post(
        Uri.parse(
          Network.getUrl(
            path: DbFields.authWithGoogle,
          ),
        ),
        body: jsonEncode({
          DbFields.userNAME: googleUser.displayName,
          DbFields.userEMAIL: googleUser.email,
          DbFields.userID: googleUser.id,
          DbFields.userTOKEN: googleAuth.accessToken!
        }),
      );
      if (response.statusCode == 200) {
        logServer('Response: OK');
        await _getListOfCategories();
        ref.read(isAuthenticatedProvider.notifier).state = true;
        ref.read(appBarTitleProvider.notifier).state =
            TextConstants.accountPageTitle;
        final result = jsonDecode(response.body);
        User user = User.fromJson(result);

        state = user;
        await spProvider.clearSP();
        final String getToken = jsonDecode(response.body)['access_token'];
        await spProvider.saveTokenSP(getToken);
        accountState.state = AccountState.account;
      } else {}
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
    } catch (e) {
      logError('Error signing in with Google: $e');
      Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
        ref.read(loadingProvider.notifier).state = false;
      });
    }
  }

  Future<void> signOut() async {
    ref.read(loadingProvider.notifier).state = true;
    await ref.read(spServiceProvider).clearSP();
    ref.read(isAuthenticatedProvider.notifier).state = false;
    Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
      ref.read(loadingProvider.notifier).state = false;
    });
  }

  _getListOfCategories() async {
    try {
      logServer('Send Post Requests: /${DbFields.allcategories}');
      final response = await http.get(
        Uri.parse(
          Network.getUrl(
            path: DbFields.allcategories,
          ),
        ),
      );

      if (response.statusCode == 200) {
        logServer('Response category: OK');
        final result = jsonDecode(response.body);
        ref.read(listOfCategoriesProvider.notifier).state = result;
      }
    } catch (e) {
      logError('Error: $e');
    }
  }
}
