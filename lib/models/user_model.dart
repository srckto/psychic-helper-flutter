class UserModel {
  String? uId;
  String? name;
  String? username;
  String? email;
  String? dateOfRegister;
  String? image;
  String? imageName;
  bool? isPerson;
  bool? isAcceptedByAdmin;
  List<MyConnectionModel>? myConnection;
  UserModel({
    this.uId,
    this.name,
    this.username,
    this.email,
    this.dateOfRegister,
    this.image,
    this.isPerson,
    this.myConnection,
    this.isAcceptedByAdmin,
    this.imageName,
  });

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'username': username,
      'email': email,
      'imageName': imageName,
      'dateOfRegister': dateOfRegister,
      'image': image,
      'isPerson': isPerson,
      'isAcceptedByAdmin': isAcceptedByAdmin,
      'myConnection': myConnection != null ? myConnection?.map((x) => x.toMap()).toList() : [],
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] ?? "uId",
      name: map['name'] ?? "name",
      username: map['username'] ?? "username",
      email: map['email'] ?? "email",
      dateOfRegister: map['dateOfRegister'] ?? "username",
      image: map['image'] ?? "image",
      imageName: map['imageName'] ?? "imageName",
      isAcceptedByAdmin: map['isAcceptedByAdmin'] ?? false,
      isPerson: map['isPerson'] ?? true,
      myConnection: map['myConnection'] != null
          ? List<MyConnectionModel>.from(
              map['myConnection']?.map((x) => MyConnectionModel.fromMap(x)))
          : [],
    );
  }
}

class MyConnectionModel {
  String? id;
  int? state;

  // state if
  // 0 accepted
  // 1 wait for accept or not
  // 2 block by me
  // 3 block by other side
  MyConnectionModel({
    this.id,
    this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'state': state,
    };
  }

  factory MyConnectionModel.fromMap(Map<String, dynamic> map) {
    return MyConnectionModel(
      id: map['id'] ?? "id",
      state: map['state'] ?? 0,
    );
  }
}
