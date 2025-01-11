import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/router/custom_router.dart';
import 'package:tez_bazar/services/refresh_service.dart';
import 'package:tez_bazar/views/main/widgets/bottom_bar.dart';
import 'package:tez_bazar/views/main/widgets/app_bar.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/views/main/utils/error_overlay.dart';
import 'package:tez_bazar/views/main/utils/pop_system.dart';
import 'package:tez_bazar/views/main/widgets/loading_full_screen.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});
  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  void initState() {
    ref.read(versionProvider.notifier).checkHomeVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logView(runtimeType);

    final route = ref.watch(routeProvider);
    final appBar =
        route == BottomSelectedMenu.home ? const CustomAppBar() : null;
    final errorDialog = ref.watch(errorDialogProvider);
    final dialogText = ref.watch(errorDialogMessageProvider);

    errorDialog
        ? showOverlay(context: context, ref: ref, dialogText: dialogText ?? '')
        : null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async => popSystem(ref, route),
      child: Stack(
        children: [
          Scaffold(
            appBar: appBar,
            backgroundColor: AppColors.black,
            body: CustomRouter(),
            bottomNavigationBar: const CustomBottomBar(),
          ),
          Consumer(builder: (context, ref, child) {
            final isRefreshing = ref.watch(refreshServiceProvider);
            return isRefreshing ? LoadingFullScreen() : Container();
          })
        ],
      ),
    );
  }
}
