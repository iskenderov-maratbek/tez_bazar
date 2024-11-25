import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldForm extends StatefulWidget {
  final String? Function(String?) validator;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? prefixImg;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputType? keyboardType;

  const TextFieldForm({
    super.key,
    required this.validator,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixImg,
    this.inputFormatters,
    this.hintText,
    this.keyboardType,
    this.maxLength,
  });

  @override
  State<TextFieldForm> createState() => _TextFieldFormState();
}

class _TextFieldFormState extends State<TextFieldForm> {
  Color? fillColor = Colors.grey[300];
  Color? prefixColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (bool hasFocus) {
        if (hasFocus) {
          setState(() {
            fillColor = Colors.white;
            prefixColor = Colors.purple;
          });
          print('Focus YES: $hasFocus');
        } else {
          setState(() {
            prefixColor = Colors.black;
            fillColor = Colors.grey[300];
          });
          print('Focus NON: $hasFocus');
        }
      },
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        maxLength: widget.maxLength,
        // textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          fontSize: 20,
          // height: 1,
          // height: 1.5170817,
          // height: 1.50825,
        ),
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          filled: true,
          fillColor: fillColor,
          isDense: false,
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
                        color: prefixColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 18, top: 15, bottom: 15),
                      child: Icon(
                        widget.suffixIcon,
                        color: prefixColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                )
              : null,
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
      ),
    );
  }
}
