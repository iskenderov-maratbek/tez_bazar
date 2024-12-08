import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/providers/auth_provider.dart';
import 'package:tez_bazar/providers/providers.dart';

class CustomBottomBar extends ConsumerStatefulWidget {
  const CustomBottomBar({super.key});

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends ConsumerState<CustomBottomBar> {
  final iconColor = Colors.grey;
  final activeIconColor = AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);
    final isAuthenticated = ref.watch(authProviderState);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.bottomNavigationBarColor.withOpacity(0.8),
            blurRadius: 15,
            spreadRadius: 10,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.bottomNavigationBarColor.withOpacity(.6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildBottomIcon(
                    selectedMenu: SelectedMenu.home,
                    currentIndex: currentIndex,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    color: iconColor,
                    activeColor: activeIconColor,
                    onPressed: () {
                      ref.read(currentIndexProvider.notifier).state =
                          SelectedMenu.home;
                    },
                  ),
                ),
                Visibility(
                  visible: isAuthenticated == AuthViewContent.authenticated,
                  child: Expanded(
                    child: _buildBottomIcon(
                      selectedMenu: SelectedMenu.products,
                      currentIndex: currentIndex,
                      icon: Icons.add_business_sharp,
                      activeIcon: Icons.add_business,
                      color: iconColor,
                      activeColor: activeIconColor,
                      onPressed: () {
                        ref.read(currentIndexProvider.notifier).state =
                            SelectedMenu.products;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: _buildBottomIcon(
                    selectedMenu: SelectedMenu.settings,
                    currentIndex: currentIndex,
                    icon: Icons.account_circle_rounded,
                    activeIcon: Icons.account_circle,
                    color: iconColor,
                    activeColor: activeIconColor,
                    onPressed: () {
                      ref.read(currentIndexProvider.notifier).state =
                          SelectedMenu.settings;
                    },
                  ),
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
      padding: EdgeInsets.all(0),
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
