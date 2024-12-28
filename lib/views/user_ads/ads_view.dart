import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/loading.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/common/widgets/bottom_sheet_sets.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/common/grid_view_sets.dart';
import 'package:tez_bazar/services/auth_service.dart';
import 'package:tez_bazar/services/user_service.dart';
import 'package:tez_bazar/texts/text_constants.dart';
import 'package:tez_bazar/views/user_ads/add_ad.dart';
import 'package:tez_bazar/views/user_ads/add_edit_view.dart';

class AdsView extends ConsumerStatefulWidget {
  const AdsView({super.key});

  @override
  AdsViewState createState() => AdsViewState();
}

class AdsViewState extends ConsumerState<AdsView> {
  final ScrollController _scrollController = ScrollController();
  late final _userId;
  bool _isRefreshing = false;

  String _selectedSegment = 'activeModerate';

  @override
  void initState() {
    super.initState();
    _userId = ref.read(authServiceProvider)!.id;
    _scrollController.addListener(_onActiveScroll);
    ref.read(adsProvider.notifier).getAds(_userId);
  }

  void _onActiveScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(adsProvider.notifier).getAds(_userId);
    }
  }

  _popUpActiveList(productId, name, price) => PopupMenuButton<int>(
        color: AppColors.black,
        padding: EdgeInsets.symmetric(horizontal: 20),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        icon: Icon(
          Icons.more_vert_rounded,
          color: AppColors.primaryColor,
          size: 30,
        ),
        onSelected: (int result) {
          switch (result) {
            case 1:
              _showConfirmDialog(
                productId,
                titleText: TextConstants.confirmActiveAdText,
                adName: name,
                adPrice: price,
                confirmFunction: () {
                  ref.read(userServiceProvider.notifier).archiveAd(productId);
                  _refreshAds();
                },
              );
              break;
            case 2:
              _showConfirmDialog(
                productId,
                titleText: TextConstants.confirmDeleteAdText,
                adName: name,
                adPrice: price,
                confirmFunction: () {
                  ref.read(userServiceProvider.notifier).removeAd(productId);
                  _refreshAds();
                },
              );
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
          PopupMenuItem<int>(
            value: 1,
            child: _setPopupButton(
              icon: Icons.archive_rounded,
              color: AppColors.grey,
              text: TextConstants.toArchiveText,
            ),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: _setPopupButton(
              icon: Icons.highlight_remove_rounded,
              color: AppColors.error,
              text: TextConstants.toDeleteText,
            ),
          ),
        ],
      );
  _popUpArchiveList(productId, name, price) => PopupMenuButton<int>(
        color: AppColors.black,
        padding: EdgeInsets.symmetric(horizontal: 20),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        icon: Icon(
          Icons.more_vert_rounded,
          color: AppColors.primaryColor,
          size: 30,
        ),
        onSelected: (int result) {
          switch (result) {
            case 1:
              _showConfirmDialog(
                productId,
                titleText: TextConstants.confirmActiveAdText,
                adName: name,
                adPrice: price,
                confirmFunction: () {
                  ref.read(userServiceProvider.notifier).moderateAd(productId);
                  _refreshAds();
                },
              );

              break;
            case 2:
              _showConfirmDialog(
                productId,
                titleText: TextConstants.confirmDeleteAdText,
                adName: name,
                adPrice: price,
                confirmFunction: () {
                  ref.read(userServiceProvider.notifier).removeAd(productId);
                  _refreshAds();
                },
              );
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
          PopupMenuItem<int>(
            value: 1,
            child: _setPopupButton(
              icon: Icons.keyboard_double_arrow_up_rounded,
              color: AppColors.whatasapp,
              text: TextConstants.toActiveText,
            ),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: _setPopupButton(
              icon: Icons.highlight_remove_rounded,
              color: AppColors.error,
              text: TextConstants.toDeleteText,
            ),
          ),
        ],
      );

  Future<void> _refreshAds() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ref.read(loadingProvider.notifier).state = true;

      if (!_isRefreshing) {
        setState(() {
          _isRefreshing = true;
        });
      } else {
        return;
      }
      // Имитация обновления данных
      await Future.delayed(Duration(seconds: ref.read(refreshTimerProvider)));
      setState(() {
        ref.read(adsProvider.notifier).clear();
        ref.read(adsProvider.notifier).getAds(_userId);
        _isRefreshing = false;

        Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
          ref.read(loadingProvider.notifier).state = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    logView(runtimeType);
    final ads = ref.watch(adsProvider);
    final filteredAds = ads.where((ad) {
      if (_selectedSegment == 'activeModerate') {
        return ad.status == TextConstants.statusActive ||
            ad.status == TextConstants.statusModerate;
      } else {
        return ad.status == TextConstants.statusArchive ||
            ad.status == TextConstants.statusSold;
      }
    }).toList();
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(top: 160, bottom: 50),
        child: RefreshIndicator(
          onRefresh: _refreshAds,
          displacement: 20,
          color: AppColors.primaryColor,
          backgroundColor: AppColors.black,
          strokeWidth: 3,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 120),
            controller: _scrollController,
            itemCount: filteredAds.length,
            itemBuilder: (context, index) {
              final adsSet = filteredAds[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Stack(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
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
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: GridViewSets.itemImageBorderRadiusAds(
                                left: true),
                            child: adsSet.photo != null
                                ? Image.network(
                                    // product.photo ??
                                    adsSet.photo!,
                                    fit: BoxFit.contain,
                                    width: 100,
                                    height: 100,
                                  )
                                : noImg(
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain),
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      GridViewSets.itemImageBorderRadiusAds(),
                                  color: AppColors.darkGrey),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: textForm(adsSet.name,
                                              GridViewSets.itemTitleFontSize(),
                                              color: GridViewSets
                                                  .itemInfoTextColor(),
                                              weight: FontWeight.bold,
                                              maxLines: 2,
                                              overflow: TextOverflow.fade),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            textForm('${adsSet.price}', 18,
                                                weight: FontWeight.w900,
                                                textAlign: TextAlign.end),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  setCurrency(8),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 5,
                                    bottom: 5,
                                    top: 5,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _selectedSegment == 'activeModerate'
                                            ? _popUpActiveList(adsSet.id,
                                                adsSet.name, adsSet.price)
                                            : _popUpArchiveList(adsSet.id,
                                                adsSet.name, adsSet.price),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: _setStatus(adsSet.status),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(.7),
              offset: Offset(0, 5),
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: CupertinoSlidingSegmentedControl<String>(
              padding: EdgeInsets.only(top: 100, left: 5, right: 5, bottom: 10),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: textForm(
                        value,
                        18,
                        textAlign: TextAlign.center,
                        color: _selectedSegment == key
                            ? Colors.black
                            : Colors.white,
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
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 100,
        right: 50,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(.7),
                offset: Offset(5, 5),
                spreadRadius: 3,
                blurRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 20,
                  backgroundColor: AppColors.primaryColor.withOpacity(.8),
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    enableDrag: BottomSheetSets.enableDrag,
                    // scrollControlDisabledMaxHeightRatio: 4,
                    backgroundColor: BottomSheetSets.backgroundColor,
                    context: context,
                    isScrollControlled: BottomSheetSets.fullScreenView,
                    builder: (context) {
                      return AddAds();
                    },
                  );
                },
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.add_rounded,
                      size: 40,
                      color: AppColors.black,
                    )),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  _setPopupButton({icon, color, text}) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          SizedBox(
            width: 2,
          ),
          textForm(
            text,
            18,
            color: AppColors.white,
          ),
        ],
      );

  _setStatus(String status) {
    Color? color;
    if (TextConstants.itemsStatus[status] == TextConstants.statusTypeModerate) {
      color = AppColors.primaryColor.withOpacity(.7);
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textForm(
              TextConstants.itemsStatus[status] ?? '',
              16,
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 5,
            ),
            loadingCircle(size: 12, color: AppColors.black, strokeWidth: 2),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  _showConfirmDialog(productId,
          {titleText, adName, adPrice, confirmFunction}) =>
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: AlertDialog(
              backgroundColor: AppColors.black.withOpacity(.9),
              actions: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: textForm(
                        titleText,
                        22,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white.withOpacity(.2)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          textForm(adName, 20,
                              textAlign: TextAlign.center,
                              weight: FontWeight.bold),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textForm(
                                '$adPrice',
                                18,
                                textAlign: TextAlign.center,
                              ),
                              setCurrency(8),
                              SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        //moderate
                        Navigator.of(context).pop();
                      },
                      child: textForm(
                        "Жок",
                        22,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        confirmFunction();
                      },
                      child: textForm(
                        "Ооба",
                        22,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
