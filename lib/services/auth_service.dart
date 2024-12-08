import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/network_data.dart';
import 'package:tez_bazar/models/user.dart';
import 'package:tez_bazar/providers/auth_provider.dart';

final authServiceProvider = StateNotifierProvider<AuthService, User?>((ref) {
  return AuthService(ref);
});

class AuthService extends StateNotifier<User?> {
  final Ref ref;

  AuthService(this.ref) : super(null);

  Future<void> signInWithGoogle() async {
    print('Signing in with Google...');
    final googleSignIn = ref.read(googleSignInProvider);
    final authProvider = ref.read(authProviderState.notifier);

    try {
      print('Starting Google Sign In');
      authProvider.state = AuthViewContent.authenticating;
      print('authProvider: $authProvider');
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        authProvider.state = AuthViewContent.unauthenticated;
        return;
      }
      final googleAuth = await googleUser.authentication;
      // Проверка токена на сервере (пример HTTP-запроса)
      print('googleUser  : $googleUser');
      final response = await http.post(
        Uri.parse(
          Network.getUrl(
            path: 'authWithGoogle',
          ),
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': googleUser.id,
          'name': googleUser.displayName,
          'email': googleUser.email,
          'photo': googleUser.photoUrl,
          'accessToken': googleAuth.accessToken,
        }),
      );
      if (response.statusCode == 200) {
        User user = User.fromJson(jsonDecode(response.body));
        state = user;
        authProvider.state = AuthViewContent.authenticated;
      } else {
        authProvider.state = AuthViewContent.error;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      authProvider.state = AuthViewContent.error;
    }
  }

  Future<void> signOut() async {
    final authProvider = ref.read(authProviderState.notifier);
    authProvider.state = AuthViewContent.defaultState;
  }
}
