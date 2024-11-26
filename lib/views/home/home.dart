import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/app_bar.dart';
import 'package:tez_bazar/views/settings/auth_page.dart';
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
  double bottomBarIconSize = 40;

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(authProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    final showFirstGrid = ref.watch(gridViewStateProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        print('Popped: $didPop, Result: $result');
        if (didPop == showFirstGrid && currentIndex == SelectedMenu.home) {
          ref.read(gridViewStateProvider.notifier).state = true;
        }
        if (!didPop && currentIndex != SelectedMenu.home) {
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
                _buildBottomIcon(
                  icon: currentIndex == SelectedMenu.home
                      ? Icons.home
                      : Icons.home_outlined,
                  color: currentIndex == SelectedMenu.home
                      ? Colors.blue
                      : Colors.grey,
                  onPressed: () {
                    ref.read(currentIndexProvider.notifier).state =
                        SelectedMenu.home;
                  },
                ),
                Visibility(
                  visible: isAuthenticated,
                  child: Expanded(
                    child: IconButton(
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      iconSize: bottomBarIconSize,
                      icon: Icon(
                        currentIndex == SelectedMenu.products
                            ? Icons.add_business
                            : Icons.add_business_outlined,
                        color: currentIndex == SelectedMenu.products
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: () {
                        ref.read(currentIndexProvider.notifier).state =
                            SelectedMenu.products;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    iconSize: bottomBarIconSize,
                    icon: Icon(
                      currentIndex == SelectedMenu.settings
                          ? Icons.account_circle_sharp
                          : Icons.account_circle_outlined,
                      color: currentIndex == SelectedMenu.settings
                          ? Colors.blue
                          : Colors.grey,
                    ),
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

  _buildBottomIcon({required icon, required color, required onPressed}) {
    return IconButton(
        style: IconButton.styleFrom(backgroundColor: Colors.transparent),
        iconSize: bottomBarIconSize,
        icon: Icon(icon),
        color: color,
        onPressed: onPressed);
  }

  Widget _buildBody(SelectedMenu currentIndex, bool isAuthenticated,
      ScrollController scrollController) {
    switch (currentIndex) {
      case SelectedMenu.home:
        return const BodySwitcher();
      case SelectedMenu.settings:
        return const AuthPage();
      case SelectedMenu.products:
        return isAuthenticated
            ? const Center(child: Text('Product Page'))
            : const BodySwitcher();
    }
  }
}
