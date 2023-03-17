import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isPasswordHidden = true.obs;
  //string-> username, string-> password

  Future<void> signInWithPassword({String? email, String? password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email ?? "",
        password: password ?? "",
      );
      User? user = credential.user;
      if (user != null) {
        //Qi5WqpwueNfY6DcTKxoLbx8C2JS2
        print(user.uid);
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
