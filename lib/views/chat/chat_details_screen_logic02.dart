import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';

import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_alert_dialog.dart';
import 'package:psychic_helper/components/custom_button.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/controllers/chat/chat_details_controller.dart';
import 'package:psychic_helper/controllers/chat/chat_details_controller_logic2.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/message_model.dart';
import 'package:psychic_helper/models/user_model.dart';

class ChatDetailsScreenLogic02 extends StatelessWidget {
  ChatDetailsScreenLogic02({
    Key? key,
    required this.model,
  }) : super(key: key);
  final UserModel model;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatDetailsControllerLogic2());
    controller.init(model);

    return GetBuilder<ChatDetailsControllerLogic2>(
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
                  child: FirestoreQueryBuilder(
                    pageSize: 20,
                    query: FirebaseFirestore.instance
                        .collection("users")
                        .doc(MainUser.model!.uId)
                        .collection("chats")
                        .doc(model.uId)
                        .collection("messages")
                        .orderBy("dateTime", descending: true),
                    builder: (context, FirestoreQueryBuilderSnapshot snapshot, child) {
                      return Builder(
                        builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              reverse: true,
                              itemCount: snapshot.docs.length,
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(height: 10);
                              },
                              itemBuilder: (BuildContext context, int index) {
                                final hasEndReached = snapshot.hasMore &&
                                    !snapshot.isFetchingMore &&
                                    index + 1 == snapshot.docs.length;
                                if (hasEndReached) {
                                  print(" ============================= ");
                                  print("hasEndReached ");
                                  snapshot.fetchMore();
                                }
                                final message = MessageModel.fromMap(snapshot.docs[index].data());
                                if (message.senderId == MainUser.model!.uId)
                                  return GestureDetector(
                                    onLongPress: message.isDeleted!
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
                                                            model: message,
                                                            receiveId: message.receiveId!,
                                                            index: index,
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
                                      message: message.text!,
                                    ),
                                  );
                                else
                                  return _BuildOtherMessage(
                                    model: model,
                                    message: message.text!,
                                  );
                              },
                            ),
                          );
                        },
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
