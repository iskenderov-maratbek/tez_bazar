import 'package:flutter/material.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/views/user_products/popUpMenu/popUpMenu.dart';

popUpArchiveList(productId, name, price, toArchive, toDelete) =>
    PopupMenuButton<int>(
      color: AppColors.black,
      padding: EdgeInsets.symmetric(horizontal: 20),
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
            toArchive();

            break;
          case 2:
            toDelete();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 1,
          child: setPopupButton(
            icon: Icons.keyboard_double_arrow_up_rounded,
            color: AppColors.whatasapp,
            text: TextConstants.toActiveText,
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: setPopupButton(
            icon: Icons.highlight_remove_rounded,
            color: AppColors.error,
            text: TextConstants.toDeleteText,
          ),
        ),
      ],
    );
