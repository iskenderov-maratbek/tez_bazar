import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/loading.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/providers/providers.dart';

class DialogForms {
  DialogForms._();

  static userStateDialog({
    required BuildContext context,
    required ref,
    required String loadingText,
    required String successText,
    required String errorText,
  }) {
    ref.read(userServiceStateProvider) != UserResponseState.stateDefault
        ? showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                        position: offsetAnimation, child: child),
                  );
                },
                child: Consumer(builder: (context, ref, child) {
                  final userState = ref.watch(userServiceStateProvider);

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (userState == UserResponseState.success) {
                      Future.delayed(
                        Duration(hours: 3),
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    } else if (userState == UserResponseState.error) {
                      Future.delayed(
                        Duration(seconds: 3),
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  });

                  return switch (userState) {
                    UserResponseState.loading =>
                      userLoadingDialog(context, loadingText), // Текст загрузки
                    UserResponseState.error =>
                      userErrorDialog(context, errorText), // Текст ошибки
                    UserResponseState.success =>
                      userSuccessDialog(context, successText),
                    UserResponseState.stateDefault => Container(),
                  };
                }),
              );
            },
          )
        : null;
  }

  static Widget userSuccessDialog(context, successText) {
    return userDialogForm(
      Icon(Icons.check_circle_rounded, color: AppColors.green, size: 60),
      textForm(successText, 18),
    );
  }

  static userDialogForm(icon, text) => Dialog(
        backgroundColor: AppColors.transparent,
        insetPadding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: icon,
                      ),
                      SizedBox(height: 16),
                      text,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  static userLoadingDialog(context, loadingText) => userDialogForm(
        loadingCircle(),
        textForm(loadingText, 18),
      );

  static userErrorDialog(context, errorText) => userDialogForm(
        Icon(Icons.error, color: Colors.red, size: 60),
        textForm(errorText, 18),
      );
}
