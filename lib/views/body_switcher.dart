import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/views/auth/account_view.dart';
import 'package:tez_bazar/views/auth/profile.dart';
import 'package:tez_bazar/views/auth/sign_in_view.dart';
import 'package:tez_bazar/views/category_view.dart';
import 'package:tez_bazar/views/search_view.dart';
import 'package:tez_bazar/views/product_view.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/views/user_ads/ads_view.dart';

class BodySwitcher extends ConsumerStatefulWidget {
  final BottomSelectedMenu selectedState;
  const BodySwitcher({super.key, required this.selectedState});

  @override
  ConsumerState<BodySwitcher> createState() => BodySwitcherState();
}

class BodySwitcherState extends ConsumerState<BodySwitcher> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gridPage = ref.watch(gridViewStateProvider);
    final authViewContent = ref.watch(authViewProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: switch (widget.selectedState) {
        BottomSelectedMenu.home => homeStates(gridPage),
        BottomSelectedMenu.ads => AdsView(),
        BottomSelectedMenu.account => accountStates(authViewContent),
      },
    );
  }

  homeStates(GridPage gridPage) {
    return switch (gridPage) {
      GridPage.category => CategoryView(
          key: PageStorageKey<String>('category_grid'),
        ),
      GridPage.product => ProductsView(
          key: PageStorageKey<String>('product_grid'),
        ),
      GridPage.search => SearchView(
          key: PageStorageKey<String>('search_grid'),
        ),
    };
  }

  accountStates(AuthViewContent authViewContent) {
    return switch (authViewContent) {
      AuthViewContent.accountPage => AccountView(),
      AuthViewContent.signInPage => SignInView(),
      AuthViewContent.error => SignInView(),
      AuthViewContent.profile => UserProfile(),
    };
  }
}
