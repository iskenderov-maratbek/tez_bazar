import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FontWeight,
        Icon,
        MainAxisAlignment,
        MainAxisSize,
        Row,
        SizedBox,
        TextAlign;
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';

setPopupButton({icon, color, text}) => Row(
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

buildConfirmCard(adName, adPrice) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white.withOpacity(.2)),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        textForm(adName, 20,
            textAlign: TextAlign.center, weight: FontWeight.bold),
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
  );
}
