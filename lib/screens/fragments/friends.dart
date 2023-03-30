import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/controller/home_controller.dart';
import 'package:tabahi_chat_app/utils/my_theme.dart';

import '../../components/friend_row_widget.dart';
import '../../utils/constants.dart';

class FriendFragment extends StatefulWidget {
  const FriendFragment({super.key});

  @override
  State<FriendFragment> createState() => _FriendFragmentState();
}

class _FriendFragmentState extends State<FriendFragment> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HomeController _homeController = HomeController.instance;
  final GlobalKey<FormState> _dialogFormKey = GlobalKey();
  final TextEditingController _friendEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              _friendEmailController.text = "";
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text("Add Friend"),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: Form(
                        key: _dialogFormKey,
                        child: TextFormField(
                          controller: _friendEmailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            if (!value.isEmail) {
                              return 'Invalid Email';
                            }
                            if (_auth.currentUser?.email == value) {
                              return 'Cannot send request to your own email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          if (!_dialogFormKey.currentState!.validate()) {
                            return;
                          }

                          String email = _friendEmailController.text.trim();
                          //take email and search-> if exists add to request
                          bool result = await _homeController.sendFriendRequest(email);
                          if (result) {
                            Get.snackbar("Request Sent", "Friend request sent to $email", snackPosition: SnackPosition.BOTTOM);
                          }
                          if (_.mounted) Navigator.pop(_);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: MyTheme.primary),
                        child: const Center(
                          child: Text(
                            "Send Request",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: StreamBuilder(
            stream: _db.collection(AppConstant.friends).where('email', isEqualTo: _homeController.auth.currentUser?.email).snapshots(),
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

              return ListView.builder(
                itemCount: snap.data?.size ?? 0,
                itemBuilder: (context, index) {
                  var data = snap.data?.docs[index];
                  String friend = data?.get('friend');
                  bool isBlocked = data?.get('isBlocked') ?? false;
                  return FutureBuilder(
                    future: _homeController.db.collection(AppConstant.user).where('email', isEqualTo: friend).get(),
                    builder: (c, futureSnap) {
                      if (futureSnap.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (futureSnap.hasError || !futureSnap.hasData) {
                        return const Center(
                          child: Text("No Request"),
                        );
                      }

                      /// qds -> {'email': "", mob....}
                      var user = futureSnap.data?.docs.firstWhereOrNull((element) => element.get('email') == friend);
                      return FriendRowWidget(
                        name: user?.get('name'),
                        email: user?.get('email'),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
