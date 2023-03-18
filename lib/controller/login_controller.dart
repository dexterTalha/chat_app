import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isPasswordHidden = true.obs;
  RxBool isSignUpPasswordHidden = true.obs;
  static LoginController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  Rx<User?> get currentUser => _user.obs;

  Future<void> signInWithPassword({String? email, String? password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email ?? "",
        password: password ?? "",
      );
      _user = credential.user;
      if (_user != null) {
        //Qi5WqpwueNfY6DcTKxoLbx8C2JS2
        print(_user?.uid);
      } else {
        print(credential.additionalUserInfo);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e.code);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUserWithEmailPassword({String? name, String? mobile, String? email, String? password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email ?? "",
        password: password ?? "",
      );
      _user = credential.user;
      if (_user != null) {
        //SIGN UP
        await _db.collection("Users").doc(_user?.uid).set({
          'uid': _user?.uid,
          'name': name,
          'email': email,
          'mobile': mobile,
        });
        // _db.collection("collectionPath").add({
        //   'uid': _user?.uid,
        //   'name': name,
        //   'email': email,
        //   'mobile': mobile,
        // });
      } else {
        print(credential.additionalUserInfo);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e.code);
      }
    } catch (e) {
      print(e);
    }
  }
}