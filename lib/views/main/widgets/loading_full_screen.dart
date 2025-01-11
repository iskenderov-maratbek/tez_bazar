import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/loading.dart';
import 'package:tez_bazar/common/logging.dart';

class LoadingFullScreen extends ConsumerWidget {
  const LoadingFullScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logView(runtimeType);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: AppColors.transparent,
        shadowColor: AppColors.transparent,
        surfaceTintColor: AppColors.transparent,
        content: Container(
          width: double.maxFinite,
          color: AppColors.black.withOpacity(.3),
          child: LoadingAnimation(
            size: 100,
          ),
        ),
      ),
    );
  }
}
