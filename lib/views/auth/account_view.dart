import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/confirm_form.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/models/user.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/auth_service.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/services/refresh_service.dart';
import 'package:tez_bazar/views/page_builder.dart';

class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AccountView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider.notifier);
    final user = ref.watch(authServiceProvider);
    final isAuth = ref.watch(isAuthenticatedProvider);
    logView('AccountView');
    return PageBuilder(
      child: ListView(
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 500),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.content,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Center(
                      child: textForm(
                        TextConstants.profileTitle,
                        24,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (isAuth) _buildAuthenticatedBody(user!, authService),
                  if (!isAuth) _buildsignInBody(authService),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 500),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.content,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Center(
                    child: textForm(
                      'Настройки',
                      24,
                      weight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    iconAlignment: IconAlignment.start,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkgrey,
                        elevation: 10,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Icon(
                            Icons.settings,
                            color: AppColors.primaryColor,
                            size: 30,
                          ),
                        ),
                        textForm('Настройки', 20, weight: FontWeight.bold),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildAuthenticatedBody(User user, AuthService authService) => Column(
        children: [
          ElevatedButton(
            iconAlignment: IconAlignment.start,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkgrey,
                elevation: 10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
            onPressed: () {
              logInfo(' Go to profile');
              ref.read(accountStateProvider.notifier).state =
                  AccountState.profile;
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: user.profilePhoto != null
                          ? networkImg(
                              src: user.profilePhoto!,
                              width: 80,
                              size: 30,
                            )
                          : Icon(
                              Icons.person_rounded,
                              size: 80,
                            ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textForm(
                          user.name.replaceAll(' ', '\n'),
                          20,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          weight: FontWeight.bold,
                        ),
                        user.phone != null
                            ? textForm(user.phone!, 16)
                            : textForm(
                                '⚠ Номер не указан',
                                16,
                                color: AppColors.primaryColor,
                              ),
                      ],
                    ),
                  ],
                ),
                if (user.phone != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 30,
                      color: AppColors.green,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            iconAlignment: IconAlignment.start,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkgrey,
                elevation: 10,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
            onPressed: () {
              confirmForm(
                context,
                title: 'Выход из аккаунта',
                content: 'Вы уверены что хотите выйти?',
                onConfirm: () {
                  authService.signOut();
                  ref.read(appBarTitleProvider.notifier).state =
                      TextConstants.singInTitle;
                },
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Icon(
                      Icons.logout,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                  ),
                ),
                textForm('Выйти из аккаунта', 20, weight: FontWeight.bold),
              ],
            ),
          ),
        ],
      );

  _buildsignInBody(authService) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              ref.read(refreshServiceProvider.notifier).refresh(() {
                authService.signInWithGoogle();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
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
                  color: AppColors.black,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // authService.signInWithGoogle();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  'lib/assets/images/apple_logo.png',
                  fit: BoxFit.contain,
                  width: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                textForm(
                  TextConstants.authWithAppleButton,
                  20,
                  color: AppColors.white,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
}
