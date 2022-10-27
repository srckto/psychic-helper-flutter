import 'package:firebase_auth/firebase_auth.dart';
import 'package:psychic_helper/helper/main_user.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> deleteAccount(String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: MainUser.model!.email!, password: password);
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      await _auth.currentUser?.delete();
    } catch (e) {
      throw e;
    }
  }

  Future<void> restPassword(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }
}
