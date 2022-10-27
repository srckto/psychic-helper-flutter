import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/controllers/auth/register_controller.dart';
import 'package:psychic_helper/helper/cache_storage.dart';
import 'package:psychic_helper/helper/constants.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/network/auth_service.dart';
import 'package:psychic_helper/network/firestore_service.dart';
import 'package:psychic_helper/views/layout/layout_screen.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading = true;
      update();
      UserCredential userCredential =
          await AuthService.instance.login(email: email.text, password: password.text);

      var userData = await FirestoreService.instance.getUser(userCredential.user!.uid);

      if (userData.data() == null) throw "Not user found, please try again in another time.";

      var convertDataToJson = jsonEncode(userData.data());

      await CacheStorage.save(CACHE_USER, convertDataToJson);

      MainUser.getOrUpdateUserFromCache();
      isLoading = false;
      update();

      Get.offAll(() => LayoutScreen());
      Get.delete<LoginController>(force: true);
      Get.delete<RegisterController>(force: true);
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
      debugPrint(error.toString());
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
}
