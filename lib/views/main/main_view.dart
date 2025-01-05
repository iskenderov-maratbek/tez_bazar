import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/forms/loading.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/router/custom_router.dart';
import 'package:tez_bazar/services/refresh_service.dart';
import 'package:tez_bazar/views/home/bottom_bar.dart';
import 'package:tez_bazar/views/main/app_bar.dart';
import 'package:tez_bazar/common/app_colors.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});
  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  void initState() {
    ref.read(mainServiceProvider).getMainData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final route = ref.watch(routeProvider);
    logView(runtimeType);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        logInfo('Popped: $didPop, Result: $result');
        _popSystem(route);
      },
      child: Stack(
        children: [
          Scaffold(
            appBar:
                route == BottomSelectedMenu.home ? const CustomAppBar() : null,
            backgroundColor: AppColors.black,
            body: CustomRouter(),
            bottomNavigationBar: const CustomBottomBar(),
          ),
          loadingIndicator(),
        ],
      ),
    );
  }

  Consumer loadingIndicator() {
    return Consumer(
      builder: (context, ref, child) {
        final isRefreshing = ref.watch(refreshServiceProvider);
        return isRefreshing
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: AlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  insetPadding: const EdgeInsets.all(0),
                  backgroundColor: AppColors.transparent,
                  shadowColor: AppColors.transparent,
                  surfaceTintColor: AppColors.transparent,
                  content: Container(
                    width: double.maxFinite,
                    color: AppColors.black.withOpacity(.3),
                    child: LoadingAnimation(
                      size: 100,
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }

  void _popSystem(BottomSelectedMenu router) {
    final accountState = ref.watch(accountStateProvider);
    final homeState = ref.watch(homeStateProvider);
    switch (router) {
      case BottomSelectedMenu.home:
        switch (homeState) {
          case HomeState.home:
            break;
          case HomeState.category:
            ref.read(homeStateProvider.notifier).state = HomeState.home;
            break;
          case HomeState.search:
            ref.read(homeStateProvider.notifier).state = HomeState.home;
            break;
        }
        break;
      case BottomSelectedMenu.userProducts:
        ref.read(routeProvider.notifier).state = BottomSelectedMenu.home;
        break;
      case BottomSelectedMenu.account:
        switch (accountState) {
          case AccountState.account:
            ref.read(routeProvider.notifier).state = BottomSelectedMenu.home;
            break;
          case AccountState.profile:
            ref.read(accountStateProvider.notifier).state =
                AccountState.account;
            break;
        }
        break;
    }
  }
}
