import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_card.dart';
import 'package:psychic_helper/components/custom_form_field.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/profile/add_post_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/main_user.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({Key? key}) : super(key: key);

  final controller = Get.put(AddPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText("اضافة منشور"),
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
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              if (!MainUser.model!.isAcceptedByAdmin!)
                Column(
                  children: [
                    Container(
                      width: Get.width * 0.7,
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: CustomText(
                          "لن تتمكن من النشر حتى يوافق الادمن على حسابك",
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
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
                      Container(
                        height: 250,
                        child: QuillEditor.basic(
                          controller: controller.quillController,
                          readOnly: false,
                        ),
                      ),
                      QuillToolbar.basic(
                        controller: controller.quillController,
                        showFontSize: false,
                        showFontFamily: false,
                        showSearchButton: false,
                        showBackgroundColorButton: false,
                        showDividers: false,
                        // showJustifyAlignment: false,
                        showStrikeThrough: false,
                      ),
                      // CustomFormField(
                      //   labelText: "الوصف",
                      //   controller: controller.description,
                      //   prefixIcon: Icon(Icons.description_outlined),
                      //   maxLines: 5,
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GetBuilder<AddPostController>(
                builder: (controller) {
                  return CustomButton(
                    onTap: controller.isLoading
                        ? null
                        : () async {
                            controller.addPost();
                          },
                    text: "نشر",
                    buttonColor: controller.isLoading ? Colors.brown : AppColors.primaryColor,
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
