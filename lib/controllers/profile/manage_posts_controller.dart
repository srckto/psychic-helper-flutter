import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/helper/status_request.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class ManagePostsController extends GetxController {
  late StatusRequest statusRequest;
  late List<PostModel> posts;
  @override
  void onInit() async {
    super.onInit();
    statusRequest = StatusRequest.none;
    posts = [];
    getPostsOfUser();
  }

  Future<void> getPostsOfUser() async {
    try {
      statusRequest = StatusRequest.loading;
      update();
      posts = [];
      var querySnapshot = await FirestoreService.instance.getPosts();
      querySnapshot.docs.forEach((element) {
        String? postedBy = element.data()["postedBy"];
        if (postedBy != null && postedBy == MainUser.model!.uId) {
          posts.add(PostModel.fromMap(element.data()));
        }
      });
      statusRequest = StatusRequest.success;
      update();
    } catch (e) {
      statusRequest = StatusRequest.failure;
      update();
      debugPrint(e.toString());
    }
  }
}
