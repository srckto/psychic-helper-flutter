import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/custom_alert_dialog.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_card.dart';
import 'package:psychic_helper/components/custom_form_field.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/profile/edit_post_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/models/post_model.dart';

class EditPostScreen extends StatelessWidget {
  const EditPostScreen({
    required this.model,
    Key? key,
  }) : super(key: key);
  final PostModel model;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditPostController());
    controller.init(model);

    return Scaffold(
      appBar: AppBar(
        title: CustomText("تعديل المنشور"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: "هل تريد حذف المنشور؟",
                    subTitle: null,
                    textOfAccept: "حذف",
                    textOfCancel: 'الغاء',
                    onAccept: () async {
                      await controller.deletePost(model.id!);
                      Get.back();
                    },
                    onCancel: () {
                      Get.back();
                    },
                  );
                },
              );
            },
            icon: Icon(
              Icons.delete_forever_rounded,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        // alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      CustomFormField(
                        labelText: "العنوان",
                        controller: controller.title,
                        prefixIcon: Icon(Icons.title_outlined),
                      ),
                      Divider(),
                      CustomFormField(
                        labelText: "الوصف",
                        controller: controller.description,
                        prefixIcon: Icon(Icons.description_outlined),
                        maxLines: 15,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GetBuilder<EditPostController>(
                builder: (controller) {
                  return CustomButton(
                    onTap: controller.isLoading
                        ? null
                        : () async {
                            controller.saveUpdates();
                          },
                    text: "حفظ التعديلات",
                    buttonColor: controller.isLoading ? Colors.brown : AppColor.primaryColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
