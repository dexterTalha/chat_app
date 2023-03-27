import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/components/friend_row_widget.dart';
import 'package:tabahi_chat_app/utils/constants.dart';

import '../../utils/my_theme.dart';

class RequestFragment extends StatefulWidget {
  const RequestFragment({super.key});

  @override
  State<RequestFragment> createState() => _RequestFragmentState();
}

class _RequestFragmentState extends State<RequestFragment> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: MyTheme.primary),
            child: const Center(
              child: Text(
                "View Sent Request",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // const FriendRowWidget(
        //   email: "Test@gmail.com",
        //   name: "Test",
        //   isRequest: true,
        // ),

        Expanded(
          child: StreamBuilder(
            stream: _db.collection(AppConstant.request).where('receiver', isEqualTo: _auth.currentUser?.email).where('accepted', isEqualTo: false).snapshots(),
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

              /// qds->query document snapshot
              /// qsn-> query snapshot is list of qds
              /// list ==> [1,2,3],
              /// item count item builder,
              /// count --> 3, indexing --> 0, 1, 2
              /// 0 -> 1, 1-> 2, 2->3
              /// qsn --> [qds->{}, {}, {}] -> sender -> a, b, c
              /// {'sender': "", 'rec': "", ......}
              return ListView.builder(
                itemCount: snap.data?.size ?? 0,
                itemBuilder: (con, index) {
                  final data = snap.data?.docs[index];
                  final sender = data?.get('sender');
                  return FutureBuilder(
                    future: _db.collection(AppConstant.user).where('email', isEqualTo: sender).get(),
                    builder: (c, futureSnap) {
                      if (futureSnap.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (futureSnap.hasError || !futureSnap.hasData) {
                        return const Center(
                          child: Text("No Reques"),
                        );
                      }

                      /// qds -> {'email': "", mob....}
                      var user = futureSnap.data?.docs.firstWhereOrNull((element) => element.get('email') == sender);
                      print(user?.data());
                      return FriendRowWidget(
                        isRequest: true,
                        name: user?.get('name'),
                        email: sender,
                      );
                    },
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
