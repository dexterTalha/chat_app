import 'package:flutter/material.dart';

import '../utils/my_theme.dart';

class MyTextField extends StatelessWidget {
  final String? hintText;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final bool isObscure;
  final Widget? suffixWidget;
  const MyTextField({super.key, this.isObscure = false, this.hintText, this.borderRadius, this.fillColor, this.controller, this.validator, this.inputType, this.suffixWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: isObscure,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: inputType,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          suffix: suffixWidget,
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
