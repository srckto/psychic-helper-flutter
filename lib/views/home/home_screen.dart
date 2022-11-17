import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:psychic_helper/components/build_post_item.dart';
import 'package:psychic_helper/controllers/home/home_controller.dart';
import 'package:psychic_helper/helper/handle_view_status.dart';
import 'package:psychic_helper/views/home/post_details_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return HandleViewStatus(
          statusRequest: controller.statusRequest,
          widget: _BuildHome(controller: controller),
          reTryFunction: controller.onInit,
        );
      },
    );
  }
}

class _BuildHome extends StatelessWidget {
  const _BuildHome({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListView.separated(
        // clipBehavior: Clip.none,
        physics: BouncingScrollPhysics(),
        itemCount: controller.posts.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 20);
        },
        itemBuilder: (BuildContext context, int index) {
          return BuildPostItem(
            model: controller.posts[index],
            onTap: () => Get.to(() => PostDetailsScreen(model: controller.posts[index])),
          );
        },
      ),
    );
  }
}
