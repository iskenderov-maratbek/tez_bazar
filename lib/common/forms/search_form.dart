import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/providers/providers.dart';

class SearchForm extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? prefixImg;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const SearchForm({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixImg,
    this.inputFormatters,
    this.hintText,
    this.keyboardType,
  });

  @override
  ConsumerState<SearchForm> createState() => _TextFieldFormState();
}

class _TextFieldFormState extends ConsumerState<SearchForm> {
  Color? fillColor = Colors.grey[300];
  Color? prefixColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {},
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      maxLength: 320,
      // textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(
        fontSize: 20,
        // height: 1,
        // height: 1.5170817,
        // height: 1.50825,
      ),
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: (value) {
        ref.read(gridViewStateProvider.notifier).state = GridPage.search;
        ref
            .read(searchProvider.notifier)
            .searchProducts(productName: widget.controller.text);
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        filled: true,
        fillColor: fillColor,
        isDense: true,
        prefixIcon: widget.prefixIcon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18, right: 5, top: 15, bottom: 15),
                    child: Icon(
                      widget.prefixIcon,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              )
            : null,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            color: AppColors.backgroundColor,
            icon: Icon(
              Icons.search_rounded,
              color: AppColors.white,
              size: 30,
            ),
            onPressed: () {
              ref.read(gridViewStateProvider.notifier).state = GridPage.search;
              ref
                  .read(searchProvider.notifier)
                  .searchProducts(productName: widget.controller.text);
            },
          ),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        errorMaxLines: 2,
        counterText: '',
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          // height: 1.6352,
        ),
      ),
    );
  }
}
