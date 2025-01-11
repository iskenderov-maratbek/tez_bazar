import 'package:flutter/material.dart';
import 'package:tez_bazar/common/widgets/bottom_sheet_sets.dart';
import 'package:tez_bazar/views/user_products/widgets/edit_product.dart';

Future<dynamic> productInfo(BuildContext context, dynamic adsSet) {
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
