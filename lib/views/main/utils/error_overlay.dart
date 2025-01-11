import 'package:flutter/material.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/providers/providers.dart';

void showOverlay(
    {required BuildContext context, ref, required String dialogText}) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.black.withOpacity(0.9),
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_rounded,
                color: AppColors.primaryColor,
                size: 50,
              ),
              Expanded(
                child: textForm(dialogText, 22, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Overlay.of(context).insert(overlayEntry);
  });
  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
    ref.read(errorDialogProvider.notifier).state = false;
  });
}
