import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/router/route_account.dart';
import 'package:tez_bazar/views/auth/account_view.dart';
import 'package:tez_bazar/views/auth/profile.dart';
import 'package:tez_bazar/views/home/home_view.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/views/product_view.dart';
import 'package:tez_bazar/views/search_view.dart';
import 'package:tez_bazar/views/user_products/user_products_view.dart';

class CustomRouter extends ConsumerStatefulWidget {
  const CustomRouter({super.key});

  @override
  ConsumerState<CustomRouter> createState() => BodySwitcherState();
}

class BodySwitcherState extends ConsumerState<CustomRouter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routeProvider);
    final accountState = ref.watch(accountStateProvider);
    final homeState = ref.watch(homeStateProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: switch (router) {
        BottomSelectedMenu.home => switch (homeState) {
            HomeState.home => HomeView(),
            HomeState.category => ProductsView(),
            HomeState.search => SearchView(),
          },
        BottomSelectedMenu.userProducts => AdsView(),
        BottomSelectedMenu.account => switch (accountState) {
            AccountState.account => AccountView(),
            AccountState.profile => UserProfile(),
          }
      },
    );
  }

//   homeStates(GridPage gridPage) {
//     return switch (gridPage) {
//       GridPage.category => CategoryView(
//           key: PageStorageKey<String>('category_grid'),
//         ),
//       GridPage.product => ProductsView(
//           key: PageStorageKey<String>('product_grid'),
//         ),
//       GridPage.search => SearchView(
//           key: PageStorageKey<String>('search_grid'),
//         ),
//     };
//   }
}
