import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/cutom_toast.dart';
import 'package:psychic_helper/controllers/home/home_controller.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class AddPostController extends GetxController {
  late TextEditingController title;
  late bool isLoading;
  late QuillController quillController;

  @override
  void onInit() {
    super.onInit();
    title = TextEditingController();
    quillController = QuillController.basic();
    isLoading = false;
  }

  Future<void> addPost() async {
    try {
      if (!MainUser.model!.isAcceptedByAdmin!) {
        CustomToast.show("غير مصرح لك بالنشر", Colors.red);
        return;
      }

      isLoading = true;
      update();

      String jsonDescription = jsonEncode(quillController.document.toDelta().toJson());
      String stringDescription = quillController.document.toPlainText();
      PostModel postModel = PostModel(
        image:
            "https://modo3.com/thumbs/fit630x300/9043/1415885031/%D9%85%D8%A7_%D9%87%D9%8A_%D8%A7%D9%84%D8%A7%D8%B6%D8%B7%D8%B1%D8%A7%D8%A8%D8%A7%D8%AA_%D8%A7%D9%84%D9%86%D9%81%D8%B3%D9%8A%D8%A9.jpg",
        postedBy: MainUser.model!.uId,
        jsonDescription: jsonDescription,
        stringDescription: stringDescription,
        title: title.text,
        dataTimeOfPosts: DateTime.now().toIso8601String(),
      );

      var documentReference = await FirestoreService.instance.addPost(postModel);
      await documentReference.update({"id": documentReference.id});
      Get.find<HomeController>().onInit();
      isLoading = false;
      update();
      Get.back();
    } catch (e) {
      isLoading = false;
      update();
      throw e;
    }
  }
}
