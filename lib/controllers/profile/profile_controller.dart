import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psychic_helper/components/cutom_toast.dart';
import 'package:psychic_helper/controllers/layout/layout_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/image_picker_helper.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/user_model.dart';
import 'package:psychic_helper/network/auth_service.dart';
import 'package:psychic_helper/network/chat_service.dart';
import 'package:psychic_helper/network/firestorage_service.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class ProfileController extends GetxController {
  File? image;
  bool isUploadingImage = false;
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteAcount() async {
    if (!formKey.currentState!.validate()) return;
    try {
      UserModel tempUserModel = MainUser.model!;
      await AuthService.instance.deleteAccount(passwordController.text);
      await ChatService.instance.deleteAllChats(tempUserModel.myConnection ?? []);
      await FirestoreService.instance.deleteUser(tempUserModel);
      if (!tempUserModel.isPerson!) {
        await _deletePostsOfUser(tempUserModel);
      }
      FirestorageService.instance.deleteImage(tempUserModel.imageName ?? "");
      Get.find<LayoutController>().logout();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      CustomToast.show(e.message ?? "يوجد خطأ, يرجى المحاولة بوقت اخر", AppColors.red);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      CustomToast.show(e.message ?? "يوجد خطأ, يرجى المحاولة بوقت اخر", AppColors.red);
    } catch (e) {
      debugPrint(e.toString());
      CustomToast.show("يوجد خطأ, يرجى المحاولة بوقت اخر", AppColors.red);
    }
  }

  //! PRIVATE FUNCTIONS
  Future<void> _deletePostsOfUser(UserModel model) async {
    var queryOfPosts = await FirestoreService.instance.getPosts();
    queryOfPosts.docs.forEach(
      (element) async {
        if (element.data()["postedBy"] == (model.uId ?? "x")) {
          await FirestoreService.instance.deletePost(element.data()["id"]);
        }
      },
    );
  }
}
