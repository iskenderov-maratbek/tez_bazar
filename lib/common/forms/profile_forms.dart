import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/forms/text_forms.dart';
import 'package:tez_bazar/providers/providers.dart';

class TFForms extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLength;

  const TFForms({
    super.key,
    this.maxLength,
    required this.controller,
    this.inputFormatters,
    this.hintText,
    this.keyboardType,
  });

  @override
  ConsumerState<TFForms> createState() => _TextFieldFormState();
}

class _TextFieldFormState extends ConsumerState<TFForms> {
  Color? fillColor = Colors.grey[300];
  Color? prefixColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      validator: (value) {},
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      maxLength: widget.maxLength,
      style: const TextStyle(
        fontSize: 20,
      ),
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: (value) {},
      decoration: InputDecoration(
        label: textForm('база', 15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        filled: true,
        fillColor: fillColor,
        isDense: true,
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
