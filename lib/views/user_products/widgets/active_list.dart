import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/confirm_form.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/grid_view_sets.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/auth_service.dart';
import 'package:tez_bazar/products_services/user_service.dart';
import 'package:tez_bazar/views/page_builder.dart';
import 'package:tez_bazar/views/user_products/listOfProducts/set_status_products.dart';
import 'package:tez_bazar/views/user_products/popUpMenu/active_list_menu.dart';
import 'package:tez_bazar/views/user_products/popUpMenu/popUpMenu.dart';
import 'package:tez_bazar/views/user_products/utils/product_info.dart';

class ActiveList extends ConsumerStatefulWidget {
  const ActiveList({super.key});

  @override
  ConsumerState<ActiveList> createState() => _ActiveListState();
}

class _ActiveListState extends ConsumerState<ActiveList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onActiveScroll);
    ref
        .read(activeProductProvider.notifier)
        .getUserProducts(ref.read(authServiceProvider)!.id);
  }

  void _onActiveScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref
          .read(activeProductProvider.notifier)
          .getUserProducts(ref.read(authServiceProvider)!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    logView(runtimeType);
    final double priceFontSize = 18;
    final product = ref.watch(activeProductProvider);
    return PageBuilder(
      onRefresh: () async {
        logInfo('activeList onRefresh');
        ref.read(activeProductProvider.notifier).clear();
        ref
            .read(activeProductProvider.notifier)
            .getUserProducts(ref.read(authServiceProvider)!.id);
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 10),
        controller: _scrollController,
        itemCount: product.length,
        itemBuilder: (context, index) {
          final setProduct = product[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ElevatedButton(
                    onPressed: () {
                      productInfo(context, setProduct);
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
                                setProduct.photo != null
                                    ? networkImg(
                                        src: setProduct.photo!,
                                        width: 100,
                                        height: 100,
                                      )
                                    : noImg(
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.contain),
                                Center(
                                  child: setStatus(
                                    setProduct.status,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: textForm(setProduct.name,
                                            GridViewSets.itemTitleFontSize(),
                                            color: GridViewSets
                                                .itemInfoTextColor(),
                                            weight: FontWeight.bold,
                                            maxLines: 2,
                                            overflow: TextOverflow.fade),
                                      ),
                                      setPrice(setProduct.price, priceFontSize),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 5,
                                  bottom: 5,
                                  top: 5,
                                  child: _popUpActiveList(
                                    context,
                                    ref,
                                    setProduct.id,
                                    setProduct.name,
                                    setProduct.price,
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
}

_popUpActiveList(context, ref, productId, name, price) {
  return popUpActiveList(
    productId,
    name,
    price,
    () {
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
      );
    },
    () {
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
      );
    },
  );
}
