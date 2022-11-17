import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_text.dart';

import 'package:psychic_helper/helper/status_request.dart';

class HandleViewStatus extends StatelessWidget {
  const HandleViewStatus({
    Key? key,
    required this.statusRequest,
    required this.widget,
    required this.reTryFunction,
  }) : super(key: key);
  final StatusRequest statusRequest;
  final Widget widget;
  final void Function()? reTryFunction;

  @override
  Widget build(BuildContext context) {
    switch (statusRequest) {
      case StatusRequest.none:
        return widget;
      case StatusRequest.loading:
        return Center(child: CircularProgressIndicator.adaptive());
      case StatusRequest.success:
        return widget;
      case StatusRequest.failure:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                "حصل خطأ ما, يرجى المحاولة لاحقاً",
                fontSize: 18,
              ),
              SizedBox(height: 15),
              CustomButton(
                onTap: reTryFunction,
                text: "اعادة المحاولة",
                width: Get.width * 0.5,
              ),
            ],
          ),
        );
    }
  }
}
