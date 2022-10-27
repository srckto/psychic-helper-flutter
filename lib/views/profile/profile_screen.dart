import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_card.dart';
import 'package:psychic_helper/components/custom_form_field.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/profile/profile_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/functions.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/views/profile/screens/add_post_screen.dart';
import 'package:psychic_helper/views/profile/screens/manage_posts_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Container(
            width: Get.width,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: BuildImage(
                        imageUrl: MainUser.model!.image!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.isUploadingImage
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("اختر من اين تجلب الصورة"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  content: Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          text: "الكامرة",
                                          onTap: controller.isUploadingImage
                                              ? null
                                              : () {
                                                  controller.pickImage(ImageSource.camera);
                                                },
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: CustomButton(
                                          text: "معرض الصور",
                                          onTap: controller.isUploadingImage
                                              ? null
                                              : () {
                                                  controller.pickImage(ImageSource.gallery);
                                                },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (controller.isUploadingImage) SizedBox(height: 10),
                if (controller.isUploadingImage)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LinearProgressIndicator(),
                  ),
                SizedBox(height: 10),
                CustomText(
                  MainUser.model!.name!,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 20),
                if (!MainUser.model!.isPerson!)
                  CustomCard(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _BuildItem(
                          title: "اضافة منشور",
                          icon: Icons.add,
                          onTap: () => Get.to(() => AddPostScreen()),
                        ),
                        Divider(),
                        _BuildItem(
                          title: "ادارة المنشورات",
                          icon: Icons.edit_note_outlined,
                          onTap: () => Get.to(() => ManagePostsScreen()),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20),
                CustomCard(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _BuildItem(
                        title: "حذف الحساب",
                        icon: Icons.delete_rounded,
                        onTap: () {
                          debugPrint("Delete account button");
                          var alert = AlertDialog(
                            title: CustomText(
                              "ادخل كلمة السر",
                              textAlign: TextAlign.center,
                              color: Colors.black,
                            ),
                            content: Form(
                              key: controller.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomFormField(
                                    hintText: "كلمة السر",
                                    controller: controller.passwordController,
                                    validator: passwordValidator,
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 20),
                                  CustomButton(
                                    text: "حذف الحساب",
                                    onTap: () {
                                      controller.deleteAcount();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          );
                          showDialog(context: context, builder: (_) => alert);
                          // controller.deleteAcount(password);
                        },
                        iconColor: AppColors.red,
                        textColor: Colors.red,
                        isSuffixIconAvailabe: false,
                      ),
                      // Divider(),
                      // _BuildItem(
                      //   title: "ادارة المنشورات",
                      //   icon: Icons.edit_note_outlined,
                      //   onTap: () => Get.to(() => ManagePostsScreen()),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BuildItem extends StatelessWidget {
  const _BuildItem({
    Key? key,
    required this.title,
    this.icon,
    this.onTap,
    this.iconColor,
    this.textColor,
    this.isSuffixIconAvailabe = true,
  }) : super(key: key);

  final String title;
  final IconData? icon;
  final void Function()? onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool isSuffixIconAvailabe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomText(
                  title,
                  textAlign: TextAlign.start,
                  fontSize: 15,
                  color: textColor ?? AppColors.grayColor,
                ),
              ),
            ),
            if (isSuffixIconAvailabe) Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
