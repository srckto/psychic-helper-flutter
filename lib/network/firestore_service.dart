import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psychic_helper/models/post_model.dart';
import 'package:psychic_helper/models/user_model.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    return await _db.collection("users").doc(uid).get();
  }

  Future<void> saveUser(UserModel model) async {
    await _db.collection("users").doc(model.uId).set(model.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers() async {
    return await _db.collection("users").get();
  }

  Future<void> updateUser(UserModel model) async {
    await _db.collection("users").doc(model.uId!).set(model.toMap());
  }

  // Post functions
  Future<QuerySnapshot<Map<String, dynamic>>> getPosts() async {
    return await _db.collection("posts").orderBy("dataTimeOfPosts", descending: true).get();
  }

  Future<DocumentReference<Map<String, dynamic>>> addPost(PostModel model) async {
    return await _db.collection("posts").add(model.toMap());
  }

  Future<void> updatePost(PostModel model) async {
    await _db.collection("posts").doc(model.id).update(model.toMap());
  }

  Future<void> deletePost(String id) async {
    await _db.collection("posts").doc(id).delete();
  }
}
