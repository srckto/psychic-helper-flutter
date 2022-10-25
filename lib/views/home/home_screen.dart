import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/build_post_item.dart';
import 'package:psychic_helper/components/custom_card.dart';

import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/home/home_controller.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/views/home/post_details_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        if (controller.isLoading) return Center(child: CircularProgressIndicator());
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
      },
    );
  }
}
