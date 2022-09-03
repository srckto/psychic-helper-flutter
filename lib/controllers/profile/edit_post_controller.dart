import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/controllers/home/home_controller.dart';
import 'package:psychic_helper/controllers/profile/manage_posts_controller.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class EditPostController extends GetxController {
  late PostModel model;

  late TextEditingController title;
  late TextEditingController description;

  late bool isLoading;

  void init(PostModel currentModel) {
    isLoading = false;
    model = currentModel;
    title = TextEditingController(text: model.title);
    description = TextEditingController(text: model.description);
    print("========================== post");
    print(model.title);
    print(model.description);
    print("========================== post");
  }

  Future<void> deletePost(String id) async {
    try {
      await FirestoreService.instance.deletePost(id);
      Get.find<ManagePostsController>().onInit();
      Get.find<HomeController>().onInit();
      Get.back();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveUpdates() async {
    try {
      isLoading = true;
      update();

      PostModel newModel = PostModel(
        id: model.id,
        image: model.image,
        postedBy: model.postedBy,
        dataTimeOfPosts: model.dataTimeOfPosts,
        title: title.text,
        description: description.text,
      );
      print(newModel);
      await FirestoreService.instance.updatePost(newModel);
      isLoading = false;
      update();

      Get.back();
      Get.find<HomeController>().onInit();
    } catch (e) {
      isLoading = false;
      update();
      print(e.toString());
      Get.closeCurrentSnackbar();
      Get.snackbar(
        "خطأ",
        "حدث خطأ اثناء التعديل يرجى المحاولة لاحقاً",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(10),
      );
    }
  }
}
