import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_card.dart';
import 'package:psychic_helper/components/custom_form_field.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/auth/login_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/functions.dart';
import 'package:psychic_helper/views/auth/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final controller = Get.put(LoginController());

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: Get.height,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "تسجيل الدخول",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20),
                  CustomCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          CustomFormField(
                            labelText: "اليريد الالكتروني",
                            controller: controller.email,
                            prefixIcon: Icon(Icons.email_rounded),
                            validator: emailValidator,
                          ),
                          Divider(),
                          CustomFormField(
                            labelText: "كلمة السر",
                            controller: controller.password,
                            obscureText: true,
                            prefixIcon: Icon(Icons.lock_rounded),
                            validator: passwordValidator,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GetBuilder<LoginController>(
                    builder: (controller) {
                      return CustomButton(
                        onTap: controller.isLoading
                            ? null
                            : () async {
                                controller.login();
                              },
                        text: "تسجيل الدخول",
                        buttonColor: controller.isLoading ? Colors.brown : AppColor.primaryColor,
                      );
                    },
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "ليس لديك حساب؟",
                            style: TextStyle(color: AppColor.grayColor, fontSize: 16),
                          ),
                          TextSpan(
                            text: " انشاء حساب جديد.",
                            style: TextStyle(color: AppColor.primaryColor, fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("object");
                                Get.off(() => RegisterScreen());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
