import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/app_bar.dart';
import 'package:tez_bazar/home/auth_page.dart';
import 'package:tez_bazar/home/category_page.dart';
import 'package:tez_bazar/services/providers.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(authProvider);
    final currentIndex = ref.watch(currentIndexProvider);
    print('currentIndex: $currentIndex');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: customAppBar(controller, context, currentIndex),
        body: _buildBody(currentIndex, isAuthenticated),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                style:
                    IconButton.styleFrom(backgroundColor: Colors.transparent),
                icon: Icon(
                  currentIndex == SelectedMenu.home
                      ? Icons.home
                      : Icons.home_outlined,
                  color: currentIndex == SelectedMenu.home
                      ? Colors.blue
                      : Colors.grey,
                ),
                onPressed: () {
                  ref.read(currentIndexProvider.notifier).state =
                      SelectedMenu.home;
                },
              ),
              Visibility(
                visible: isAuthenticated,
                child: IconButton(
                  style:
                      IconButton.styleFrom(backgroundColor: Colors.transparent),
                  icon: Icon(
                    currentIndex == SelectedMenu.products
                        ? Icons.search
                        : Icons.search_outlined,
                    color: currentIndex == SelectedMenu.products
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  onPressed: () {
                    ref.read(currentIndexProvider.notifier).state =
                        SelectedMenu.products;
                  },
                ),
              ),
              IconButton(
                style:
                    IconButton.styleFrom(backgroundColor: Colors.transparent),
                icon: Icon(
                  currentIndex == SelectedMenu.settings
                      ? Icons.add_circle
                      : Icons.add_circle_outline,
                  color: currentIndex == SelectedMenu.settings
                      ? Colors.blue
                      : Colors.grey,
                ),
                onPressed: () {
                  ref.read(currentIndexProvider.notifier).state =
                      SelectedMenu.settings;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SelectedMenu currentIndex, bool isAuthenticated) {
    switch (currentIndex) {
      case SelectedMenu.home:
        return CategoryPage();
      case SelectedMenu.settings:
        return const AuthPage();
      case SelectedMenu.products:
        return isAuthenticated
            ? const Center(child: Text('Notifications Page'))
            : CategoryPage();
      default:
        return CategoryPage();
    }
  }
}
