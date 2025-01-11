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

networkImg(
    {required String src,
    required double width,
    double? height,
    double? size}) {
  if (src.contains('http')) {
    return Image.network(src,
        fit: BoxFit.cover, width: width, height: height ?? width,
        loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: LoadingAnimation(size: size ?? width),
      );
    });
  } else {
    return Image.asset(
      src,
      fit: BoxFit.cover,
      width: width,
      height: height ?? width,
    );
  }
}

shadowAppBar({child, bgColor = AppColors.black}) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bgColor,
            offset: Offset(0, 0),
            spreadRadius: 3,
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
