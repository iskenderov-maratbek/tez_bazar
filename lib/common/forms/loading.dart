import 'package:flutter/material.dart';
import 'package:tez_bazar/common/app_colors.dart';

loadingCircle({double? size, Color? color, double? strokeWidth}) {
  return Center(
    child: SizedBox(
      width: size ?? 50,
      height: size ?? 50,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryColor,
        strokeWidth: strokeWidth ?? 10,
        strokeCap: StrokeCap.round,
      ),
    ),
  );
}
