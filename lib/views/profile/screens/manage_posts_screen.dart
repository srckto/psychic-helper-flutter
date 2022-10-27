import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/build_post_item.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/components/empty_screen.dart';
import 'package:psychic_helper/controllers/profile/manage_posts_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/views/profile/screens/edit_post_screen.dart';

class ManagePostsScreen extends StatelessWidget {
  ManagePostsScreen({Key? key}) : super(key: key);

  final controller = Get.put(ManagePostsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText("ادارة المنشورات"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: GetBuilder<ManagePostsController>(
        builder: (controller) {
          if (controller.isLoading) return Center(child: CircularProgressIndicator());
          if (controller.posts.isEmpty) return EmptyScreen(message: "ليس لديك اي منشورات");
          return Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: controller.posts.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 20);
              },
              itemBuilder: (BuildContext context, int index) {
                return BuildPostItem(
                  model: controller.posts[index],
                  onTap: () {
                    Get.to(() => EditPostScreen(model: controller.posts[index]));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
