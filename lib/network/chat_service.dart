import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psychic_helper/helper/main_user.dart';
import 'package:psychic_helper/models/user_model.dart';

class ChatService {
  ChatService._();
  static final instance = ChatService._();

  Future<void> deleteAllChats(List<MyConnectionModel> connections) async {
    connections.forEach((element) async {
      await deleteSingleChat(element.id ?? "");
      await deleteSingleChatFromOtherUser(element.id ?? "");
    });
  }

  Future<void> deleteSingleChat(String uidOtherUser) async {
    await _deleteAllMessagesFromMe(uidOtherUser);
    await _deleteChatFromMe(uidOtherUser);
  }

  Future<void> deleteSingleChatFromOtherUser(String uidOtherUser) async {
    await _deleteAllMessagesFromOtherUser(uidOtherUser);
    await _deleteChatFromOtherUser(uidOtherUser);
  }

  //! PRAVITE FUNCTIONS
  Future<void> _deleteAllMessagesFromMe(String uidOtherUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(MainUser.model!.uId)
        .collection("chats")
        .doc(uidOtherUser)
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
  }

  Future<void> _deleteChatFromMe(String uidOtherUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(MainUser.model!.uId)
        .collection("chats")
        .doc(uidOtherUser)
        .delete();
  }

  Future<void> _deleteAllMessagesFromOtherUser(String uidOtherUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uidOtherUser)
        .collection("chats")
        .doc(MainUser.model!.uId)
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
  }

  Future<void> _deleteChatFromOtherUser(String uidOtherUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uidOtherUser)
        .collection("chats")
        .doc(MainUser.model!.uId)
        .delete();
  }
}
