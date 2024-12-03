import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  defaultState,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

final authProviderState =
    StateProvider<AuthStatus>((ref) => AuthStatus.defaultState);

final googleSignInProvider = Provider<GoogleSignIn>(
  (ref) {
    return GoogleSignIn(
      scopes: ['email', 'profile'],
    );
  },
);
