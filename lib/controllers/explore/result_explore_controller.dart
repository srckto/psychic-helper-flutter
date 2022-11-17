import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/helper/status_request.dart';
import 'package:psychic_helper/models/user_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class ResultExploreController extends GetxController {
  late List<UserModel> users;
  late StatusRequest statusRequest;

  @override
  void onInit() async {
    super.onInit();
    users = [];
    statusRequest = StatusRequest.none;
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      statusRequest = StatusRequest.loading;
      update();
      var querySnapshot = await FirestoreService.instance.getUsers();
      querySnapshot.docs.forEach((element) {
        if (element.data()["isPerson"] == false && element.data()["uId"] != MainUser.model!.uId) {
          users.add(UserModel.fromMap(element.data()));
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
