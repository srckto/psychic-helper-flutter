import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/cutom_toast.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/network/auth_service.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> forgot() async {
    if (!formKey.currentState!.validate()) return;
    try {
      isLoading = true;
      update();

      await AuthService.instance.restPassword(emailController.text);
      CustomToast.show("تم ارسال الرسالة بنجاح, يرجى التحقق من بريدك الالكتروني", AppColors.green);

      isLoading = false;
      update();
    } on FirebaseAuthException catch (error) {
      CustomToast.show(error.message ?? "حدث خطأ, يرجى المحاولة بوقت اخر", AppColors.red);
      isLoading = false;
      update();
    } catch (e) {
      CustomToast.show("حدث خطأ, يرجى المحاولة بوقت اخر", AppColors.red);
      isLoading = false;
      update();
    }
  }
}
