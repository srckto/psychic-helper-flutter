import 'package:flutter/material.dart';
import 'package:psychic_helper/helper/app_color.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.colorOfIcon,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.maxLines,
    this.obscureText = false,
  }) : super(key: key);
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? hintText;
  final Color? colorOfIcon;
  final void Function(String)? onFieldSubmitted;
  final Widget? prefixIcon;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: Colors.red,
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 14,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColor.fontGrayColor,
        ),
        prefixIcon: prefixIcon,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }
}
