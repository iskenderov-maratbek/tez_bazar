import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/search_form.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/texts/text_constants.dart';

class CustomBottomBar extends ConsumerStatefulWidget {
  const CustomBottomBar({super.key});

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends ConsumerState<CustomBottomBar> {
  final iconColor = Colors.grey;
  final activeIconColor = AppColors.primaryColor;
  final TextEditingController controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _focusStatus = false;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        _focusNode.unfocus();
        _focusStatus = false;
      }
    });
  }

  void _onFocusChange() {
    setState(() {
      _focusStatus = _focusNode.hasFocus ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomSelectedProvider);
    final selectedMenu = ref.watch(bottomSelectedProvider);

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
            child: Column(
              children: [
                Visibility(
                  visible: selectedMenu == BottomSelectedMenu.home,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: SearchForm(
                      focusNode: _focusNode,
                      controller: controller,
                    ),
                  ),
                ),
                Visibility(
                  visible: !_focusStatus,
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
                            ref.read(bottomSelectedProvider.notifier).state =
                                BottomSelectedMenu.home;
                            ref.read(gridViewStateProvider) == GridPage.product
                                ? ref.read(appBarTitleProvider.notifier).state =
                                    ref
                                        .read(productProvider.notifier)
                                        .getSelectedCategory()
                                : ref.read(appBarTitleProvider.notifier).state =
                                    TextConstants.homeTitle;
                          },
                        ),
                      ),
                      Visibility(
                        visible: ref.watch(isAuthenticatedProvider),
                        child: Expanded(
                          child: _buildBottomIcon(
                            selectedMenu: BottomSelectedMenu.ads,
                            currentIndex: currentIndex,
                            icon: Icons.add_business_rounded,
                            activeIcon: Icons.add_business,
                            color: iconColor,
                            activeColor: activeIconColor,
                            onPressed: () {
                              ref.read(appBarTitleProvider.notifier).state =
                                  TextConstants.myOrdersTitle;
                              ref.read(bottomSelectedProvider.notifier).state =
                                  BottomSelectedMenu.ads;
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
                            ref.read(appBarTitleProvider.notifier).state =
                                TextConstants.accountPageTitle;
                            if (ref.read(isAuthenticatedProvider)) {
                              ref.read(authViewProvider.notifier).state =
                                  AuthViewContent.accountPage;
                            } else {
                              ref.read(appBarTitleProvider.notifier).state =
                                  TextConstants.singInTitle;
                              ref.read(authViewProvider.notifier).state =
                                  AuthViewContent.signInPage;
                            }
                            ref.read(bottomSelectedProvider.notifier).state =
                                BottomSelectedMenu.account;
                          },
                        ),
                      ),
                    ],
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
