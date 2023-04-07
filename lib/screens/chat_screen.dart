import 'package:flutter/material.dart';
import 'package:tabahi_chat_app/components/my_text_form_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
              const Text("Name")
            ],
          ),
        ),
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
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: 4,
                    itemBuilder: (_, index) {
                      return Text("text $index");
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const Expanded(
                      child: MyTextField(
                        maxLines: 3,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
