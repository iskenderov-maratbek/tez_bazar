import 'package:flutter/material.dart';
import 'package:tez_bazar/common/widgets/bottom_sheet_sets.dart';
import 'package:tez_bazar/views/home/routes/products/widgets/info_view.dart';

bottomSheet(ref, context, product) {
  showModalBottomSheet(
    enableDrag: BottomSheetSets.enableDrag,
    backgroundColor: BottomSheetSets.backgroundColor,
    context: context,
    isScrollControlled: BottomSheetSets.fullScreenView,
    builder: (context) {
      return InfoView(
        name: product.name,
        price: product.price,
        priceType: product.priceType,
        photo: product.photo,
        description: product.description,
        delivery: product.delivery,
        seller: product.seller,
        location: product.location,
        number: product.phone,
        whatsapp: product.whatsapp,
      );
    },
  );
}
