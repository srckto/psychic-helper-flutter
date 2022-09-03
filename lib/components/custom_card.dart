import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.child,
    this.width,
    this.radius,
    this.padding,
    this.alignment,
    this.height,
    this.color,
    this.clipBehavior = Clip.none,
  }) : super(key: key);
  final Widget? child;
  final double? width;
  final double? radius;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.width * 0.9,
      clipBehavior: clipBehavior,
      // width: width ,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 10),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE7EAF0),
            blurRadius: 15,
          ),
        ],
      ),
      child: child,
    );
  }
}
