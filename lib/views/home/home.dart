import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/app_bar.dart';
import 'package:tez_bazar/providers/auth_provider.dart';
import 'package:tez_bazar/views/profile/auth_page.dart';
import 'package:tez_bazar/views/body_switcher.dart';
import 'package:tez_bazar/providers/providers.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isSnackBarVisible = false;

  void _showFullScreenSnackBar() {
    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue.withOpacity(0.9),
        child: const Center(
          child: Text(
            'This is a full screen SnackBar',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
      duration: const Duration(minutes: 5),
      behavior: SnackBarBehavior.floating,
    );

    setState(() {
      isSnackBarVisible = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((reason) {
      setState(() {
        isSnackBarVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(authProviderState);
    final currentIndex = ref.watch(currentIndexProvider);
    final showFirstGrid = ref.watch(gridViewStateProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        print('Popped: $didPop, Result: $result');
        if (didPop == showFirstGrid && currentIndex == SelectedMenu.home) {
          ref.read(appBarTitleProvider.notifier).state = 'TEZ Bazar';
          ref.read(gridViewStateProvider.notifier).state = true;
        }
        if (!didPop && currentIndex != SelectedMenu.home) {
          ref.read(appBarTitleProvider.notifier).state = 'TEZ Bazar';
          ref.read(currentIndexProvider.notifier).state = SelectedMenu.home;
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: const CustomAppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildBody(currentIndex, isAuthenticated, scrollController),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildBottomIcon(
                    selectedMenu: SelectedMenu.home,
                    currentIndex: currentIndex,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    color: Colors.grey,
                    activeColor: Colors.blue,
                    onPressed: () {
                      ref.read(currentIndexProvider.notifier).state =
                          SelectedMenu.home;
                    },
                  ),
                ),
                Visibility(
                  visible: isAuthenticated == AuthStatus.authenticated,
                  child: Expanded(
                    child: _buildBottomIcon(
                      selectedMenu: SelectedMenu.products,
                      currentIndex: currentIndex,
                      icon: Icons.add_business_sharp,
                      activeIcon: Icons.add_business,
                      color: Colors.grey,
                      activeColor: Colors.green,
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
                    color: Colors.grey,
                    activeColor: Colors.blue,
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
      style: IconButton.styleFrom(backgroundColor: Colors.transparent),
      iconSize: 40,
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

  Widget _buildBody(SelectedMenu currentIndex, AuthStatus isAuthenticated,
      ScrollController scrollController) {
    switch (currentIndex) {
      case SelectedMenu.home:
        return const BodySwitcher();
      case SelectedMenu.settings:
        return const AuthPage();
      case SelectedMenu.products:
        return isAuthenticated == AuthStatus.authenticated
            ? const Center(child: Text('Product Page'))
            : const BodySwitcher();
    }
  }
}
