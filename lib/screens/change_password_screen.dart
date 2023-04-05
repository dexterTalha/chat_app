import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/controller/login_controller.dart';

import '../components/my_text_form_field.dart';
import '../utils/my_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final LoginController _authController = Get.put(LoginController());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final RxBool isPassWordHidden = true.obs;
  final RxBool isNewPassWordHidden = true.obs;
  final RxBool isLoading = false.obs;

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change your password')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        height: double.maxFinite,
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Obx(
                () => MyTextField(
                  hintText: "Enter Password",
                  isObscure: isPassWordHidden.value,
                  controller: _passwordController,
                  suffixWidget: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        isPassWordHidden(!isPassWordHidden.value);
                      },
                      child: Icon(isPassWordHidden.value ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  // inputType: TextInputType.number,
                  validator: (st) {
                    if (st == null || st.isEmpty) {
                      return "This field is required";
                    }
                    if (st.length < 8) {
                      return "Password length should be minimum 8 characters";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => MyTextField(
                  hintText: "Enter Confirm Password",
                  isObscure: isNewPassWordHidden.value,
                  controller: _newPasswordController,
                  borderRadius: BorderRadius.circular(8),
                  // inputType: TextInputType.number,
                  suffixWidget: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        isNewPassWordHidden(!isNewPassWordHidden.value);
                      },
                      child: Icon(isNewPassWordHidden.value ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (st) {
                    if (st == null || st.isEmpty) {
                      return "This field is required";
                    }

                    if (_passwordController.text == st) {
                      return "New password cannot be same as old password";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => MyTextField(
                  hintText: "Enter Confirm Password",
                  isObscure: isNewPassWordHidden.value,
                  controller: _confPasswordController,
                  borderRadius: BorderRadius.circular(8),
                  // inputType: TextInputType.number,
                  suffixWidget: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        isNewPassWordHidden(!isNewPassWordHidden.value);
                      },
                      child: Icon(isNewPassWordHidden.value ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (st) {
                    if (st == null || st.isEmpty) {
                      return "This field is required";
                    }

                    if (_newPasswordController.text != st) {
                      return "Confirm Password do not match";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Visibility(
                  visible: isLoading.value,
                  replacement: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        String passWord = _passwordController.text;
                        String newPass = _newPasswordController.text;

                        isLoading(true);
                        String? result = await _authController.changePassword(context, passWord, newPass);
                        isLoading(false);

                        if (result != null) {
                          Get.snackbar("Error", result);
                        } else {
                          Get.snackbar("Success", "Password Changed Successfully");
                        }
                        _passwordController.text = "";
                        _newPasswordController.text = "";
                        _confPasswordController.text = "";
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyTheme.primary,
                        elevation: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            "Change Password".toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
