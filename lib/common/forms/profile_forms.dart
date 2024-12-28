import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';

class TFForms extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final String? label;
  final String? helperText;
  final Widget? suffix;
  final FormFieldValidator? validator;

  const TFForms({
    super.key,
    this.maxLength,
    this.suffix,
    this.maxLines,
    required this.controller,
    this.inputFormatters,
    this.hintText,
    this.keyboardType,
    this.label,
    this.helperText,
    this.validator,
  });

  @override
  ConsumerState<TFForms> createState() => _TextFieldFormState();
}

class _TextFieldFormState extends ConsumerState<TFForms> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (bool hasFocus) {
        if (hasFocus) {}
      },
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines ?? 1,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
        ),
        inputFormatters: widget.inputFormatters,
        onFieldSubmitted: (value) {},
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: widget.label != null
              ? textForm(
                  widget.label!,
                  22,
                  color: AppColors.primaryColor,
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          filled: true,
          fillColor: AppColors.white.withOpacity(.1),
          isDense: true,
          errorStyle: const TextStyle(color: Colors.red),
          errorMaxLines: 2,
          counterText: '',
          suffix: widget.suffix,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(.9),
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
