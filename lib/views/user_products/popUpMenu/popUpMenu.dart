import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        Center,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FontWeight,
        Icon,
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
  final double priceFontSize = 18;
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
        Center(
          child: setPrice(adPrice, priceFontSize),
        ),
      ],
    ),
  );
}
