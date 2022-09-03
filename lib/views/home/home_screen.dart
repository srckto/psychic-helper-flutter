import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_card.dart';

import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/home/home_controller.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/views/home/post_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(HomeController());
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
              return _BuildPostItem(model: controller.posts[index]);
            },
          ),
        );
      },
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
      onTap: () => Get.to(() => PostDetailsScreen(model: model)),
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
