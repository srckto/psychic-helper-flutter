import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/helper/app_color.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.text,
    this.buttonColor = AppColor.primaryColor,
    this.shadowColor = AppColor.primaryColor,
    this.onTap,
    this.height = 46,
    this.width,
    this.fontColor = Colors.white,
    Key? key,
  }) : super(key: key);
  final String text;
  final Color buttonColor;
  final void Function()? onTap;
  final Color shadowColor;
  final double height;
  final Color fontColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? Get.width * 0.9,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: fontColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
