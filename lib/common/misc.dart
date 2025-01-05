import 'package:flutter/material.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/loading.dart';

noImg({double? width, double? height, BoxFit fit = BoxFit.contain}) {
  return Image.asset(
    // product.photo ??
    'lib/assets/images/noImg.png',
    fit: fit,
    width: width,
    height: height,
  );
}

boxShadow({offset}) {
  return [
    BoxShadow(
      color: AppColors.black.withOpacity(0.2),
      spreadRadius: 1,
      blurRadius: 20,
      offset: offset ?? Offset.zero,
    ),
  ];
}

Image networkImg(
        {required String src,
        required double width,
        double? height,
        double? size}) =>
    Image.network(src, fit: BoxFit.cover, width: width, height: height ?? width,
        loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: LoadingAnimation(size: size ?? width),
      );
    });
