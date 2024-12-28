import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_theme.dart';
import 'package:tez_bazar/common/custom_transition.dart';
import 'package:tez_bazar/common/forms/loading.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/texts/text_constants.dart';
import 'package:tez_bazar/views/auth/account_view.dart';
import 'package:tez_bazar/views/home/app_bar.dart';
import 'package:tez_bazar/views/home/bottom_bar.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/views/body_switcher.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/views/home/home_view.dart';
import 'package:tez_bazar/views/user_ads/ads_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});
  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  late AnimationController _animationController;
  bool isSnackBarVisible = false;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  void showOverlay(BuildContext context, String dialogText) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.black.withOpacity(0.9),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_rounded,
                  color: AppColors.primaryColor,
                  size: 50,
                ),
                Expanded(
                  child: textForm(dialogText, 22, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(overlayEntry);
    });
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
      ref.read(errorDialogProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logView(runtimeType);
    logInfo(ModalRoute.of(context)?.settings.name);

    final authView = ref.watch(authViewProvider);
    final bottomMenu = ref.watch(bottomSelectedProvider);
    final gridViewState = ref.watch(gridViewStateProvider);
    final loadingVisible = ref.watch(loadingProvider);
    final errorDialog = ref.watch(errorDialogProvider);
    final dialogText = ref.watch(errorDialogMessageProvider);
    errorDialog ? showOverlay(context, dialogText ?? '') : null;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        logInfo(
            'Popped: $didPop, Result: $result Grid View State: $gridViewState, Current Index: $bottomMenu');
        // _popSystem(bottomMenu, gridViewState, authView);
      },
      child: SafeArea(
        // backgroundColor: AppColors.backgroundColor,
        // resizeToAvoidBottomInset: bottomMenu == BottomSelectedMenu.home,
        child: Scaffold(
          appBar: const CustomAppBar(),
          body: Column(
            children: [
              
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: const CustomBottomBar(),
              ),
              Visibility(
                visible: loadingVisible,
                child: Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  top: 0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(.4),
                      ),
                      child: loadingCircle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BottomSelectedMenu currentIndex,
      AuthViewContent isAuthenticated, ScrollController scrollController) {
    _animationController.reset();
    _animationController.forward();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: switch (currentIndex) {
        BottomSelectedMenu.home => BodySwitcher(selectedState: currentIndex),
        BottomSelectedMenu.account => BodySwitcher(selectedState: currentIndex),
        BottomSelectedMenu.ads => const AdsView(),
      },
    );
  }

  void _popSystem(bottomMenu, gridViewState, authView) {
    switch (bottomMenu) {
      case BottomSelectedMenu.home:
        if (gridViewState == GridPage.product) {
          ref.read(appBarTitleProvider.notifier).state =
              TextConstants.homeTitle;
          ref.read(gridViewStateProvider.notifier).state = GridPage.category;
          break;
        } else if (gridViewState == GridPage.search) {
          ref.read(appBarTitleProvider.notifier).state =
              TextConstants.homeTitle;
          ref.read(gridViewStateProvider.notifier).state = GridPage.category;
          break;
        }
      case BottomSelectedMenu.ads:
        switch (gridViewState) {
          case GridPage.product:
            ref.read(appBarTitleProvider.notifier).state =
                ref.read(productProvider.notifier).getSelectedCategory();
            ref.read(bottomSelectedProvider.notifier).state =
                BottomSelectedMenu.home;
            break;

          default:
            ref.read(appBarTitleProvider.notifier).state =
                TextConstants.homeTitle;
            ref.read(bottomSelectedProvider.notifier).state =
                BottomSelectedMenu.home;
        }
        break;
      case BottomSelectedMenu.account:
        switch (authView) {
          case AuthViewContent.profile:
            ref.read(appBarTitleProvider.notifier).state =
                TextConstants.accountPageTitle;
            ref.read(authViewProvider.notifier).state =
                AuthViewContent.accountPage;
            break;
          default:
            switch (gridViewState) {
              case GridPage.product:
                ref.read(appBarTitleProvider.notifier).state =
                    ref.read(productProvider.notifier).getSelectedCategory();
                ref.read(bottomSelectedProvider.notifier).state =
                    BottomSelectedMenu.home;
              case GridPage.search:
                ref.read(appBarTitleProvider.notifier).state =
                    ref.read(searchProvider.notifier).getSearchValue();
                ref.read(bottomSelectedProvider.notifier).state =
                    BottomSelectedMenu.home;
                break;

              default:
                ref.read(appBarTitleProvider.notifier).state =
                    TextConstants.homeTitle;
                ref.read(bottomSelectedProvider.notifier).state =
                    BottomSelectedMenu.home;
            }
        }
    }
  }
}
