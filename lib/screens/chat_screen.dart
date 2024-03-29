import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/components/my_text_form_field.dart';
import 'package:tabahi_chat_app/controller/home_controller.dart';
import 'package:tabahi_chat_app/models/user_model.dart';
import 'package:tabahi_chat_app/utils/block_enum.dart';
import 'package:tabahi_chat_app/utils/constants.dart';

class ChatScreen extends StatefulWidget {
  final UserModel friend;
  const ChatScreen({super.key, required this.friend});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final HomeController _homeController = HomeController.instance;
  late CollectionReference collection;
  final TextEditingController _msgController = TextEditingController();
  Rx<BlockStatus> blockStatus = BlockStatus.NONE.obs;
  RxBool isLoading = false.obs;
  @override
  void initState() {
    // set to whom I'm talking to
    collection = _homeController.db.collection(AppConstant.chats);
    _homeController.updateIssen(widget.friend.uid ?? "");
    _homeController.setChattingTo(widget.friend.email ?? "");
    isLoading(true);
    _homeController.getBlockStatus(widget.friend).then((value) {
      blockStatus(value);
      isLoading(false);
    });
    super.initState();
  }
  //Yx0D6unKwngRHcpUFGoLPqolLon2
  //Chats-> MyUid -> friendUid -> issender

  @override
  void dispose() {
    _homeController.deleteChattingTo();
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.adaptive.arrow_back),
                    const SizedBox(width: 5),
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: FlutterLogo(
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Text(widget.friend.name ?? "")
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 0) {
                // check if blocked if true then unblock otherwise block
                await _homeController.blockUser(widget.friend);

                blockStatus(await _homeController.getBlockStatus(widget.friend));
              }
            },
            itemBuilder: (_) {
              String title = "Block";
              if (blockStatus.value == BlockStatus.FRIENDBLOCKED) title = "Unblock";
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text("$title ${widget.friend.name}"),
                ),
              ];
            },
          )
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   height: 50,
      //   color: Colors.blue,
      //   child: Row(
      //     children: [
      //       const Expanded(child: MyTextField()),
      //       IconButton(
      //         onPressed: () {},
      //         icon: const Icon(Icons.send),
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Obx(
            () => Visibility(
              visible: isLoading.value,
              replacement: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: StreamBuilder(
                        stream: collection.doc(_homeController.currentUser?.uid).collection(widget.friend.uid ?? "").orderBy('timestamp', descending: true).snapshots(),
                        builder: (context, snap) {
                          return ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: snap.data?.docs.length ?? 0,
                            itemBuilder: (_, index) {
                              Map<String, dynamic> data = snap.data?.docs[index].data() ?? {};
                              _homeController.updateIssen(widget.friend.uid ?? "");
                              String msg = data['msg'] ?? "";
                              bool isSender = data['issender'] ?? false;
                              return Text(
                                msg,
                                textAlign: isSender ? TextAlign.end : TextAlign.start,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: blockStatus.value != BlockStatus.FRIENDBLOCKED,
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                maxLines: 3,
                                controller: _msgController,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await _homeController.sendMessage(friendUid: widget.friend.uid ?? "", msg: _msgController.text.trim(), status: blockStatus.value);
                                _msgController.text = "";
                              },
                              icon: const Icon(Icons.send),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}
