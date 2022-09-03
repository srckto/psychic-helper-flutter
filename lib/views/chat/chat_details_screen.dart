import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_alert_dialog.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/components/empty_screen.dart';
import 'package:psychic_helper/controllers/chat/chat_details_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({
    Key? key,
    required this.model,
  }) : super(key: key);
  final UserModel model;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatDetailsController());
    controller.init(model);

    return GetBuilder<ChatDetailsController>(
      builder: (controller) {
        controller.stateOfPermission = controller.checkPermission(model);
        return Scaffold(
          appBar: AppBar(
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: model.name,
                    style: TextStyle(color: AppColor.grayColor, fontSize: 16),
                  ),
                  if (controller.stateOfPermission == 2)
                    TextSpan(
                      text: "  (محظور)  ",
                      style: TextStyle(color: AppColor.primaryColor, fontSize: 16),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: "هل تريد فك الحظر؟",
                                subTitle: null,
                                textOfAccept: 'فك الحظر',
                                textOfCancel: 'الغاء',
                                onAccept: controller.loadingOfUpdatePermission
                                    ? null
                                    : () async {
                                        controller.updatePermission(0, model);
                                        Get.back();
                                      },
                                onCancel: () {
                                  Navigator.of(context).pop(false);
                                },
                              );
                            },
                          );
                        },
                    ),
                ],
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                controller.showMessageStream?.cancel();
                controller.messageStream?.cancel();
                controller.messages = [];
                Get.delete<ChatDetailsController>(force: true);
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColor.primaryColor,
              ),
            ),
          ),
          body: Container(
            width: Get.width,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (controller.isLoading) return Center(child: CircularProgressIndicator());
                      if (controller.messages.isEmpty)
                        return EmptyScreen(message: "لاتوجد اي رسالة");
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          reverse: true,
                          itemCount: controller.messages.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            log(controller.messages.length.toString());
                            if (controller.messages[index].senderId == MainUser.model!.uId)
                              return GestureDetector(
                                onLongPress: controller.messages[index].isDeleted!
                                    ? null
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialog(
                                              title: "حذف الرسالة",
                                              subTitle: "سيتم حذفها من الطرفين",
                                              textOfAccept: "حذف",
                                              textOfCancel: 'الغاء',
                                              onAccept: controller.loadingOfUpdatePermission
                                                  ? null
                                                  : () {
                                                      controller.deleteSingleMessage(
                                                        model: controller.messages[index],
                                                        receiveId:
                                                            controller.messages[index].receiveId!,
                                                      );
                                                      Get.back();
                                                    },
                                              onCancel: () {
                                                Get.back();
                                              },
                                            );
                                          },
                                        );
                                      },
                                child: _BuildMyMessage(
                                  message: controller.messages[index].text!,
                                ),
                              );
                            else
                              return _BuildOtherMessage(
                                model: model,
                                message: controller.messages[index].text!,
                              );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Builder(
                  builder: (_) {
                    return Column(
                      children: [
                        if (controller.stateOfPermission == 3)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CustomText('"تم حظرك من الطرف الاخر"'),
                          ),
                        if (controller.stateOfPermission == 1)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: "موافقة",
                                    buttonColor: Colors.green,
                                    onTap: () {
                                      controller.updatePermission(0, model);
                                    },
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: CustomButton(
                                    text: "رفض",
                                    buttonColor: Colors.red,
                                    onTap: controller.loadingOfUpdatePermission
                                        ? null
                                        : () {
                                            controller.updatePermission(2, model);
                                          },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(width: 6),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "اكتب رسالتك...",
                                      border: InputBorder.none,
                                    ),
                                    controller: controller.textController,
                                    enabled: controller.stateOfPermission == 0,
                                    minLines: 1,
                                    maxLines: 4,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    controller.sendMessage(
                                      receiveId: model.uId!,
                                      text: controller.textController.text,
                                      dateTime: DateTime.now().toIso8601String(),
                                    );
                                    controller.textController.clear();
                                  },
                                  child: Icon(
                                    (Icons.send_rounded),
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BuildOtherMessage extends StatelessWidget {
  const _BuildOtherMessage({
    Key? key,
    required this.model,
    required this.message,
  }) : super(key: key);
  final UserModel model;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: BuildImage(
            imageUrl: model.image!,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 6),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
        SizedBox(width: 30),
      ],
    );
  }
}

class _BuildMyMessage extends StatelessWidget {
  const _BuildMyMessage({
    Key? key,
    required this.message,
  }) : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(width: 30),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
        SizedBox(width: 6),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: BuildImage(
            imageUrl: MainUser.model!.image!,
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
