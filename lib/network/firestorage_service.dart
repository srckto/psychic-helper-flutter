import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirestorageService {
  FirestorageService._();
  static final instance = FirestorageService._();

  Future<TaskSnapshot> uploadUserImage(File file , String fileName) async {
    
    
    return await FirebaseStorage.instance
        .ref()
        .child("users_image/${fileName}")
        .putFile(file);
  }

  Future<void> deleteImage(String imageName) async {
    try {
      await FirebaseStorage.instance.ref().child("users_image/${imageName}").delete();
    } catch (e) {
      print("========================= Delete Image Function");
      print(e.toString());
      print("========================= Delete Image Function");
    }
  }
}
