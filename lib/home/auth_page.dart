import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/services/providers.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Example'),
      ),
      body: Center(
        child: isAuthenticated
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('User is authenticated'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                    },
                    child: const Text('Logout'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('User is not authenticated'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).login();
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
      ),
    );
  }
}
