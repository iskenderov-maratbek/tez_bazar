import 'package:flutter/material.dart';

noImg({double? width, double? height, BoxFit fit = BoxFit.contain}) {
  return Image.asset(
    // product.photo ??
    'lib/assets/images/200.png',
    fit: fit,
    width: width,
    height: height,
  );
}
