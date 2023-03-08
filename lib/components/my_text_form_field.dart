import 'package:flutter/material.dart';

import '../utils/my_theme.dart';

class MyTextField extends StatelessWidget {
  final String? hintText;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final TextEditingController? controller;
  const MyTextField(
      {super.key,
      this.hintText,
      this.borderRadius,
      this.fillColor,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: borderRadius ??
                const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
          ),
          filled: true,
          fillColor: fillColor ?? MyTheme.primaryContainerLight,
        ),
      ),
    );
  }
}
