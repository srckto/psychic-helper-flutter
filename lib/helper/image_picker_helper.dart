import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  ImagePickerHelper._();
  static final instance = ImagePickerHelper._();

  Future<File?> pickImage(ImageSource source) async {
    File? image;
    var file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      image = File(file.path);
    }
    return image;
  }
}
