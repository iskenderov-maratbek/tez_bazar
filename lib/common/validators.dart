import 'package:tez_bazar/texts/text_constants.dart';

class Validators {
  static String? phoneValidator(value) {
    if (value == null || value.isEmpty) {
      return TextConstants.invalidNumberEmpty;
    } else if (!RegExp(r'^[1-9]\d{8}$').hasMatch(value)) {
      return TextConstants.invalidNumberIncorrect;
    }
    return null;
  }

  static String? validateFullName(value) {
    if (value == null || value.isEmpty) {
      return TextConstants.invalidNameEmpty;
    } else if (!RegExp(r'^[a-zA-Zа-яА-Я]+(\s+[a-zA-Zа-яА-Я]+){0,4}$')
        .hasMatch(value)) {
      return TextConstants.invalidNameIncorrect;
    }
    return null;
  }

  static String? validateNotEmpty(value) {
    if (value == null || value.isEmpty) {
      return TextConstants.emptyErrorText;
    }
    return null;
  }
}
