import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/auth_service.dart';
import 'package:tez_bazar/texts/text_constants.dart';

class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AccountView> {
  Image? profilePhoto;
  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider.notifier);
    final user = ref.watch(authServiceProvider);
    profilePhoto = null;
    profilePhoto = Image.network(
      user!.profilePhoto!,
      fit: BoxFit.cover,
      width: 80,
    );

    return ListView(
      padding: const EdgeInsets.only(top: 180, bottom: 100, right: 5, left: 5),
      children: [
        ElevatedButton(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white.withOpacity(.1),
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          onPressed: () {
            ref.read(authViewProvider.notifier).state = AuthViewContent.profile;
            ref.read(appBarTitleProvider.notifier).state =
                TextConstants.profileTitle;
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.white.withOpacity(.5),
                  child: user.profilePhoto != null
                      ? profilePhoto
                      : Icon(
                          Icons.person_rounded,
                          size: 80,
                        ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textForm(TextConstants.profileTitle, 24,
                        weight: FontWeight.bold),
                    textForm(user.name, 16),
                    user.phone != null
                        ? textForm(user.phone!, 16)
                        : textForm(
                            '⚠ Номер не указан',
                            16,
                            color: AppColors.primaryColor,
                          ),
                  ],
                ),
              ),
              Visibility(
                visible: user.phone != null,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 30,
                    color: AppColors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Divider(
            color: AppColors.white.withOpacity(.5),
          ),
        ),
        ElevatedButton(
          iconAlignment: IconAlignment.start,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white.withOpacity(.1),
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
          onPressed: () {
            authService.signOut();
            ref.read(appBarTitleProvider.notifier).state =
                TextConstants.singInTitle;
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Icon(
                    Icons.logout,
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
  }
}
