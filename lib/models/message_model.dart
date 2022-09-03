class MessageModel {
  String? id;
  String? senderId;
  String? receiveId;
  String? dateTime;
  String? text;
  bool? isDeleted;
  MessageModel({
    this.senderId,
    this.receiveId,
    this.dateTime,
    this.text,
    this.id,
    this.isDeleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiveId': receiveId,
      'dateTime': dateTime,
      'text': text,
      'isDeleted': isDeleted,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? "id",
      senderId: map['senderId'],
      receiveId: map['receiveId'],
      dateTime: map['dateTime'],
      text: map['text'] ?? "",
      isDeleted: map['isDeleted'] ?? false,
    );
  }
}
