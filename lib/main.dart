import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_theme.dart';
import 'package:tez_bazar/home/home.dart';
import 'package:tez_bazar/services/category_service.dart';
import 'package:tez_bazar/services/product_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [
        StateNotifierProvider((_) => ProductService()),
        StateNotifierProvider((_) => CategoryService()),
      ],
      child: const TezBazar(),
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
