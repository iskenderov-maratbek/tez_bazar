import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/services/refresh_service.dart';
import 'package:tez_bazar/views/user_products/widgets/active_list.dart';
import 'package:tez_bazar/views/user_products/widgets/archive_list.dart';

class UserProductsView extends ConsumerStatefulWidget {
  const UserProductsView({super.key});

  @override
  UserProductsViewState createState() => UserProductsViewState();
}

class UserProductsViewState extends ConsumerState<UserProductsView> {
  String _selectedSegment = 'activeModerate';
  final Map<String, int> _selectedMenu = {
    'activeModerate': 0,
    'archiveSold': 1
  };

  late final PageController _pageController;

  void __changePage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOutQuint,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(refreshServiceProvider.notifier).refresh(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    logView(runtimeType);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 120,
            bottom: 0,
            left: 5,
            right: 5,
          ),
          child: Consumer(
            builder: (context, ref, child) {
              return PageView(
                  onPageChanged: (index) {
                    setState(() {
                      _selectedSegment =
                          index == 0 ? 'activeModerate' : 'archiveSold';
                    });
                  },
                  controller: _pageController,
                  children: [
                    ActiveList(),
                    ArchiveList(),
                  ]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: shadowAppBar(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: _segmentedSliding(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  CupertinoSlidingSegmentedControl<String> _segmentedSliding() {
    return CupertinoSlidingSegmentedControl<String>(
      padding: EdgeInsets.only(top: 50, left: 5, right: 5, bottom: 10),
      backgroundColor: AppColors.black.withOpacity(.1),
      thumbColor: AppColors.primaryColor,
      groupValue: _selectedSegment,
      children: {
        'activeModerate': TextConstants.statusTypeActive,
        'archiveSold': TextConstants.statusTypeArchive,
      }.map(
        (key, value) => MapEntry<String, Widget>(
          key,
          SizedBox(
            width: double.maxFinite,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: textForm(
                  value,
                  18,
                  textAlign: TextAlign.center,
                  color: _selectedSegment == key ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      onValueChanged: (String? value) {
        setState(() {
          _selectedSegment = value!;
          __changePage(_selectedMenu[_selectedSegment]!);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
