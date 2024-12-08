import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/views/home/app_bar.dart';
import 'package:tez_bazar/views/home/bottom_bar.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/providers/auth_provider.dart';
import 'package:tez_bazar/views/auth/auth_view.dart';
import 'package:tez_bazar/views/home/body_switcher.dart';
import 'package:tez_bazar/providers/providers.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  @override
  ConsumerState<HomeView> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeView>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  late AnimationController _animationController;
  bool isSnackBarVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(authProviderState);
    final currentIndex = ref.watch(currentIndexProvider);
    final gridViewState = ref.watch(gridViewStateProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        print(
            'Popped: $didPop, Result: $result Grid View State: $gridViewState, Current Index: $currentIndex');
        if (gridViewState == GridPage.product &&
            currentIndex == SelectedMenu.home) {
          ref.read(gridViewStateProvider.notifier).state = GridPage.category;
        }
        if (currentIndex != SelectedMenu.home) {
          ref.read(currentIndexProvider.notifier).state = SelectedMenu.home;
        }
        if (gridViewState == GridPage.search &&
            currentIndex == SelectedMenu.home) {
          ref.read(gridViewStateProvider.notifier).state = GridPage.category;
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child:
                    _buildBody(currentIndex, isAuthenticated, scrollController),
              ),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: const CustomAppBar(),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: const CustomBottomBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SelectedMenu currentIndex, AuthViewContent isAuthenticated,
      ScrollController scrollController) {
    _animationController.reset();
    _animationController.forward();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: switch (currentIndex) {
        SelectedMenu.home => const BodySwitcher(),
        SelectedMenu.settings => const AuthPage(),
        SelectedMenu.products =>
          isAuthenticated == AuthViewContent.authenticated
              ? const Center(child: Text('Product Page'))
              : const BodySwitcher(),
      },
    );
  }
}
