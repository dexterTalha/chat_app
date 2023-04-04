import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/controller/home_controller.dart';
import 'package:tabahi_chat_app/screens/fragments/chats.dart';
import 'package:tabahi_chat_app/screens/fragments/friends.dart';
import 'package:tabahi_chat_app/screens/fragments/requests.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _confirmDialog() async {
    switch (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('True or false'),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          );
        })) {
      case true:
        print('Confirmed');
        break;

      case false:
        print('Canceled');
        break;

      default:
        print('Canceled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          // IconButton(
          //   onPressed: () {
          //     FirebaseAuth.instance.signOut();
          //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
          //   },
          //   icon: const Icon(Icons.more_vert),
          // ),
          PopupMenuButton(
            icon: Icon(Icons.adaptive.more),
            onSelected: (index) {
              if (index == 0) {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Logout?'),
                      content: const Text('Do you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                          },
                          child: const Text("Yes"),
                        ),
                        if (Platform.isAndroid)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(_);
                            },
                            child: const Text('No'),
                          ),
                        if (Platform.isIOS)
                          TextButton(
                            onPressed: () {
                              Navigator.pop(_);
                            },
                            child: const Text("No"),
                          ),
                      ],
                    );
                  },
                );
              }
              if (index == 1) {
                print('change password');
              }
            },
            itemBuilder: (_) {
              return [
                const PopupMenuItem(
                  enabled: true,
                  value: 1,
                  child: Text("Change Password"),
                ),
                const PopupMenuItem(
                  enabled: true,
                  value: 0,
                  child: Text("Logout"),
                ),
              ];
            },
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                onTap: (index) {
                  _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.linear);
                },
                tabs: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.group),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Chats"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Requests"),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _tabController.animateTo(index);
                  },
                  children: const [
                    FriendFragment(),
                    ChatFragment(),
                    RequestFragment(),
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
