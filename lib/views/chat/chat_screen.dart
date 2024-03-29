import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:psychic_helper/components/build_image.dart';
import 'package:psychic_helper/components/custom_alert_dialog.dart';
import 'package:psychic_helper/components/custom_text.dart';
import 'package:psychic_helper/components/empty_screen.dart';
import 'package:psychic_helper/controllers/chat/chat_controller.dart';
import 'package:psychic_helper/helper/app_color.dart';
import 'package:psychic_helper/helper/handle_view_status.dart';
import 'package:psychic_helper/models/user_model.dart';
import 'package:psychic_helper/views/chat/chat_details_screen_logic02.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(20),
      child: GetBuilder<ChatController>(
        builder: (controller) {
          return HandleViewStatus(
            statusRequest: controller.statusRequest,
            widget: _BuildChatScreen(controller: controller),
            reTryFunction: controller.onInit,
          );
        },
      ),
    );
  }
}

class _BuildChatScreen extends StatelessWidget {
  const _BuildChatScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.chats.isEmpty) return EmptyScreen(message: "لا توجد اي رسائل");
    return ListView.separated(
      itemCount: controller.chats.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        return _BuildUserItem(
          model: controller.chats[index].userModel!,
          lastMessage: controller.chats[index].lastMessage!,
          isShowLastMessage: controller.chats[index].isShowLastMessage!,
          messagesCount: controller.chats[index].messagesCount ?? 0,
        );
      },
    );
  }
}

class _BuildUserItem extends StatelessWidget {
  final UserModel model;
  final String lastMessage;
  final bool? isShowLastMessage;
  final int messagesCount;
  const _BuildUserItem({
    Key? key,
    required this.model,
    required this.lastMessage,
    required this.isShowLastMessage,
    required this.messagesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model.uId!),
      background: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Icon(
          Icons.delete,
          size: 40.0,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'تأكيد الحذف',
              subTitle: 'هل تريد بالفعل حذف الرسائل؟\nلن تحذف من الطرف الاخر!',
              textOfAccept: 'حذف',
              textOfCancel: 'الغاء',
              onAccept: () {
                Navigator.of(context).pop(true);
                Get.find<ChatController>().deleteChat(model);
              },
              onCancel: () {
                Navigator.of(context).pop(false);
              },
            );
          },
        );
      },
      child: GestureDetector(
        onTap: () => Get.to(() => ChatDetailsScreenLogic02(model: model)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: BuildImage(
                imageUrl: model.image!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      model.name!,
                      fontSize: 20,
                      maxLines: 1,
                      color: AppColors.grayColor,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w500,
                    ),
                    CustomText(
                      lastMessage,
                      fontSize: 18,
                      maxLines: 1,
                      color: isShowLastMessage! ? AppColors.fontGrayColor : Colors.black,
                      textAlign: TextAlign.start,
                      fontWeight: !isShowLastMessage! ? FontWeight.bold : null,
                      // fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            if (!isShowLastMessage!)
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 15,
                child: Center(
                  child: Text(
                    messagesCount.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
