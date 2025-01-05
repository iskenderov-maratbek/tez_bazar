import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/loading.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/constants/text_constants.dart';

setStatus(String status) {
  if (TextConstants.itemsStatus[status] == TextConstants.statusTypeModerate) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimation(size: 30),
            textForm(
              TextConstants.itemsStatus[status] ?? '',
              16,
              color: AppColors.white,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  } else {
    return Container();
  }
}
