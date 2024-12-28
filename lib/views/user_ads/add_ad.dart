import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/profile_forms.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/common/validators.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/services/user_service.dart';
import 'package:tez_bazar/texts/text_constants.dart';

class AddAds extends ConsumerStatefulWidget {
  const AddAds({
    super.key,
  });

  @override
  ConsumerState<AddAds> createState() => _AddAdsState();
}

class _AddAdsState extends ConsumerState<AddAds> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool delivery = false;
  final double sizedBoxesHeight = 30;
  final double sizedBoxesWidth = 10;
  late String _selectedPriceType;
  final List<String> _itemsPriceType = [
    TextConstants.priceTypePieces,
    TextConstants.priceTypeLts,
    TextConstants.priceTypeKgs,
  ];
  late String? _selectedCategory;
  late final Map<String, dynamic> _itemsCategories;
  File? _image;

  @override
  void initState() {
    _selectedCategory = '1';
    _selectedPriceType = _itemsPriceType[0];
    _itemsCategories = ref.read(categoriesProvider);
    super.initState();
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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        padding: const EdgeInsets.all(0),
        color: Colors.black.withOpacity(.7),
        child: Center(
          child: Scaffold(
            backgroundColor: AppColors.transparent,
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 150,
                left: 10,
                right: 10,
                bottom: 100,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    textForm(
                      TextConstants.addNewAddTitle,
                      30,
                      color: AppColors.primaryColor,
                      weight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: sizedBoxesHeight,
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Card(
                            margin: EdgeInsets.only(bottom: 25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 15,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: _image != null
                                  ? Image.file(
                                      _image!,
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    )
                                  : noImg(width: 250, height: 250),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 250,
                          child: Center(
                            child: IconButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: AppColors.black.withOpacity(.1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    AppColors.primaryColor.withOpacity(.9),
                              ),
                              onPressed: _pickImage,
                              icon: Icon(
                                Icons.add_rounded,
                                size: 40,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizedBoxesHeight,
                    ),
                    TFForms(
                      controller: _nameController,
                      label: TextConstants.adName,
                      validator: Validators.validateNotEmpty,
                    ),
                    SizedBox(height: sizedBoxesHeight),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelText: '     ${TextConstants.categories}',
                          labelStyle: TextStyle(
                            fontSize: 22,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        child: DropdownButton<String>(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          dropdownColor: AppColors.darkGrey,
                          underline: Container(),
                          borderRadius: BorderRadius.circular(12),
                          value: _selectedCategory,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_double_arrow_down_rounded,
                            size: 30,
                            color: AppColors.primaryColor,
                          ),
                          items: _itemsCategories.entries
                              .map<DropdownMenuItem<String>>((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: textForm(entry.value, 18),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue ?? '';
                            });
                          },
                          hint: Text('Выберите категорию'),
                        ),
                      ),
                    ),
                    SizedBox(height: sizedBoxesHeight),
                    TFForms(
                      controller: _descriptionController,
                      label: TextConstants.description,
                      maxLines: 4,
                      validator: Validators.validateNotEmpty,
                    ),
                    SizedBox(height: sizedBoxesHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TFForms(
                            controller: _priceController,
                            label: TextConstants.price,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            validator: Validators.validateNotEmpty,
                            suffix: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Image.asset(
                                    'lib/assets/images/icons/currency_yellow.png',
                                    fit: BoxFit.contain,
                                    width: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: sizedBoxesWidth,
                                ),
                                textForm(
                                  '(сом)',
                                  20,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: sizedBoxesWidth),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                          child: DropdownButton(
                            padding: EdgeInsets.all(5),
                            dropdownColor: AppColors.darkGrey,
                            borderRadius: BorderRadius.circular(12),
                            underline: Container(),
                            icon: Icon(
                              Icons.keyboard_double_arrow_down_rounded,
                              size: 30,
                              color: AppColors.primaryColor,
                            ),
                            value: _selectedPriceType,
                            items: _itemsPriceType.map((item) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.centerLeft,
                                value: item,
                                child: SizedBox(
                                  child: textForm(
                                    item,
                                    20,
                                    color: AppColors.white,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedPriceType =
                                    newValue ?? _itemsPriceType[0];
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizedBoxesHeight),
                    TFForms(
                      controller: _locationController,
                      label: TextConstants.locationFieldLabel,
                      validator: Validators.validateNotEmpty,
                    ),
                    SizedBox(height: sizedBoxesHeight),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          delivery = !delivery;
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
                              value: delivery,
                              onChanged: (value) {
                                setState(() {
                                  value! ? delivery = true : delivery = false;
                                });
                              },
                            ),
                          ),
                          textForm(
                            TextConstants.deliveryText,
                            18,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: sizedBoxesHeight,
                    ),
                    ElevatedButton(
                      onPressed: _addComplete,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
          ),
        ),
      ),
    );
  }

  _addComplete() {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ref.read(errorDialogMessageProvider.notifier).state =
            'Жарнаманын суротуну кошууну унутпаныз';
ref.read(errorDialogProvider.notifier).state = true; 
        return;
      }
      ref.read(userServiceProvider.notifier).addAd(
            image: _image,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: int.parse(_priceController.text.trim()),
            priceType: _selectedPriceType,
            location: _locationController.text.trim(),
            delivery: delivery,
            categoryId: int.parse(_selectedCategory!),
          );
      Navigator.pop(context);
    }
  }
}
