import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/models/user.dart';
import 'package:tez_bazar/providers/auth_provider.dart';
import 'package:tez_bazar/services/auth_service.dart';
import 'package:tez_bazar/texts/text_constants.dart';
import 'package:tez_bazar/views/auth/profile.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(authProviderState);
    final authService = ref.read(authServiceProvider.notifier);
    final user = ref.watch(authServiceProvider);

    return Center(
      child: switch (isAuthenticated) {
        AuthViewContent.authenticated =>
          _authenticatedContent(authService, user),
        AuthViewContent.unauthenticated => _unauthenticatedContent(authService),
        AuthViewContent.authenticating => _authenticatingContent(),
        AuthViewContent.profile => UserProfile(),
        AuthViewContent.error => _errorContent(authService),
        AuthViewContent.defaultState => _defaultStateContent(authService),
      },
    );
  }

  _defaultStateContent(authService) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Вы не авторизованы'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            authService.signInWithGoogle();
          },
          child: const Text(' ВОЙТИ С ПОМОЩЬЮ GOOGLE'),
        ),
      ],
    );
  }

  _errorContent(AuthService authService) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Ошибка авторизации. Что-то пошло не так'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            authService.signInWithGoogle();
          },
          child: const Text('ВОЙТИ С ПОМОЩЬЮ GOOGLE'),
        ),
      ],
    );
  }

  _unauthenticatedContent(AuthService authService) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Разрешение не было получено('),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            authService.signInWithGoogle();
          },
          child: const Text('ПОПРОБОВАТЬ ЕЩЁ РАЗ ВОЙТИ С ПОМОЩЬЮ GOOGLE'),
        ),
      ],
    );
  }

  _authenticatedContent(AuthService authService, User? user) {
    return ListView(
      padding: const EdgeInsets.only(top: 180, bottom: 100),
      children: [
        ElevatedButton(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white.withOpacity(.1),
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          onPressed: () {
            ref.read(authProviderState.notifier).state =
                AuthViewContent.profile;
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: user!.photo != null
                    ? Image.network(
                        user.photo as String,
                        fit: BoxFit.contain,
                        height: 80,
                      )
                    : Image.asset(
                        'lib/assets/images/200.png',
                        fit: BoxFit.contain,
                        height: 80,
                      ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textForm(TextConstants.profileTitle, 24,
                        weight: FontWeight.bold),
                    textForm('${user.name}', 16),
                    textForm(user.phone ?? 'Номер не указан', 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white.withOpacity(.1),
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          onPressed: () {
            authService.signOut();
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Icon(
                    Icons.logout,
                    size: 70,
                  ),
                ),
              ),
              textForm('Выйти из аккаунта', 24, weight: FontWeight.bold),
            ],
          ),
        ),
      ],
    );
  }

  _authenticatingContent() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
