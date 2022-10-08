import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_card.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/components/empty_screen.dart';
import 'package:psychic_helper/controllers/profile/manage_posts_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/models/post_model.dart';
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
            color: AppColor.primaryColor,
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
                return _BuildPostItem(model: controller.posts[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _BuildPostItem extends StatelessWidget {
  const _BuildPostItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  final PostModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => EditPostScreen(model: model));
      },
      child: CustomCard(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BuildImage(
              imageUrl: model.image!,
              height: 190,
              fit: BoxFit.cover,
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  CustomText(
                    model.title!,
                    maxLines: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5),
                  CustomText(
                    model.description!,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
