import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/cache_storage.dart';
import 'package:psychic_helper/helper/constants.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/views/auth/login_screen.dart';
import 'package:psychic_helper/views/layout/layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  MainUser.getOrUpdateUserFromCache();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _getFirstScreen() {
    var isUserAvailable = CacheStorage.get(CACHE_USER);

    if (isUserAvailable == null) return LoginScreen();
    return LayoutScreen();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Psychic Helper",
      theme: ThemeData(
        fontFamily: "Tajawal",
        primarySwatch: AppColor.primaryColor,
        canvasColor: AppColor.canvasColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      locale: Locale("ar"),
      home: _getFirstScreen(),
      // initialBinding: Binding(),
    );
  }
}
