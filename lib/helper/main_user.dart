import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/helper/constants.dart';
import 'package:psychic_helper/models/user_model.dart';

import 'cache_storage.dart';

class MainUser {
  MainUser._();

  static UserModel? model;
  static final _auth = FirebaseAuth.instance;

  static void getOrUpdateUserFromCache() async {
    var value = CacheStorage.get(CACHE_USER);
    if (value == null) return;
    var convertDataToMap = jsonDecode(value);
    model = UserModel.fromMap(convertDataToMap);
  }

  static StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? get userStream =>
      _listingToUser();

  static StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _listingToUser() {
    // userStream?.cancel();
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser?.uid)
        .snapshots()
        .listen((event) async {
      if (_auth.currentUser == null) return;
      if (_auth.currentUser!.uid == event.data()?["uId"]) {
        model = UserModel.fromMap(event.data()!);
        await CacheStorage.save(CACHE_USER, jsonEncode(event.data()));
      }
      // Get.find<ChatController>().update();
      // Get.find<ProfileController>().update();

      // bool isRegisteredChatDetailsController = Get.isRegistered<ChatDetailsController>();
      // if (isRegisteredChatDetailsController) {
      //   Get.find<ChatDetailsController>().update();
      // }
      Get.forceAppUpdate();
    });
  }
}
