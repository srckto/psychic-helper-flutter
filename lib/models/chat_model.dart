import 'package:psychic_helper/models/user_model.dart';

class ChatModel {
  String? lastMessage;
  String? dateTime;
  bool? isShowLastMessage;
  int? messagesCount;
  UserModel? userModel;
  ChatModel({
    this.lastMessage,
    this.dateTime,
    this.messagesCount,
    this.userModel,
    this.isShowLastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'dateTime': dateTime,
      'messagesCount': messagesCount,
      'isShowLastMessage': isShowLastMessage,
      'userModel': userModel?.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      lastMessage: map['lastMessage'],
      dateTime: map['dateTime'],
      messagesCount: map["messagesCount"],
      isShowLastMessage: map['isShowLastMessage'],
      userModel: map['userModel'] != null ? UserModel.fromMap(map['userModel']) : null,
    );
  }
}
