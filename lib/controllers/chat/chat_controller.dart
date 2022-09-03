import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:psychic_helper/helper/cache_storage.dart';
import 'package:psychic_helper/helper/constants.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/chat_model.dart';
import 'package:psychic_helper/models/user_model.dart';
import 'package:psychic_helper/network/firestore_service.dart';

class ChatController extends GetxController {
  List<ChatModel> chats = [];
  bool isLoading = false;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatSteam;

  @override
  void onInit() async {
    super.onInit();
    log(" /////////////////////////////// on Init Chat Controller ");
    chats = [];
    chatSteam = listingToChat();
    update();
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listingToChat() {
    isLoading = true;
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
        // isLoading = false;
        // update();
      },
      onError: (error) {
        print(error.toString());
        isLoading = false;
        update();
      },
    );
  }

  Future<void> deleteChat(UserModel otherUser) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(MainUser.model!.uId)
          .collection("chats")
          .doc(otherUser.uId)
          .collection("messages")
          .get()
          .then(
        (value) {
          value.docs.forEach(
            (element) {
              element.reference.delete();
            },
          );
        },
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(MainUser.model!.uId)
          .collection("chats")
          .doc(otherUser.uId)
          .delete();

      await _deleteUserFromMyConnections(otherUser.uId!);
      update();
    } catch (e) {
      print(e.toString());
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
    event.docs.forEach((element) {
      log(element.data().toString());
    });
    try {
      event.docs.forEach((element) {
        // List<String?> idInMyConnection = MainUser.model!.myConnection!.map((e) => e.id).toList();
        // idInMyConnection.forEach((element) {

        // });
        if (idOfMyConnections.contains(element.reference.id) == false) {
          idOfMyConnections.add(element.data()["uId"]);
          lastMessage.add(element.data()["lastMessage"]);
          dateTimeOfLastMessage.add(element.data()["dateTime"]);
          isShowLastMessage.add(element.data()["isShowLastMessage"]);
        }
      });

      var queryOfUsers = await FirestoreService.instance.getUsers();
      log(" length " + idOfMyConnections.length.toString());
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
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      update();
      print(e.toString());
    }

    print("============================= Chat Model");
    print(chats);
    print("============================= Chat Model");
  }

  // Future<void> getChats(QuerySnapshot<Map<String, dynamic>> event) async {
  //   List<String> lastMessage = [];
  //   List<String> dateTimeOfLastMessage = [];
  //   List<String> idOfMyConnections = [];
  //   List<bool?> isShowLastMessage = [];
  //   chats = [];

  //   try {
  //     event.docs.forEach((element) {
  //       // List<String?> idInMyConnection = MainUser.model!.myConnection!.map((e) => e.id).toList();
  //       // idInMyConnection.forEach((element) {

  //       // });
  //       // if (!idOfMyConnections.contains(element.reference.id)) {
  //       idOfMyConnections.add(element.data()["uId"]);
  //       lastMessage.add(element.data()["lastMessage"]);
  //       dateTimeOfLastMessage.add(element.data()["dateTime"]);
  //       isShowLastMessage.add(element.data()["isShowLastMessage"]);
  //       // }
  //     });

  //     var queryOfUsers = await FirestoreService.instance.getUsers();

  //     for (int i = 0; i < idOfMyConnections.length; i++) {
  //       if (MainUser.model?.uId == idOfMyConnections[i]) continue;
  //       for (int j = 0; j < queryOfUsers.docs.length; j++) {
  //         if (idOfMyConnections[i] == queryOfUsers.docs[j].data()["uId"]) {
  //           chats.add(
  //             ChatModel(
  //               dateTime: dateTimeOfLastMessage[i],
  //               lastMessage: lastMessage[i],
  //               isShowLastMessage: isShowLastMessage[i],
  //               userModel: UserModel.fromMap(queryOfUsers.docs[j].data()),
  //             ),
  //           );
  //           break;
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }

  //   print("============================= Chat Model");
  //   print(chats);
  //   print("============================= Chat Model");
  // }
}
