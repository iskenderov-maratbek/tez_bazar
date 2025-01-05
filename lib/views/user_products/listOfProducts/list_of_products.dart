import 'package:flutter/material.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/confirm_form.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/grid_view_sets.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/models/user_products.dart';
import 'package:tez_bazar/services/user_service.dart';
import 'package:tez_bazar/views/page_builder.dart';
import 'package:tez_bazar/views/user_products/listOfProducts/set_status_products.dart';
import 'package:tez_bazar/views/user_products/popUpMenu/active_list_menu.dart';
import 'package:tez_bazar/views/user_products/popUpMenu/archive_list_menu.dart';
import 'package:tez_bazar/views/user_products/popUpMenu/popUpMenu.dart';

PageBuilder listOfUserProducts(context, ref,
    {required List<UserProducts> filteredAds,
    required Function onRefresh,
    required ScrollController scrollController,
    required String selectedSegment,
    required Function productInfo}) {
  return PageBuilder(
    onRefresh: () async {
      onRefresh();
    },
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 10),
      controller: scrollController,
      itemCount: filteredAds.length,
      itemBuilder: (context, index) {
        final adsSet = filteredAds[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ElevatedButton(
                  onPressed: () {
                    productInfo(context, adsSet);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius:
                                GridViewSets.itemImageBorderRadiusAds(),
                            color: AppColors.backgroundColor,
                          ),
                          child: Stack(
                            children: [
                              adsSet.photo != null
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
                              Center(
                                child: setStatus(
                                  adsSet.status,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  GridViewSets.itemImageBorderRadiusAds(),
                              color: AppColors.backgroundColor),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: textForm(adsSet.name,
                                          GridViewSets.itemTitleFontSize(),
                                          color:
                                              GridViewSets.itemInfoTextColor(),
                                          weight: FontWeight.bold,
                                          maxLines: 2,
                                          overflow: TextOverflow.fade),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                    selectedSegment == 'activeModerate'
                                        ? _popUpActiveList(
                                            context,
                                            ref,
                                            adsSet.id,
                                            adsSet.name,
                                            adsSet.price)
                                        : _popUpArchiveList(
                                            context,
                                            ref,
                                            adsSet.id,
                                            adsSet.name,
                                            adsSet.price),
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
              ),
            ],
          ),
        );
      },
    ),
  );
}

_popUpActiveList(context, ref, productId, name, price) {
  return popUpActiveList(
      productId,
      name,
      price,
      confirmForm(
        context,
        title: TextConstants.confirmArchiveAdText,
        onConfirm: () {
          ref.read(userServiceProvider.notifier).archiveProduct(productId);
        },
        body: buildConfirmCard(
          name,
          price,
        ),
      ),
      confirmForm(
        context,
        title: TextConstants.confirmDeleteAdText,
        onConfirm: () {
          ref.read(userServiceProvider.notifier).removeProduct(productId);
        },
        body: buildConfirmCard(
          name,
          price,
        ),
      ));
}

_popUpArchiveList(context, ref, productId, name, price) {
  return popUpArchiveList(
    productId,
    name,
    price,
    confirmForm(
      context,
      title: TextConstants.confirmActiveAdText,
      onConfirm: () {
        ref.read(userServiceProvider.notifier).moderateProduct(productId);
      },
      body: buildConfirmCard(name, price),
    ),
    confirmForm(
      context,
      title: TextConstants.confirmDeleteAdText,
      onConfirm: () {
        ref.read(userServiceProvider.notifier).removeProduct(productId);
      },
      body: buildConfirmCard(name, price),
    ),
  );
}
