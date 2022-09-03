import 'package:flutter/material.dart';
import 'package:psychic_helper/helper/app_color.dart';

class CustomText extends StatelessWidget {
  CustomText(
    this.text, {
    Key? key,
    this.color = AppColor.grayColor,
    this.fontWeight,
    this.fontSize,
    this.maxLines,
    this.fontFamily,
    this.overflow,
    this.textAlign = TextAlign.center,
  }) : super(key: key);
  final String text;
  final Color color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final int? maxLines;
  final TextAlign? textAlign;
  final String? fontFamily;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
        overflow: overflow ?? TextOverflow.ellipsis,
      ),
      textAlign: textAlign,
      maxLines: maxLines ?? 100,
    );
  }
}
