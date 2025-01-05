import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_theme.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/views/main/main_view.dart';

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

class TezBazar extends ConsumerWidget {
  const TezBazar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TezBazar',
      theme: themeData(context),
      home: const MainView(),
    );
  }
}
