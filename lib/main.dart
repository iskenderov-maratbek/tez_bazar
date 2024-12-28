import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_theme.dart';
import 'package:tez_bazar/common/custom_transition.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/views/auth/account_view.dart';
import 'package:tez_bazar/views/home/home_view.dart';
import 'package:tez_bazar/views/main_view.dart';
import 'package:tez_bazar/views/user_ads/ads_view.dart';

Future<void> main() async {
  ansiColorDisabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  logSys('Running the app');
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
    Map<String, Widget> onGenerateRoute = {
      '/': const MainView(),
      '/account': const AccountView(),
      '/ads': const AdsView(),
    };
    return MaterialApp(
      onGenerateRoute: (settings) {
        return CustomRoute(
          builder: (context) => onGenerateRoute[settings.name]!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'TezBazar',
      theme: themeData(context),
      initialRoute: '/',
    );
  }
}
