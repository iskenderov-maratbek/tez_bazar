
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/providers/providers.dart';
import 'package:tez_bazar/texts/text_constants.dart';

class SearchForm extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final FocusNode focusNode;

  const SearchForm({
    super.key,
    required this.controller,
    required this.focusNode,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  ConsumerState<SearchForm> createState() => _TextFieldFormState();
}

class _TextFieldFormState extends ConsumerState<SearchForm> {
  Color? fillColor = Colors.grey[300];
  Color? prefixColor = Colors.black;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        focusNode: widget.focusNode,
        textAlignVertical: TextAlignVertical.center,
        validator: (value) {
          {
            if (value == null || value.isEmpty) {
              return TextConstants.notEmpty;
            }
            if (RegExp(r'^\d+$').hasMatch(value)) {
              return TextConstants.notOnlyDigits;
            }
            if (value.length < 3) {
              return TextConstants.minLegth;
            }
            return null;
          }
        },
        keyboardType: widget.keyboardType,
        textInputAction: TextInputAction.search,
        controller: widget.controller,
        maxLength: 320,
        style: const TextStyle(
          fontSize: 20,
        ),
        inputFormatters: widget.inputFormatters,
        // onChanged: _onTextChanged,
        onFieldSubmitted: (value) {
          _search();
        },
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          filled: true,
          suffixIconConstraints: const BoxConstraints(
            minHeight: 10,
            minWidth: 10,
          ),
          suffixIcon: IconButton(
              padding:
                  const EdgeInsets.only(right: 15, top: 0, bottom: 0, left: 10),
              onPressed: _search,
              icon: Icon(
                Icons.search_rounded,
                size: 30,
                color: AppColors.black,
              )),
          fillColor: fillColor,
          isDense: true,
          hintText: '${TextConstants.search}...',
          errorStyle: const TextStyle(color: Colors.red, fontSize: 18),
          errorMaxLines: 2,
          counterText: '',
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            // height: 1.6352,
          ),
        ),
      ),
    );
  }

  _search() {
    if (_formKey.currentState!.validate()) {
      ref.read(appBarTitleProvider.notifier).state = widget.controller.text;
      ref.read(gridViewStateProvider.notifier).state = GridPage.search;
      ref.read(searchProvider.notifier).clear();
      ref
          .read(searchProvider.notifier)
          .searchProducts(productName: widget.controller.text);
    }
    FocusScope.of(context).unfocus();
  }
}
