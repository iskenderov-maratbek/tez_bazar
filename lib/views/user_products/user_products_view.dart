import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/widgets/bottom_sheet_sets.dart';
import 'package:tez_bazar/models/user_products.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/auth_service.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/views/page_builder.dart';
import 'package:tez_bazar/views/user_products/edit_product.dart';
import 'package:tez_bazar/views/user_products/listOfProducts/list_of_products.dart';

class AdsView extends ConsumerStatefulWidget {
  const AdsView({super.key});

  @override
  AdsViewState createState() => AdsViewState();
}

class AdsViewState extends ConsumerState<AdsView> {
  final ScrollController _scrollController = ScrollController();

  String _selectedSegment = 'activeModerate';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onActiveScroll);
    ref
        .read(userProductProvider.notifier)
        .getAds(ref.read(authServiceProvider)!.id);
  }

  @override
  Widget build(BuildContext context) {
    logView(runtimeType);

    return Stack(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final ads = ref.watch(userProductProvider);
            final filteredAds = ads.where((ad) {
              if (_selectedSegment == 'activeModerate') {
                return ad.status == TextConstants.statusActive ||
                    ad.status == TextConstants.statusModerate;
              } else {
                return ad.status == TextConstants.statusArchive ||
                    ad.status == TextConstants.statusSold;
              }
            }).toList();

            return Padding(
              padding: const EdgeInsets.only(top: 110, bottom: 0),
              child: GestureDetector(
                onHorizontalDragEnd: _onHorizontalDragEnd,
                child: _listOfUserProducts(
                  filteredAds,
                ),
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: _segmentedSliding(),
            ),
          ),
        ),
      ],
    );
  }

  void _onActiveScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref
          .read(userProductProvider.notifier)
          .getAds(ref.read(authServiceProvider)!.id);
    }
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
          _scrollController.jumpTo(0);
          _selectedSegment = value!;
        });
      },
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      // Свайп влево
      setState(() {
        _selectedSegment = 'archiveSold';
      });
    } else if (details.primaryVelocity! > 0) {
      // Свайп вправо
      setState(() {
        _selectedSegment = 'activeModerate';
      });
    }
  }

  PageBuilder _listOfUserProducts(List<UserProducts> filteredAds) {
    return listOfUserProducts(context, ref, filteredAds: filteredAds,
        onRefresh: () {
      ref.read(userProductProvider.notifier).clear();
      ref
          .read(userProductProvider.notifier)
          .getAds(ref.read(authServiceProvider)!.id);
    },
        scrollController: _scrollController,
        selectedSegment: _selectedSegment,
        productInfo: _productInfo);
  }

  Future<dynamic> _productInfo(BuildContext context, UserProducts adsSet) {
    return showModalBottomSheet(
      enableDrag: BottomSheetSets.enableDrag,
      // scrollControlDisabledMaxHeightRatio: 4,
      backgroundColor: BottomSheetSets.backgroundColor,
      context: context,
      isScrollControlled: BottomSheetSets.fullScreenView,
      builder: (context) {
        return AddEditView(
          id: adsSet.id,
          name: adsSet.name,
          price: adsSet.price,
          priceType: adsSet.priceType,
          photo: adsSet.photo,
          description: adsSet.description,
          delivery: adsSet.delivery,
          location: adsSet.location,
          categoryId: adsSet.categoryId,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
