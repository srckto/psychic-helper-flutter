import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psychic_helper/helper/image_picker_helper.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/network/firestorage_service.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class ProfileController extends GetxController {
  File? image;
  bool isUploadingImage = false;

  Future<void> pickImage(ImageSource imageSource) async {
    try {
      String oldImageName = MainUser.model!.imageName ?? "image";
      image = await ImagePickerHelper.instance.pickImage(imageSource);
      isUploadingImage = true;
      update();
      if (image != null) await uploadImage();
      if (image != null) deleteImageFromFirebase(oldImageName);
      isUploadingImage = false;
      update();
    } catch (e) {
      isUploadingImage = false;
      update();
      print(e.toString());
    }
  }

  Future<void> deleteImageFromFirebase(String imageUrl) async {
    await FirestorageService.instance.deleteImage(imageUrl);
  }

  Future<void> uploadImage() async {
    try {
      if (image == null) throw "No selected image";

      Random random = new Random();
      int randomNumber = random.nextInt(1000);
      String fileName = randomNumber.toString() + image!.path.split("/").last;

      var taskSnapshot = await FirestorageService.instance.uploadUserImage(image!, fileName);
      String url = await taskSnapshot.ref.getDownloadURL();

      MainUser.model?.image = url;
      MainUser.model?.imageName = fileName;

      await FirestoreService.instance.updateUser(MainUser.model!);
      // MainUser.getUserFromFirestoreAndUpdateModel();
    } catch (e) {
      throw e;
    }
  }
}
