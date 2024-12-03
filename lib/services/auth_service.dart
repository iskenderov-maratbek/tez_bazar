import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/models/user.dart';
import 'package:tez_bazar/providers/auth_provider.dart';

final authServiceProvider = StateNotifierProvider<AuthService, User?>((ref) {
  return AuthService(ref);
});

class AuthService extends StateNotifier<User?> {
  final Ref ref;

  AuthService(this.ref) : super(null);

  Future<void> signInWithGoogle() async {
    final googleSignIn = ref.read(googleSignInProvider);
    final authProvider = ref.read(authProviderState.notifier);

    try {
      authProvider.state = AuthStatus.authenticating;
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        authProvider.state = AuthStatus.unauthenticated;
        return;
      }
      final googleAuth = await googleUser.authentication;
      // Проверка токена на сервере (пример HTTP-запроса)
      final response = await http.post(
        Uri.parse('http://192.168.1.103:3000/authWithGoogle'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': googleUser.id,
          'name': googleUser.displayName,
          'email': googleUser.email,
          'photo': googleUser.photoUrl,
          'idToken': googleAuth.idToken,
          'accessToken': googleAuth.accessToken,
        }),
      );
      if (response.statusCode == 200) {
        User user = User.fromJson(jsonDecode(response.body));
        state = user;
        authProvider.state = AuthStatus.authenticated;
      } else {
        authProvider.state = AuthStatus.error;
      }
    } catch (e) {
      authProvider.state = AuthStatus.error;
    }
  }

  Future<void> signOut() async {
    final authProvider = ref.read(authProviderState.notifier);
    authProvider.state = AuthStatus.defaultState;
  }
}
