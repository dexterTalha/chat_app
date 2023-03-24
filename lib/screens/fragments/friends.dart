import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tabahi_chat_app/utils/constants.dart';
import 'package:tabahi_chat_app/utils/my_theme.dart';

class FriendFragment extends StatefulWidget {
  const FriendFragment({super.key});

  @override
  State<FriendFragment> createState() => _FriendFragmentState();
}

class _FriendFragmentState extends State<FriendFragment> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return const AlertDialog(
                    title: Text("Add Friend"),
                    content: SizedBox(
                      width: double.maxFinite,
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: MyTheme.primary),
            child: const Center(
              child: Text(
                "Add Friend",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: _db.collection(AppConstant.friends).doc(_auth.currentUser?.uid).snapshots(),
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                //circular indicator
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                //show error
              }
              if (!snap.hasData) {
                //no data
              }
              if (snap.data == null) {
                return const Text("Error");
              }
              DocumentSnapshot<Map<String, dynamic>> data = snap.data!;
              return Container();
            },
          ),
        ),
      ],
    );
  }
}
