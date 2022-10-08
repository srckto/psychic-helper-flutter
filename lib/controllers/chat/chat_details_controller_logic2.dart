import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:psychic_helper/components/cutom_toast.dart';
import 'package:psychic_helper/helper/cache_storage.dart';
import 'package:psychic_helper/helper/constants.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/message_model.dart';
import 'package:psychic_helper/models/user_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';
import 'package:psychic_helper/network/message_service.dart';

class ChatDetailsControllerLogic2 extends GetxController {
  final UserModel userModel;
  ChatDetailsControllerLogic2({required this.userModel});

  late bool isLoading;
  late TextEditingController textController;
  late bool loadingOfUpdatePermission;
  late int stateOfPermission;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? showMessageStream;

  @override
  void onInit() {
    isLoading = true;
    update();
    textController = TextEditingController();
    stateOfPermission = checkPermission(userModel);
    loadingOfUpdatePermission = false;
    showMessageStream = checkShowMessages(userModel.uId!);
    update();
    super.onInit();
  }

  // void init(UserModel otherUserModel) {
  //   isLoading = true;
  //   update();
  //   textController = TextEditingController();
  //   stateOfPermission = checkPermission(otherUserModel);
  //   loadingOfUpdatePermission = false;
  //   showMessageStream = checkShowMessages(otherUserModel.uId!);
  //   update();
  // }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> checkShowMessages(String receiveId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(MainUser.model!.uId)
        .collection("chats")
        .doc(receiveId)
        .snapshots()
        .listen(
      (event) {
        if (event.data() != null || event.data()?["isShowLastMessage"] != null) {
          print(event.reference.id);
          event.reference.update({
            "isShowLastMessage": true,
          });
        }
      },
    );
  }

  Future<void> sendMessage({
    required String receiveId,
    required String text,
    required String dateTime,
  }) async {
    try {
      await checkIfTheUserFoundInMyConnectionsAndUpdate(receiveId);

      MessageModel messageModel = MessageModel(
        senderId: MainUser.model!.uId,
        receiveId: receiveId,
        dateTime: dateTime,
        text: text,
        isDeleted: false,
      );

      update();
      String? id = await _sendMyMessage(receiveId, messageModel);
      if (id != null) await _sendOtherMessage(receiveId, messageModel, id);
    } catch (e) {
      CustomToast.show("فشل بارسال الرسالة", Colors.red);
      print(e.toString());
    }
  }

  int checkPermission(UserModel model) {
    var selectedConnection =
        MainUser.model?.myConnection?.firstWhereOrNull((element) => element.id == model.uId);
    return selectedConnection?.state ?? 0;
  }

  Future<void> updatePermission(int permissionState, UserModel model) async {
    try {
      loadingOfUpdatePermission = true;
      update();
      var selectConnection =
          MainUser.model!.myConnection!.firstWhere((element) => element.id == model.uId);

      selectConnection.state = permissionState;
      await FirestoreService.instance.updateUser(MainUser.model!);

      var convertDataToJson = jsonEncode(MainUser.model!.toMap());

      await CacheStorage.save(CACHE_USER, convertDataToJson);

      if (permissionState == 2) {
        updatePermissionOfOtherSide(model, 3);
      }
      if (permissionState == 0) {
        updatePermissionOfOtherSide(model, 0);
      }

      checkPermission(model);

      loadingOfUpdatePermission = false;
      update();
    } catch (e) {
      loadingOfUpdatePermission = false;
      update();
      print(e.toString());
    }
  }

  Future<void> updatePermissionOfOtherSide(UserModel model, int permissionState) async {
    try {
      var selectConnection =
          model.myConnection!.firstWhereOrNull((element) => element.id == MainUser.model?.uId);
      if (selectConnection == null) return;
      selectConnection.state = permissionState;
      await FirestoreService.instance.updateUser(model);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _sendOtherMessage(
    String receiveId,
    MessageModel messageModel,
    String idOfDocument,
  ) async {
    try {
      await MessageService.instance.sendOtherMessage(
        receiveId,
        messageModel,
        idOfDocument,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> _sendMyMessage(String receiveId, MessageModel messageModel) async {
    String? id;
    try {
      var documentReference = await MessageService.instance.sendMyMessage(receiveId, messageModel);
      id = documentReference.id;
      await documentReference.update({"id": documentReference.id});
    } catch (e) {
      print(e.toString());
    }
    return id;
  }

  Future<void> checkIfTheUserFoundInMyConnectionsAndUpdate(String receiveId) async {
    // bool found = false;
    MyConnectionModel? checkConnection =
        MainUser.model!.myConnection!.firstWhereOrNull((element) => element.id == receiveId);

    if (checkConnection == null) {
      MainUser.model!.myConnection!.add(
        MyConnectionModel(
          id: receiveId,
          state: MainUser.model!.isPerson! ? 0 : 0,
        ),
      );
      await FirestoreService.instance.updateUser(MainUser.model!);

      var convertDataToJson = jsonEncode(MainUser.model!.toMap());

      await CacheStorage.save(CACHE_USER, convertDataToJson);
    }
    updateConnectionOfOtherUser(receiveId);
  }

  Future<void> updateConnectionOfOtherUser(String id) async {
    var document = await FirestoreService.instance.getUser(id);
    UserModel userModel = UserModel.fromMap(document.data()!);

    MyConnectionModel? checkConnection =
        userModel.myConnection!.firstWhereOrNull((element) => element.id == MainUser.model!.uId);

    if (checkConnection == null) {
      userModel.myConnection!.add(
        MyConnectionModel(
          id: MainUser.model!.uId,
          state: MainUser.model!.isPerson! ? 1 : 0,
        ),
      );
      await FirestoreService.instance.updateUser(userModel);
    }
  }

  Future<void> deleteSingleMessage(
      {required MessageModel model, required String receiveId, required int index}) async {
    try {
      MessageModel newModel = MessageModel(
        dateTime: model.dateTime,
        id: model.id,
        receiveId: model.receiveId,
        senderId: model.senderId,
        text: '"تم حذف الرسالة"',
        isDeleted: true,
      );

      // if the last message show
      if (index == 0) {
        MessageService.instance.updateMyMessageDocument(receiveId, newModel);
        MessageService.instance.updateOtherSideMessageDocument(receiveId, newModel);
      }
      await MessageService.instance.deleteSingleMessageFromMe(newModel, receiveId);
      await MessageService.instance.deleteSingleMessageFromOtherSide(newModel, receiveId);
    } catch (e) {
      print(e.toString());
    }
  }
}
