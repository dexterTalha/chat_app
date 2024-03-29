import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/screens/login_screen.dart';
import 'package:tabahi_chat_app/utils/constants.dart';

class LoginController extends GetxController {
  RxBool isPasswordHidden = true.obs;
  RxBool isSignUpPasswordHidden = true.obs;
  static LoginController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  Rx<User?> get currentUser => _user.obs;
  RxBool isSignUpLoading = false.obs;
  RxBool isLoginLoading = false.obs;

  Future<String?> signInWithPassword({String? email, String? password}) async {
    isLoginLoading(true);
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
        return "Error";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e.code);
      }
      return e.message ?? "Error";
    } catch (e) {
      print(e);
      return e.toString();
    } finally {
      isLoginLoading(false);
    }
    return null;
  }

  Future<bool> createUserWithEmailPassword({String? name, String? mobile, String? email, String? password}) async {
    isSignUpLoading(true);
    bool result = false;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email ?? "",
        password: password ?? "",
      );
      _user = credential.user;
      if (_user != null) {
        //SIGN UP
        await _db.collection(AppConstant.user).doc(_user?.uid).set({
          'uid': _user?.uid,
          'name': name,
          'email': email,
          'mobile': mobile,
        });
        result = true;
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
    await FirebaseAuth.instance.signOut();
    isSignUpLoading(false);
    return result;
  }

  Future<String?> changePassword(BuildContext context, String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
      return null;
    }
    String? ret;
    try {
      final cred = EmailAuthProvider.credential(email: user.email ?? "", password: currentPassword);

      UserCredential userCred = await user.reauthenticateWithCredential(cred);
      if (userCred.user != null) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      ret = e.toString();
    }

    return ret;
  }
}
