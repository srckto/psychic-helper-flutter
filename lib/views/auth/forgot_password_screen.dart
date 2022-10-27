import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_card.dart';
import 'package:psychic_helper/components/custom_form_field.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/auth/forgot_password_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/functions.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              CustomText(
                "قم بادخال بريدك الالكتروني وسيتم ارسال رابط لتغيير كلمة السر لبريدك الالكتروني",
                textAlign: TextAlign.start,
                fontSize: 18,
              ),
              SizedBox(height: 30),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: CustomFormField(
                    controller: controller.emailController,
                    validator: emailValidator,
                    hintText: "البريد الالكتروني",
                  ),
                ),
              ),
              SizedBox(height: 30),
              GetBuilder<ForgotPasswordController>(builder: (_) {
                return CustomButton(
                  text: "ارسال",
                  onTap: () => controller.forgot(),
                  buttonColor: controller.isLoading ? AppColors.brown : AppColors.primaryColor,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
