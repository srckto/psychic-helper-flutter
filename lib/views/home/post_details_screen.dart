import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/helper/app_color.dart';

import 'package:psychic_helper/models/post_model.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  final PostModel model;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: CustomText(
              model.title!,
              maxLines: 1,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.close_rounded,
              color: AppColor.primaryColor,
            ),
          ),
          actions: [
            SizedBox(width: 25),
          ],
        ),
        body: Container(
          width: Get.width,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildImage(imageUrl: model.image!),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      CustomText(
                        model.title!,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 5),
                      CustomText(
                        model.description!,
                        fontSize: 16,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
