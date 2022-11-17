import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/helper/status_request.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class HomeController extends GetxController {
  late List<PostModel> posts;
  late StatusRequest statusRequest;

  @override
  void onInit() async {
    super.onInit();
    statusRequest = StatusRequest.none;
    posts = [];
    getPosts();
  }

  Future<void> getPosts() async {
    try {
      statusRequest = StatusRequest.loading;
      posts = [];
      update();
      var querySnapshot = await FirestoreService.instance.getPosts();
      querySnapshot.docs.forEach((element) {
        posts.add(PostModel.fromMap(element.data()));
      });
      statusRequest = StatusRequest.success;
      update();
    } catch (e) {
      statusRequest = StatusRequest.failure;
      update();
      debugPrint("Error in getPosts function");
    }
  }
}
