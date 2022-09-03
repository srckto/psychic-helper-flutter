import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychic_helper/components/custom_text.dart';

import 'package:psychic_helper/controllers/layout/layout_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';

class LayoutScreen extends StatelessWidget {
  LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(LayoutController());
    return GetBuilder<LayoutController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: CustomText(controller.items[controller.index].name),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    controller.logout();
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: IndexedStack(
              children: controller.items.map((e) => e.screen).toList(),
              index: controller.index,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              currentIndex: controller.index,
              backgroundColor: Colors.white,
              onTap: controller.onChange,
              selectedItemColor: AppColor.primaryColor,
              unselectedItemColor: AppColor.grayColor,
              selectedFontSize: 12,
              items: controller.items
                  .map(
                    (element) => BottomNavigationBarItem(
                      icon: element.icon,
                      label: element.name,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

