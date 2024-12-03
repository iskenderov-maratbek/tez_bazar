import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/models/user.dart';
import 'package:tez_bazar/providers/auth_provider.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:http/http.dart' as http;
import 'package:tez_bazar/services/auth_service.dart';

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
        AuthStatus.authenticated => _authenticatedContent(authService, user),
        AuthStatus.unauthenticated => _unauthenticatedContent(authService),
        AuthStatus.authenticating => _authenticatingContent(),
        AuthStatus.error => _errorContent(authService),
        AuthStatus.defaultState => _defaultStateContent(authService),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        ElevatedButton(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(10, 150),
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    user?.photo ?? '',
                    height: 100,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text24bold('Профиль'),
                  const SizedBox(height: 6),
                  text18Bold(user?.name ?? ''),
                  text16normal(user?.email ?? ''),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          onPressed: () {},
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    'https://avatars.dzeninfra.ru/get-zen_doc/9884063/pub_64c9db08c931b62fe5531568_64c9db4494089c490de32909/scale_1200',
                    height: 80,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text24bold('История транзакций'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          onPressed: () {},
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Icon(
                    Icons.settings,
                    size: 70,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text24bold('Настройки'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text24bold('Выйти из аккаунта'),
                ],
              ),
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
