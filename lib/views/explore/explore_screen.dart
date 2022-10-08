import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_card.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/explore/explore_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/views/explore/result_explore_screen.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({Key? key}) : super(key: key);
  
  final controller = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              "مم تعاني؟",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            SizedBox(height: 20),
            GetBuilder<ExploreController>(
              builder: (controller) {
                return CustomCard(
                  child: Column(
                    children: List.generate(
                      controller.psychProblems.length,
                      (index) => GestureDetector(
                        onTap: () {
                          controller.onChangePsych(index);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          decoration: BoxDecoration(
                            color: controller.indexOfPsychProblem == index
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
                                  controller.psychProblems[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "بحث",
              onTap: () {
                Get.to(() => ResultExploreScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
