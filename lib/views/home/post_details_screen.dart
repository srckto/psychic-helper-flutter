import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/home/post_details_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';

import 'package:psychic_helper/models/post_model.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  final PostModel model;

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  late PostDetailsController controller;
  @override
  void initState() {
    controller = Get.put(PostDetailsController(postModel: widget.model));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: CustomText(
              controller.postModel.title!,
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
                BuildImage(imageUrl: controller.postModel.image!),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        controller.postModel.title!,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 5),
                      controller.body == null
                          ? QuillEditor.basic(
                              controller: controller.quillController!,
                              readOnly: true, // true for view only mode
                            )
                          : CustomText(
                              controller.body ?? "",
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
