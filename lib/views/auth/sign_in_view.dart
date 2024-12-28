import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/auth_service.dart';
import 'package:tez_bazar/texts/text_constants.dart';

class SignInView extends ConsumerStatefulWidget {
  const SignInView({super.key});

  @override
  ConsumerState<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(authViewProvider);
    final authService = ref.read(authServiceProvider.notifier);
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isAuthenticated == AuthViewContent.error
                ? textForm(
                    TextConstants.anyErrorText,
                    20,
                    textAlign: TextAlign.center,
                    color: AppColors.primaryColor,
                  )
                : textForm(
                    TextConstants.authenticateText,
                    20,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.center,
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white.withOpacity(.1),
                elevation: 10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                authService.signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'lib/assets/images/google_logo.png',
                    fit: BoxFit.contain,
                    width: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  textForm(
                    TextConstants.authWithGoogleButton,
                    20,
                    color: AppColors.primaryColor,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
