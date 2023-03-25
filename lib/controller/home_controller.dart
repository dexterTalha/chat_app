import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/utils/constants.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> sendFriendRequest(String email) async {
    var data = await _db.collection(AppConstant.user).where('email', isEqualTo: email).get();
    if (data.size <= 0) {
      return false;
    }

    String? myEmail = _auth.currentUser?.email;
    var requestExists = await _db.collection(AppConstant.request).where('sender', isEqualTo: myEmail).where('receiver', isEqualTo: email).get();
    if (requestExists.size >= 1) {
      print("request exists");
      return false;
    }
    await _db.collection(AppConstant.request).add({
      'sender': myEmail,
      'receiver': email,
    });

    return true;
  }
}
