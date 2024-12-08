import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthViewContent {
  defaultState,
  authenticated,
  unauthenticated,
  authenticating,
  error, profile,
}

final authProviderState =
    StateProvider<AuthViewContent>((ref) => AuthViewContent.defaultState);

final googleSignInProvider = Provider<GoogleSignIn>(
  (ref) {
    return GoogleSignIn(
      scopes: ['email', 'profile'],
    );
  },
);
