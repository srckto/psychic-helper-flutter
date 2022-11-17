import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/components/empty_screen.dart';
import 'package:psychic_helper/controllers/explore/result_explore_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/handle_view_status.dart';
import 'package:psychic_helper/models/user_model.dart';
import 'package:psychic_helper/views/chat/chat_details_screen_logic02.dart';

class ResultExploreScreen extends StatelessWidget {
  ResultExploreScreen({Key? key}) : super(key: key);

  final controller = Get.put(ResultExploreController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText("اختر احد المعالجين"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          width: Get.width,
          child: GetBuilder<ResultExploreController>(
            builder: (controller) {
              return HandleViewStatus(
                statusRequest: controller.statusRequest,
                widget: _BuildExplore(controller: controller),
                reTryFunction: controller.onInit,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BuildExplore extends StatelessWidget {
  const _BuildExplore({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ResultExploreController controller;
  @override
  Widget build(BuildContext context) {
    if (controller.users.isEmpty)
      return EmptyScreen(
        message: "لا يوجد اي معالج متوفر",
      );
    return ListView.separated(
      itemCount: controller.users.length,
      separatorBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Divider(),
            SizedBox(height: 20),
          ],
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return _BuildUserItem(
          model: controller.users[index],
        );
      },
    );
  }
}

class _BuildUserItem extends StatelessWidget {
  const _BuildUserItem({
    Key? key,
    required this.model,
  }) : super(key: key);
  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ChatDetailsScreenLogic02(model: model)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: BuildImage(
              imageUrl: model.image!,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomText(
                model.name!,
                fontSize: 20,
                maxLines: 1,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
