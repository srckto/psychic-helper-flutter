import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_card.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/views/home/post_details_screen.dart';

class BuildPostItem extends StatelessWidget {
  const BuildPostItem({
    Key? key,
    required this.model,
    required this.onTap,
  }) : super(key: key);

  final PostModel model;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BuildImage(
              imageUrl: model.image ?? "",
              height: 190,
              fit: BoxFit.cover,
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  CustomText(
                    model.title ?? "لا يوجد عنوان",
                    maxLines: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5),
                  CustomText(
                    model.stringDescription?.replaceAll("\n", "") ?? "لا يوجد وصف",
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
