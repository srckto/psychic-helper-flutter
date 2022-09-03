import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:psychic_helper/helper/constants.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/message_model.dart';

class MessageService {
  MessageService._();
  static final MessageService instance = MessageService._();
  Future<void> deleteSingleMessageFromMe(MessageModel model, String receiveId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(MainUser.model!.uId)
        .collection("chats")
        .doc(receiveId)
        .collection("messages")
        .doc(model.id)
        .update(model.toMap());
  }

  Future<void> deleteSingleMessageFromOtherSide(MessageModel model, String receiveId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiveId)
        .collection("chats")
        .doc(MainUser.model!.uId)
        .collection("messages")
        .doc(model.id)
        .update(model.toMap());
  }

  Future<DocumentReference<Map<String, dynamic>>> sendMyMessage(
    String receiveId,
    MessageModel messageModel,
  ) async {
    await updateMyMessageDocument(receiveId, messageModel);

    return await FirebaseFirestore.instance
        .collection("users")
        .doc(MainUser.model!.uId)
        .collection("chats")
        .doc(receiveId)
        .collection("messages")
        .add(messageModel.toMap());
  }

  Future<void> sendOtherMessage(
    String receiveId,
    MessageModel messageModel,
    String idOfDocument,
  ) async {
    await updateOtherSideMessageDocument(receiveId, messageModel);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiveId)
        .collection("chats")
        .doc(MainUser.model!.uId)
        .collection("messages")
        .doc(idOfDocument)
        .set(messageModel.toMap());
  }

  Future<void> updateMyMessageDocument(
    String receiveId,
    MessageModel messageModel,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(MainUser.model!.uId)
        .collection("chats")
        .doc(receiveId)
        .set({
      "dateTime": DateFormat(FORMATOFDATETIME).format(DateTime.now()),
      "lastMessage": messageModel.text,
      "isShowLastMessage": true,
      "uId": receiveId,
    });
  }

  Future<void> updateOtherSideMessageDocument(
    String receiveId,
    MessageModel messageModel,
  ) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiveId)
        .collection("chats")
        .doc(MainUser.model!.uId)
        .set({
      "dateTime": DateFormat(FORMATOFDATETIME).format(DateTime.now()),
      "lastMessage": messageModel.text,
      "isShowLastMessage": false,
      "uId": MainUser.model?.uId,
    });
  }
}
