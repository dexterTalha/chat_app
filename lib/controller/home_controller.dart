import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/utils/constants.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> sendFriendRequest(String email) async {
    var data = await db.collection(AppConstant.user).where('email', isEqualTo: email).get();
    if (data.size <= 0) {
      Get.snackbar("Request not sent", "Friend Request Already Sent");
      return false;
    }

    String? myEmail = auth.currentUser?.email;
    var requestExists = await db.collection(AppConstant.request).where('sender', isEqualTo: myEmail).where('receiver', isEqualTo: email).get();
    if (requestExists.size >= 1) {
      Get.snackbar("Request not sent", "Friend Request Already Sent", snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    requestExists = await db.collection(AppConstant.request).where('receiver', isEqualTo: myEmail).where('sender', isEqualTo: email).get();
    if (requestExists.size >= 1) {
      Get.snackbar("Request not sent", "Friend Request Already Pending", snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    await db.collection(AppConstant.request).add({
      'sender': myEmail,
      'receiver': email,
      'accepted': false,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    return true;
  }

  Future<bool> acceptRequest(String id) async {
    try {
      DocumentReference<Map<String, dynamic>> ref = db.collection(AppConstant.request).doc(id);
      await ref.update({'accepted': true});

      var docData = await ref.get();
      String sender = docData['sender'];
      String receiver = docData['receiver'];
      var currentTime = DateTime.now().millisecondsSinceEpoch;
      await db.collection(AppConstant.friends).add({
        'email': receiver,
        'friend': sender,
        'timestamp': currentTime,
        'isBlocked': false,
      });
      await db.collection(AppConstant.friends).add({
        'email': sender,
        'friend': receiver,
        'timestamp': currentTime,
        'isBlocked': false,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRequest(String email, {bool isSent = false, bool isFriend = false}) async {
    String myEmail = auth.currentUser?.email ?? "";

    CollectionReference reference = db.collection(isFriend ? AppConstant.friends : AppConstant.request);

    QuerySnapshot<Object?> dataList;
    if (isFriend) {
      dataList = await reference.where('email', isEqualTo: myEmail).where('friend', isEqualTo: email).get();
    } else {
      dataList = await reference.where('sender', isEqualTo: isSent ? myEmail : email).where('receiver', isEqualTo: isSent ? email : myEmail).get();
    }

    ///  [
    ///    'docid': {
    ///       sfjka:asdf,
    ///
    ///     }
    ///  ]

    if (dataList.docs.isNotEmpty) {
      var doc = dataList.docs.first;
      String uid = doc.id;
      await reference.doc(uid).delete();
      return true;
    }
    return false;
  }
}
