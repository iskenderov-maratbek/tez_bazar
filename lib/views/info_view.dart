import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/texts/text_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoView extends StatelessWidget {
  final String? photo;
  final String name;
  final String? description;
  final double price;
  final String? location;
  final bool delivery;
  final String seller;
  final String number;
  final String? whatsapp;

  const InfoView({
    super.key,
    this.description,
    this.location,
    required this.delivery,
    required this.seller,
    required this.name,
    required this.price,
    this.photo,
    required this.number,
    this.whatsapp,
  });

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: textForm(
        TextConstants.noWhatsapp,
        18,
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
    );
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        padding: const EdgeInsets.all(0),
        color: Colors.transparent,
        child: Center(
          child: Scaffold(
            backgroundColor: AppColors.transparent,
            body: Stack(
              children: [
                Positioned(
                  top: 80,
                  bottom: 60,
                  left: 10,
                  right: 10,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textForm(name, 32, weight: FontWeight.bold),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 15,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                // product.photo ??
                                'lib/assets/images/200.png',
                                fit: BoxFit.contain,
                                width: 250,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                // color: Colors.grey[300],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  textForm('$price', 44,
                                      weight: FontWeight.bold),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: setCurrency(15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 3,
                          color: AppColors.backgroundColor.withOpacity(.9),
                          margin: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                textForm(
                                  description ?? 'Кошумча маалымат жок',
                                  20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: AppColors.backgroundColor.withOpacity(.9),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_rounded,
                                      size: 25,
                                      color: AppColors.primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    textForm(seller, 18),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      size: 25,
                                      color: AppColors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: textForm(
                                          location ??
                                              'Дареги жонундо маалымат жок',
                                          16),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                delivery
                                    ? Row(
                                        children: [
                                          Image.asset(
                                            'lib/assets/images/icons/delivery_on.png',
                                            fit: BoxFit.contain,
                                            width: 40,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Доставка бар',
                                            style: TextStyle(
                                              color: AppColors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Image.asset(
                                            'lib/assets/images/icons/delivery_off.png',
                                            fit: BoxFit.contain,
                                            width: 40,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Доставка жок',
                                            style: TextStyle(
                                              color: Colors.red[500],
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.backgroundColor.withOpacity(.1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(.8),
                          offset: Offset(0, -5),
                          spreadRadius: 4,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: whatsapp != null
                                    ? AppColors.whatasapp
                                    : AppColors.grey,
                                padding: const EdgeInsets.all(10),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onPressed: whatsapp != null
                                ? () => _toWhatsapp(whatsapp!)
                                : () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textForm('Написать', 18,
                                    weight: FontWeight.bold),
                                const SizedBox(width: 8),
                                Image.asset(
                                  'lib/assets/images/icons/whatsapp.png',
                                  fit: BoxFit.contain,
                                  width: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.all(10),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onPressed: () => _toPhone(number),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textForm('Позвонить', 18,
                                    weight: FontWeight.bold),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.phone_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toWhatsapp(String number) async {
    Uri whatsapp = Uri.parse("https://wa.me/${number.substring(1)}");
    await launchUrl(
      whatsapp,
    );
  }

  void _toPhone(String number) async {
    Uri phone = Uri.parse("tel:$number");
    await launchUrl(
      phone,
    );
  }
}
