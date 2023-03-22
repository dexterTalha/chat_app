import 'package:flutter/material.dart';

class RequestFragment extends StatefulWidget {
  const RequestFragment({super.key});

  @override
  State<RequestFragment> createState() => _RequestFragmentState();
}

class _RequestFragmentState extends State<RequestFragment> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Requests"),
    );
  }
}
