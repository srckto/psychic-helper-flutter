import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:psychic_helper/helper/cache_storage.dart';
import 'package:psychic_helper/helper/constants.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/user_model.dart';
import 'package:psychic_helper/network/auth_service.dart';
import 'package:psychic_helper/network/firestore_service.dart';
import 'package:psychic_helper/views/layout/layout_screen.dart';

class RegisterController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController configPassword = TextEditingController();
  List<String> accountType = ["مستخدم", "معالج نفسي"];
  int indexOfAccountType = 0;

  bool isLoading = false;
  Future<void> createAccount() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading = true;
      update();
      UserCredential credential =
          await AuthService.instance.register(email: email.text, password: password.text);
      UserModel _model = UserModel(
        uId: credential.user!.uid,
        email: credential.user!.email,
        username: userName.text,
        name: name.text,
        dateOfRegister: DateFormat(FORMATOFDATETIME).format(DateTime.now()),
        image:
            "https://firebasestorage.googleapis.com/v0/b/e-commerce-num2.appspot.com/o/defult_user_icon.png?alt=media&token=723a59af-edef-4db6-bfdd-4638530813c9",
        isPerson: indexOfAccountType == 0,
        isAcceptedByAdmin: false,
      );

      await FirestoreService.instance.saveUser(_model);

      var convertDataToJson = jsonEncode(_model.toMap());

      await CacheStorage.save(CACHE_USER, convertDataToJson);

      MainUser.getOrUpdateUserFromCache();

      isLoading = false;
      update();

      // Get.find<LayoutController>().onInit();
      // Get.find<HomeController>().onInit();
      // Get.find<ExploreController>().onInit();
      // Get.find<ChatController>().onInit();
      // Get.find<ProfileController>().onInit();
      Get.offAll(() => LayoutScreen());
    } on FirebaseAuthException catch (error) {
      isLoading = false;
      update();

      Get.closeAllSnackbars();

      Get.snackbar(
        "Something is wrong!",
        error.message!,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      );
    } catch (error) {
      isLoading = false;
      update();

      Get.closeAllSnackbars();
      Get.snackbar(
        "Something is wrong!",
        "Please try again another time",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      );
    }
  }

  void onChangeAccountType(int newIndex) {
    indexOfAccountType = newIndex;
    update();
  }
}
