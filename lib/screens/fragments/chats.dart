import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/friend_row_widget.dart';
import '../../controller/home_controller.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../chat_screen.dart';

class ChatFragment extends StatefulWidget {
  const ChatFragment({super.key});

  @override
  State<ChatFragment> createState() => _ChatFragmentState();
}

class _ChatFragmentState extends State<ChatFragment> {
  final HomeController _controller = HomeController.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.db.collection(AppConstant.chats).doc(_controller.currentUser?.uid).collection("ChatList").orderBy('timestamp', descending: true).snapshots(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snap.hasError || !snap.hasData) {
          return const Center(
            child: Text("No Friend Request found"),
          );
        }
        return ListView.builder(
          itemCount: snap.data?.size ?? 0,
          itemBuilder: (con, index) {
            QueryDocumentSnapshot<Map<String, dynamic>>? data = snap.data?.docs[index];

            return FutureBuilder(
              future: _controller.db.collection(AppConstant.user).doc(data?.id).get(),
              builder: (c, futureSnap) {
                /// qds -> {'email': "", mob....}
                var user = futureSnap.data?.data();
                UserModel userModel = UserModel.fromMap(user ?? {});
                String name = userModel.name ?? "";
                String email = userModel.email ?? "";
                String uid = userModel.uid ?? "";
                return FriendRowWidget(
                  name: name,
                  email: email,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(friend: userModel)));
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
