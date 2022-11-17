import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:psychic_helper/helper/cache_storage.dart';
import 'package:psychic_helper/helper/constants.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/helper/status_request.dart';
import 'package:psychic_helper/models/chat_model.dart';
import 'package:psychic_helper/models/user_model.dart';
import 'package:psychic_helper/network/chat_service.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class ChatController extends GetxController {
  List<ChatModel> chats = [];
  late StatusRequest statusRequest;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatSteam;

  @override
  void onInit() async {
    super.onInit();
    chats = [];
    statusRequest = StatusRequest.none;
    chatSteam = listingToChat();
    update();
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listingToChat() {
    statusRequest = StatusRequest.loading;
    update();

    return FirebaseFirestore.instance
        .collection("users")
        .doc(MainUser.model!.uId!)
        .collection("chats")
        .orderBy("dateTime", descending: true)
        .snapshots()
        .listen(
      (event) async {
        chats = [];
        getChats(event);
      },
      onError: (error) {
        debugPrint(error.toString());
        statusRequest = StatusRequest.failure;
        update();
      },
    );
  }

  Future<void> deleteChat(UserModel otherUser) async {
    try {
      await ChatService.instance.deleteSingleChat(otherUser.uId ?? "");

      await _deleteUserFromMyConnections(otherUser.uId!);
      update();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _deleteUserFromMyConnections(String receiveId) async {
    MainUser.model!.myConnection!.removeWhere((element) => element.id == receiveId);

    await FirestoreService.instance.updateUser(MainUser.model!);

    var convertDataToJson = jsonEncode(MainUser.model!.toMap());

    await CacheStorage.save(CACHE_USER, convertDataToJson);
  }

  Future<void> getChats(QuerySnapshot<Map<String, dynamic>> event) async {
    List<String> lastMessage = [];
    List<String> dateTimeOfLastMessage = [];
    List<String> idOfMyConnections = [];
    List<bool?> isShowLastMessage = [];
    chats = [];

    try {
      event.docs.forEach((element) {
        if (idOfMyConnections.contains(element.reference.id) == false) {
          idOfMyConnections.add(element.data()["uId"]);
          lastMessage.add(element.data()["lastMessage"]);
          dateTimeOfLastMessage.add(element.data()["dateTime"]);
          isShowLastMessage.add(element.data()["isShowLastMessage"]);
        }
      });

      var queryOfUsers = await FirestoreService.instance.getUsers();

      chats = [];
      for (int i = 0; i < idOfMyConnections.length; i++) {
        if (MainUser.model?.uId == idOfMyConnections[i]) continue;
        for (int j = 0; j < queryOfUsers.docs.length; j++) {
          if (idOfMyConnections[i] == queryOfUsers.docs[j].data()["uId"]) {
            chats.add(
              ChatModel(
                dateTime: dateTimeOfLastMessage[i],
                lastMessage: lastMessage[i],
                isShowLastMessage: isShowLastMessage[i],
                userModel: UserModel.fromMap(queryOfUsers.docs[j].data()),
              ),
            );
            break;
          }
        }
      }
      statusRequest = StatusRequest.success;
      update();
    } catch (e) {
      statusRequest = StatusRequest.failure;
      update();
      debugPrint(e.toString());
    }
  }
}
