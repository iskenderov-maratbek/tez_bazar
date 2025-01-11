import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/providers/providers.dart';

class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({super.key});

  final iconColor = Colors.grey;
  final activeIconColor = AppColors.primaryColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(routeProvider);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0, 0),
            spreadRadius: 3,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: AppColors.bottomNavigationBarColor.withOpacity(.6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildBottomIcon(
                      selectedMenu: BottomSelectedMenu.home,
                      currentIndex: currentIndex,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      color: iconColor,
                      activeColor: activeIconColor,
                      onPressed: () {
                        ref.read(accountStateProvider.notifier).state =
                            AccountState.account;
                        ref.read(routeProvider.notifier).state =
                            BottomSelectedMenu.home;
                      }),
                ),
                Visibility(
                  visible: ref.watch(isAuthenticatedProvider),
                  child: Expanded(
                    child: _buildBottomIcon(
                      selectedMenu: BottomSelectedMenu.userProducts,
                      currentIndex: currentIndex,
                      icon: Icons.add_business_rounded,
                      activeIcon: Icons.add_business,
                      color: iconColor,
                      activeColor: activeIconColor,
                      onPressed: () {
                        ref.read(routeProvider.notifier).state =
                            BottomSelectedMenu.userProducts;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: _buildBottomIcon(
                      selectedMenu: BottomSelectedMenu.account,
                      currentIndex: currentIndex,
                      icon: Icons.account_circle_rounded,
                      activeIcon: Icons.account_circle,
                      color: iconColor,
                      activeColor: activeIconColor,
                      onPressed: () {
                        ref.read(routeProvider.notifier).state =
                            BottomSelectedMenu.account;
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomIcon(
      {required currentIndex,
      required icon,
      required activeIcon,
      required selectedMenu,
      required Color color,
      required Color activeColor,
      required onPressed}) {
    return IconButton(
      padding: EdgeInsets.symmetric(vertical: 20),
      style: IconButton.styleFrom(backgroundColor: Colors.transparent),
      iconSize: 30,
      color: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(
        currentIndex == selectedMenu ? activeIcon : icon,
        color: currentIndex == selectedMenu ? activeColor : color,
      ),
      onPressed: onPressed,
    );
  }
}
