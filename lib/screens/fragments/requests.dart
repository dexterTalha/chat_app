import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/components/friend_row_widget.dart';
import 'package:tabahi_chat_app/controller/home_controller.dart';
import 'package:tabahi_chat_app/screens/view_sent_request.dart';
import 'package:tabahi_chat_app/utils/constants.dart';

import '../../utils/my_theme.dart';

class RequestFragment extends StatefulWidget {
  const RequestFragment({super.key});

  @override
  State<RequestFragment> createState() => _RequestFragmentState();
}

class _RequestFragmentState extends State<RequestFragment> {
  final HomeController _controller = HomeController.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ViewSentRequest()));
            },
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
            stream:
                _controller.db.collection(AppConstant.request).where('receiver', isEqualTo: _controller.auth.currentUser?.email).where('accepted', isEqualTo: false).snapshots(),
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
                  QueryDocumentSnapshot<Map<String, dynamic>>? data = snap.data?.docs[index];

                  final sender = data?.get('sender');
                  final String id = data?.id ?? "";
                  return FutureBuilder(
                    future: _controller.db.collection(AppConstant.user).where('email', isEqualTo: sender).get(),
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

                      return FriendRowWidget(
                        isRequest: true,
                        name: user?.get('name'),
                        email: sender,
                        onReject: () {},
                        onAccept: () async {
                          bool result = await _controller.acceptRequest(id);
                          if (result) {
                            Get.snackbar("Request Accepted", "Friend request accepted from $sender", snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar("Error", "Friend request accepted Error from $sender", snackPosition: SnackPosition.BOTTOM);
                          }
                        },
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
