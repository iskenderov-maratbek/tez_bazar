import 'package:flutter/material.dart';

final Color textColor = Colors.white;

Widget textForm(
  String text,
  double size, {
  Color? color,
  TextOverflow? overflow,
  TextAlign? textAlign,
  FontWeight? weight,
  TextDecoration? decoration,
  Color? decorationColor,
  int? maxLines,
  bool italic = false,
}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    style: TextStyle(
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
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

setPrice(int price, double priceFontSize, {double? position}) => Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        textForm('$price', priceFontSize),
        Padding(
          padding: EdgeInsets.symmetric(vertical: position ?? 4, horizontal: 2),
          child: Image.asset(
            'lib/assets/images/icons/currency_yellow.png',
            fit: BoxFit.contain,
            width: priceFontSize * .4,
          ),
        ),
      ],
    );

setCurrency(double priceFontSize) => Padding(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      child: Image.asset(
        'lib/assets/images/icons/currency_yellow.png',
        fit: BoxFit.contain,
        width: priceFontSize,
      ),
    );
