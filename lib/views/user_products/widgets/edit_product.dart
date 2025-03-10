import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/profile_forms.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/common/misc.dart';
import 'package:tez_bazar/common/validators.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/products_services/user_service.dart';
import 'package:tez_bazar/constants/text_constants.dart';

class AddEditView extends ConsumerStatefulWidget {
  final int id;
  final String name;
  final int price;
  final String priceType;
  final String? photo;
  final String description;
  final bool delivery;
  final String location;
  final int categoryId;

  const AddEditView({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.priceType,
    required this.categoryId,
    this.photo,
    required this.description,
    required this.delivery,
    required this.location,
  });

  @override
  ConsumerState<AddEditView> createState() => _AddAdsState();
}

class _AddAdsState extends ConsumerState<AddEditView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final double sizedBoxesHeight = 30;
  final double sizedBoxesWidth = 10;
  late String? _selectedPriceType;
  File? _image;
  late String? _selectedCategory;
  late final Map<String, dynamic> _itemsCategories;
  late bool delivery;
  @override
  void initState() {
    _selectedPriceType = widget.priceType;
    _itemsCategories = ref.read(listOfCategoriesProvider);
    _nameController.text = widget.name;
    _descriptionController.text = widget.description;
    _locationController.text = widget.location;
    _priceController.text = widget.price.toString();
    _selectedCategory = widget.categoryId.toString();
    delivery = widget.delivery;
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
    logView(runtimeType);
    final double currencyfontSize = 16;
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
                top: 80,
                left: 10,
                right: 10,
                bottom: 50,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    textForm(
                      TextConstants.editAddTitle,
                      30,
                      color: AppColors.primaryColor,
                      weight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: sizedBoxesHeight,
                    ),
                    Card(
                      margin: EdgeInsets.only(bottom: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: AppColors.transparent,
                      elevation: 15,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: widget.photo != null
                            ? Image.network(widget.photo!)
                            : _image != null
                                ? Image.file(
                                    _image!,
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  )
                                : noImg(width: 250, height: 250),
                      ),
                    ),
                    Center(
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
                          menuWidth: 350,
                          menuMaxHeight: 500,
                          dropdownColor: AppColors.backgroundColor,
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: textForm(entry.value, 22),
                              ),
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
                      //
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
                              LengthLimitingTextInputFormatter(9),
                            ],
                            keyboardType: TextInputType.number,
                            validator: Validators.validateNotEmpty,
                            suffix: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                setCurrency(currencyfontSize),
                                textForm(
                                  '(сом)',
                                  currencyfontSize,
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
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton(
                            padding: EdgeInsets.all(4),
                            dropdownColor: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            underline: Container(),
                            icon: Icon(
                              Icons.keyboard_double_arrow_down_rounded,
                              size: 30,
                              color: AppColors.primaryColor,
                            ),
                            value: _selectedPriceType,
                            items: TextConstants.itemsPriceType.map((item) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.centerLeft,
                                value: item,
                                child: SizedBox(
                                  width: 60,
                                  child: textForm(
                                    item,
                                    20,
                                    color: AppColors.white,
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedPriceType =
                                    newValue ?? TextConstants.itemsPriceType[0];
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
                      onPressed: _editComplete,
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

  _editComplete() async {
    if (_formKey.currentState!.validate()) {
      ref.read(userServiceProvider.notifier).editProduct(
            id: widget.id,
            image: _image,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: int.parse(_priceController.text.trim()),
            priceType: _selectedPriceType ?? TextConstants.priceTypePieces,
            location: _locationController.text.trim(),
            delivery: delivery,
            categoryId: int.parse(_selectedCategory!),
          );
    }
    Navigator.pop(context);
  }
}
