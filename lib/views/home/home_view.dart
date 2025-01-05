import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/forms/loading.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/refresh_service.dart';
import 'package:tez_bazar/views/main/carousel_main.dart';
import 'package:tez_bazar/views/main/category_view.dart';
import 'package:tez_bazar/views/page_builder.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  @override
  ConsumerState<HomeView> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeView>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  late AnimationController _animationController;
  bool isSnackBarVisible = false;
  OverlayEntry? overlayEntry;
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    logInfo(ModalRoute.of(context)?.settings.name);
    logView('HomeView');
    final errorDialog = ref.watch(errorDialogProvider);
    final dialogText = ref.watch(errorDialogMessageProvider);
    errorDialog ? showOverlay(context, dialogText ?? '') : null;
    return PageBuilder(
      onRefresh: () async {
        ref.read(mainServiceProvider).getMainData();
      },
      child: ListView(
        children: [
          SizedBox(height: 10),
          CarouselMainView(),
          // PinButtons(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                textForm(TextConstants.categories, 22),
                SizedBox(height: 20),
                CategoryView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBody(BottomSelectedMenu currentIndex,
  //     AuthViewContent isAuthenticated, ScrollController scrollController) {
  //   _animationController.reset();
  //   _animationController.forward();
  //   return AnimatedSwitcher(
  //     duration: const Duration(milliseconds: 300),
  //     transitionBuilder: (Widget child, Animation<double> animation) {
  //       return FadeTransition(opacity: animation, child: child);
  //     },
  //     child: switch (currentIndex) {
  //       BottomSelectedMenu.home => Router(selectedState: currentIndex),
  //       BottomSelectedMenu.account => Router(selectedState: currentIndex),
  //       BottomSelectedMenu.userProducts => const AdsView(),
  //     },
  //   );
  // }

//   void _popSystem(bottomMenu, gridViewState, authView) {
//     switch (bottomMenu) {
//       case BottomSelectedMenu.home:
//         if (gridViewState == GridPage.product) {
//           ref.read(appBarTitleProvider.notifier).state =
//               TextConstants.homeTitle;
//           ref.read(gridViewStateProvider.notifier).state = GridPage.category;
//           break;
//         } else if (gridViewState == GridPage.search) {
//           ref.read(appBarTitleProvider.notifier).state =
//               TextConstants.homeTitle;
//           ref.read(gridViewStateProvider.notifier).state = GridPage.category;
//           break;
//         }
//       case BottomSelectedMenu.userProducts:
//         switch (gridViewState) {
//           case GridPage.product:
//             ref.read(appBarTitleProvider.notifier).state =
//                 ref.read(productProvider.notifier).getSelectedCategory();
//             ref.read(routeProvider.notifier).state = BottomSelectedMenu.home;
//             break;

//           default:
//             ref.read(appBarTitleProvider.notifier).state =
//                 TextConstants.homeTitle;
//             ref.read(routeProvider.notifier).state = BottomSelectedMenu.home;
//         }
//         break;
//       case BottomSelectedMenu.account:
//         switch (authView) {
//           case AuthViewContent.profile:
//             ref.read(appBarTitleProvider.notifier).state =
//                 TextConstants.accountPageTitle;
//             ref.read(authViewProvider.notifier).state =
//                 AuthViewContent.accountPage;
//             break;
//           default:
//             switch (gridViewState) {
//               case GridPage.product:
//                 ref.read(appBarTitleProvider.notifier).state =
//                     ref.read(productProvider.notifier).getSelectedCategory();
//                 ref.read(routeProvider.notifier).state =
//                     BottomSelectedMenu.home;
//               case GridPage.search:
//                 ref.read(appBarTitleProvider.notifier).state =
//                     ref.read(searchProvider.notifier).getSearchValue();
//                 ref.read(routeProvider.notifier).state =
//                     BottomSelectedMenu.home;
//                 break;

//               default:
//                 ref.read(appBarTitleProvider.notifier).state =
//                     TextConstants.homeTitle;
//                 ref.read(routeProvider.notifier).state =
//                     BottomSelectedMenu.home;
//             }
//         }
//     }
//   }
// }
}
