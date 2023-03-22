import 'package:flutter/material.dart';

class FriendFragment extends StatefulWidget {
  const FriendFragment({super.key});

  @override
  State<FriendFragment> createState() => _FriendFragmentState();
}

class _FriendFragmentState extends State<FriendFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Friends"),
    );
  }
}
