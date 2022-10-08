import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_card.dart';
import 'package:psychic_helper/components/custom_form_field.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/auth/register_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/functions.dart';
import 'package:psychic_helper/views/auth/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  
  final controller = Get.put(RegisterController());
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: Get.height,
          // padding: EdgeInsets.symmetric(vertical: 60),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  CustomText(
                    "انشاء حساب",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20),
                  CustomCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        CustomFormField(
                          labelText: "الاسم الكامل",
                          controller: controller.name,
                          prefixIcon: Icon(Icons.person_rounded),
                          validator: nameValidator,
                        ),
                        Divider(),
                        CustomFormField(
                          labelText: "اسم المستخدم",
                          controller: controller.userName,
                          prefixIcon: Icon(Icons.person_rounded),
                          validator: usernameValidator,
                        ),
                        Divider(),
                        CustomFormField(
                          labelText: "البريد الالكتروني",
                          controller: controller.email,
                          prefixIcon: Icon(Icons.email_rounded),
                          validator: emailValidator,
                        ),
                        Divider(),
                        CustomFormField(
                          labelText: "كلمة السر",
                          controller: controller.password,
                          prefixIcon: Icon(Icons.lock_rounded),
                          obscureText: true,
                          validator: passwordValidator,
                        ),
                        Divider(),
                        CustomFormField(
                          labelText: "تأكيد كلمة السر",
                          controller: controller.configPassword,
                          prefixIcon: Icon(Icons.lock_rounded),
                          obscureText: true,
                          validator: (String? value) {
                            return configPasswordValidator(value, controller.password.text);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomText("اختر نوع الحساب", fontSize: 20),
                  SizedBox(height: 20),
                  GetBuilder<RegisterController>(
                    builder: (controller) {
                      return CustomCard(
                        height: 50,
                        color: AppColor.fontGrayColor,
                        child: Row(
                          children: List.generate(
                            controller.accountType.length,
                            (index) => Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.onChangeAccountType(index);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: controller.indexOfAccountType == index
                                        ? AppColor.primaryColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.accountType[index],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: controller.indexOfAccountType == index
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  GetBuilder<RegisterController>(
                    builder: (controller) {
                      return CustomButton(
                        onTap: controller.isLoading
                            ? null
                            : () async {
                                controller.createAccount();
                              },
                        text: "انشاء حساب",
                        buttonColor: controller.isLoading ? Colors.brown : AppColor.primaryColor,
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "من خلال إنشاء حساب ، فإنك توافق على ",
                            style: TextStyle(color: AppColor.grayColor),
                          ),
                          TextSpan(
                            text: "شروط الخدمة",
                            style: TextStyle(color: AppColor.primaryColor),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(
                            text: " و ",
                            style: TextStyle(color: AppColor.grayColor),
                          ),
                          TextSpan(
                            text: "سياسة الخصوصية",
                            style: TextStyle(color: AppColor.primaryColor),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "لديك حساب بالفعل؟ ",
                            style: TextStyle(color: AppColor.grayColor, fontSize: 16),
                          ),
                          TextSpan(
                            text: "تسجيل الدخول",
                            style: TextStyle(color: AppColor.primaryColor, fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("object");
                                Get.off(() => LoginScreen());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
