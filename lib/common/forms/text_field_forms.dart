import 'package:flutter/material.dart';
import 'package:tez_bazar/common/widgets/text_field_form.dart';

textFieldSearch(TextEditingController controller) => TextFieldForm(
      maxLength: 320,
      suffixIcon: Icons.search_rounded,
      hintText: 'Эмнени тапкыныз келип жатат?',
      keyboardType: TextInputType.text,
      // validator: Validators.email,
      validator: (value) {
        return null;
      },
      controller: controller,
    );
