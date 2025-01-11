import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/profile_forms.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/validators.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/auth_service.dart';
import 'package:tez_bazar/products_services/user_service.dart';
import 'package:tez_bazar/constants/text_constants.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  bool whatasappConnect = false;
  final _formKey = GlobalKey<FormState>();
  late String? _selectedItem;
  final List<Map<String, dynamic>> _items = [
    {
      'icon': ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'lib/assets/images/icons/kg_flag_small.png',
          fit: BoxFit.contain,
          width: 30,
          height: 30,
        ),
      ),
      'text': TextConstants.kgCounterCode
    },
    {
      'icon': ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'lib/assets/images/icons/ru_flag_small.png',
          fit: BoxFit.contain,
          height: 30,
          width: 30,
        ),
      ),
      'text': TextConstants.ruCounterCode
    },
  ];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();

    _usernameController.text = ref.read(authServiceProvider)?.name ?? '';
    _phoneNumberController.text =
        ref.read(authServiceProvider)!.phone?.substring(4) ?? '';
    _locationController.text = ref.read(authServiceProvider)?.location ?? '';
    final valueWhatsapp = ref.read(authServiceProvider)!.whatsapp;
    if (valueWhatsapp != null) {
      if (valueWhatsapp.contains('+996')) {
        _selectedItem = _items[0]['text'];
        _whatsappController.text = valueWhatsapp.substring(4);
      } else {
        _selectedItem = _items[1]['text'];
        _whatsappController.text = valueWhatsapp.substring(2);
      }
    }
  }

  Future<void> _pickImage() async {
    final imageService = ref.read(imageUploadProvider);
    final pickedImage = await imageService.pickImage();
    pickedImage != null
        ? setState(() {
            _image = pickedImage;
          })
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userServiceStateProvider);
    final user = ref.watch(authServiceProvider);
    final double sizedBoxesHeight = 30;
    final double sizedBoxesWidth = 5;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userState == UserResponseState.success) {
        ref.read(accountStateProvider.notifier).state = AccountState.account;
        ref.read(userServiceStateProvider.notifier).state =
            UserResponseState.stateDefault;
      }
    });
    logView(runtimeType);
    return Scaffold(
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 100, bottom: 100, right: 5, left: 5),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: AppColors.white.withOpacity(.5),
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  width: 200,
                                  fit: BoxFit.cover,
                                )
                              : user!.profilePhoto != null
                                  ? Image.network(
                                      user.profilePhoto!,
                                    )
                                  : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 150,
                      child: Center(
                        child: IconButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.black.withOpacity(.1),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor:
                                AppColors.primaryColor.withOpacity(.9),
                          ),
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.edit_rounded,
                            size: 30,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: sizedBoxesHeight,
              ),
              textForm(
                user?.email ?? '',
                18,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: sizedBoxesHeight,
              ),
              TFForms(
                controller: _usernameController,
                label: TextConstants.usernameFieldLabel,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zа-яА-Я ]')),
                  LengthLimitingTextInputFormatter(100),
                ],
                validator: Validators.validateFullName,
              ),
              SizedBox(
                height: sizedBoxesHeight,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'lib/assets/images/icons/kg_flag_small.png',
                              fit: BoxFit.contain,
                              width: 30,
                            ),
                          ),
                          SizedBox(
                            width: sizedBoxesWidth,
                          ),
                          textForm(
                            TextConstants.kgCounterCode,
                            18,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: sizedBoxesWidth,
                    ),
                    Expanded(
                      child: TFForms(
                        controller: _phoneNumberController,
                        label: TextConstants.phoneNumberFieldLabel,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        keyboardType: TextInputType.number,
                        validator: Validators.phoneValidator,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    whatasappConnect = !whatasappConnect;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 1.4,
                      child: Checkbox(
                        checkColor: AppColors.black,
                        activeColor: AppColors.primaryColor,
                        value: whatasappConnect,
                        onChanged: (value) {
                          setState(() {
                            value!
                                ? whatasappConnect = true
                                : whatasappConnect = false;
                          });
                        },
                      ),
                    ),
                    textForm(
                      TextConstants.phoneWithWhatsapp,
                      18,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: sizedBoxesHeight,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: !whatasappConnect
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 15),
                            child: DropdownButton(
                              padding: EdgeInsets.all(0),
                              dropdownColor: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              underline: Container(),
                              icon: Icon(
                                Icons.keyboard_double_arrow_down_rounded,
                                size: 30,
                                color: AppColors.primaryColor,
                              ),
                              value: _selectedItem,
                              items: _items.map((item) {
                                return DropdownMenuItem<String>(
                                  alignment: Alignment.centerLeft,
                                  value: item['text'],
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        item['icon'],
                                        SizedBox(
                                          width: 2,
                                        ),
                                        textForm(
                                          item['text'],
                                          18,
                                          color: AppColors.white,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedItem = newValue;
                                });
                              },
                            ),
                            //
                          ),
                          SizedBox(
                            width: sizedBoxesWidth,
                          ),
                          Expanded(
                            child: TFForms(
                              controller: _whatsappController,
                              label: TextConstants.whatsappFieldLabel,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    _selectedItem == TextConstants.ruCounterCode
                                        ? 10
                                        : 9),
                              ],
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final ruCountry = RegExp(r'^\d{10}$');
                                final kgCountry = RegExp(r'^\d{9}$');
                                if (value == null || value.isEmpty) {
                                  return null;
                                } else if (_selectedItem ==
                                    TextConstants.ruCounterCode) {
                                  if (!ruCountry.hasMatch(value)) {
                                    return TextConstants.invalidNumberIncorrect;
                                  }
                                } else if (_selectedItem ==
                                    TextConstants.kgCounterCode) {
                                  if (!kgCountry.hasMatch(value)) {
                                    return TextConstants.invalidNumberIncorrect;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
              Visibility(
                visible: !whatasappConnect,
                child: SizedBox(
                  height: sizedBoxesHeight,
                ),
              ),
              TFForms(
                controller: _locationController,
                label: TextConstants.locationFieldLabel,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                validator: Validators.validateNotEmpty,
              ),
              SizedBox(
                height: sizedBoxesHeight,
              ),
              ElevatedButton(
                onPressed: () {
                  _checkToUpdate();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: textForm(
                  TextConstants.textSaveButton,
                  18,
                  color: AppColors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _checkToUpdate() {
    if (_formKey.currentState!.validate()) {
      final dataUser = ref.read(authServiceProvider);
      if (_usernameController.text != dataUser!.name ||
          _phoneNumberController.text != dataUser.phone ||
          _locationController.text != dataUser.location) {
        final number = '+996${_phoneNumberController.text}';
        final whatsapp = whatasappConnect
            ? number
            : _whatsappController.text.isNotEmpty
                ? _selectedItem! + _whatsappController.text
                : '';
        ref.read(userServiceProvider.notifier).userdataUpdate(
              image: _image,
              name: _usernameController.text,
              number: number,
              whatsapp: whatasappConnect ? number : whatsapp,
              location: _locationController.text,
              id: ref.read(authServiceProvider)!.id,
            );
      } else {}
    }
  }
}
