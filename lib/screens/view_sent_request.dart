import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/friend_row_widget.dart';
import '../utils/constants.dart';

class ViewSentRequest extends StatefulWidget {
  const ViewSentRequest({super.key});

  @override
  State<ViewSentRequest> createState() => _ViewSentRequestState();
}

class _ViewSentRequestState extends State<ViewSentRequest> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sent Request"),
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: StreamBuilder(
          stream: _db.collection(AppConstant.request).where('sender', isEqualTo: _auth.currentUser?.email).where('accepted', isEqualTo: false).snapshots(),
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
                final sender = data?.get('receiver');
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
                        child: Text("No Request sent"),
                      );
                    }

                    /// qds -> {'email': "", mob....}
                    var user = futureSnap.data?.docs.firstWhereOrNull((element) => element.get('email') == sender);

                    return FriendRowWidget(
                      name: user?.get('name'),
                      email: sender,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
