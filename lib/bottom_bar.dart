import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/providers/providers.dart';

class CustomBottomBar extends ConsumerStatefulWidget {
  const CustomBottomBar({super.key});

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends ConsumerState<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      body: _buildBody(currentIndex),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                ref.read(currentIndexProvider.notifier).state =
                    SelectedMenu.home;
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                ref.read(currentIndexProvider.notifier).state =
                    SelectedMenu.products;
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                ref.read(currentIndexProvider.notifier).state =
                    SelectedMenu.settings;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(SelectedMenu currentIndex) {
    switch (currentIndex) {
      case SelectedMenu.home:
        return Center(child: Text('Home Page'));
      case SelectedMenu.products:
        return Center(child: Text('Search Page'));
      case SelectedMenu.settings:
        return Center(child: Text('Home Page'));
    }
  }
}
