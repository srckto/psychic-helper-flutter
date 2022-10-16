import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/controllers/chat/chat_controller.dart';
import 'package:psychic_helper/controllers/explore/explore_controller.dart';
import 'package:psychic_helper/controllers/home/home_controller.dart';
import 'package:psychic_helper/controllers/profile/profile_controller.dart';

import 'package:psychic_helper/helper/cache_storage.dart';
import 'package:psychic_helper/helper/constants.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/views/auth/login_screen.dart';
import 'package:psychic_helper/views/chat/chat_screen.dart';
import 'package:psychic_helper/views/explore/explore_screen.dart';
import 'package:psychic_helper/views/home/home_screen.dart';
import 'package:psychic_helper/views/profile/profile_screen.dart';

class _LayoutItem {
  String name;
  Widget screen;
  Widget icon;

  _LayoutItem({
    required this.name,
    required this.screen,
    required this.icon,
  });
}

class LayoutController extends GetxController {
  late List<_LayoutItem> items;
  late int index;

  @override
  void onInit() async {
    super.onInit();
    index = 0;
    items = [
      _LayoutItem(name: "الصفحة الرئيسية", screen: HomeScreen(), icon: Icon(Icons.home_outlined)),
      _LayoutItem(name: "استكشاف", screen: ExploreScreen(), icon: Icon(Icons.explore_outlined)),
      _LayoutItem(name: "المحادثات", screen: ChatScreen(), icon: Icon(Icons.chat_outlined)),
      _LayoutItem(
        name: "الملف الشخصي",
        screen: ProfileScreen(),
        icon: Icon(Icons.person_outline_outlined),
      ),
    ];
    checkUser();
    MainUser.userStream;
  }

  void onChange(int newIndex) {
    index = newIndex;
    update();
  }

  bool isItemSelected(_LayoutItem element) {
    return items.indexOf(element) == index;
  }

  Future<void> logout() async {
    await MainUser.userStream?.cancel();

    await FirebaseAuth.instance.signOut();
    await CacheStorage.remove(CACHE_USER);

    Get.find<ChatController>().chatSteam?.cancel();

    Get.delete<ChatController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<ExploreController>(force: true);
    Get.delete<ProfileController>(force: true);
    Get.delete<LayoutController>(force: true);

    Get.offAll(() => LoginScreen());
  }

  void checkUser() async {
    if (MainUser.model == null) {
      CacheStorage.remove(CACHE_USER);
      logout();
    }
  }
}
