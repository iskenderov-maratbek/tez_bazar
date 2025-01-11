import 'package:flutter/material.dart';
import 'package:tez_bazar/common/app_colors.dart';

class GridViewSets {
  static padding() => EdgeInsets.only(bottom: 10, top: 20);
  static itemImageBorderRadius({bool top = false}) => top
      ? BorderRadius.vertical(top: Radius.circular(10))
      : BorderRadius.vertical(bottom: Radius.circular(10));
  static itemImageBorderRadiusAds({bool left = false}) => left
      ? BorderRadius.horizontal(left: Radius.circular(10))
      : BorderRadius.horizontal(right: Radius.circular(10));
  static itemInfoBackgroundColor() => LinearGradient(
        colors: [
          AppColors.white.withOpacity(.3),
          AppColors.white.withOpacity(.1),
        ],
        stops: [0.1, 0.5],
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
      );
  static itemInfoTextColor() => Colors.white;
  static itemTitleFontSize() => 17.0;
  static itemInfoBorderColor() => Border.all(color: Colors.transparent);
  static delegate() => const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Количество столбцов
        crossAxisSpacing: 10, // Отступ между столбцами
        mainAxisSpacing: 10, // Отступ между строками
        childAspectRatio: 0.7, // Соотношение сторон элементов
      );
  static delegateCategory() => const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Количество столбцов
        crossAxisSpacing: 10, // Отступ между столбцами
        mainAxisSpacing: 10, // Отступ между строками
        childAspectRatio: 1.1, // Соотношение сторон элементов
      );
}
