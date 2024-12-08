import 'package:flutter/material.dart';

final Color textColor = Colors.white;

textForm(
  String text,
  double size, {
  Color? color,
  TextOverflow? overflow,
  TextAlign? textAlign,
  FontWeight? weight,
  TextDecoration? decoration,
  Color? decorationColor,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: size,
      color: color ?? textColor,
      overflow: overflow,
      fontWeight: weight,
      decoration: decoration,
      decorationColor: decorationColor,
    ),
  );
}

String setPhoneFormat(String phoneNumber) {
  String cleaned = phoneNumber.replaceAll(RegExp(r'[^+\d]'), '');

  if (cleaned.length == 13 && cleaned.startsWith('+996')) {
    return '${cleaned.substring(0, 4)} (${cleaned.substring(4, 7)}) ${cleaned.substring(7, 9)}-${cleaned.substring(9, 11)}-${cleaned.substring(11, 13)}';
  } else {
    return phoneNumber;
  }
}

setCurrency(double width) => Image.asset(
      'lib/assets/images/icons/currency_yellow.png',
      fit: BoxFit.contain,
      width: width,
    );
