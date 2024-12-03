import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_theme.dart';
import 'package:tez_bazar/views/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: TezBazar(),
    ),
  );
}

class TezBazar extends StatelessWidget {
  const TezBazar({super.key});

  @override
  Widget build(BuildContext context) {
    // Map<String, Widget> onGenerateRoute = {
    //   '/home': const Home(),
    //   '/auth': const Auth(),
    //   '/register': const Register(),
    // };
    return MaterialApp(
      // onGenerateRoute: (settings) {
      //   return CustomRoute(
      //     builder: (context) => onGenerateRoute[settings.name]!,
      //   );
      // },
      debugShowCheckedModeBanner: false,
      title: 'TezBazar',
      theme: themeData(context),
      home:
          // context.read<AuthService>().checkAuth() ? const Home() : const Auth(),
          const Home(),
    );
  }
}
// Пример кода на клиентской стороне для получения данных

