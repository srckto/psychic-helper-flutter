

import 'package:psychic_helper/models/user_model.dart';

class ChatModel {
  String? lastMessage;
  String? dateTime;
  bool? isShowLastMessage;
  UserModel? userModel;
  ChatModel({
    this.lastMessage,
    this.dateTime,
    this.userModel,
    this.isShowLastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'dateTime': dateTime,
      'isShowLastMessage': isShowLastMessage,
      'userModel': userModel?.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      lastMessage: map['lastMessage'],
      dateTime: map['dateTime'],
      isShowLastMessage: map['isShowLastMessage'],
      userModel: map['userModel'] != null ? UserModel.fromMap(map['userModel']) : null,
    );
  }
}
