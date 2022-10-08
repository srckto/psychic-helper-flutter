import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/controllers/home/home_controller.dart';
import 'package:psychic_helper/controllers/profile/manage_posts_controller.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class EditPostController extends GetxController {
  final PostModel postModel;

  EditPostController({required this.postModel});

  late TextEditingController title;
  late TextEditingController description;

  late bool isLoading;

  @override
  void onClose() {
    title.dispose();
    description.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    isLoading = false;
    title = TextEditingController(text: postModel.title);
    description = TextEditingController(text: postModel.description);
    super.onInit();
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
        id: postModel.id,
        image: postModel.image,
        postedBy: postModel.postedBy,
        dataTimeOfPosts: postModel.dataTimeOfPosts,
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
