import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tez_bazar/common/logging.dart';

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();
  bool _isImagePickerActive = false;
  Future<File?> pickImage() async {
    if (_isImagePickerActive) {
      return null;
    }
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _isImagePickerActive = true;
        return File(pickedFile.path);
      }
    } catch (e) {
      logError(e);
    } finally {
      _isImagePickerActive = false;
    }
    return null;
  }
}
