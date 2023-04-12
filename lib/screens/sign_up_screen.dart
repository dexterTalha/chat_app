import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabahi_chat_app/controller/login_controller.dart';

import '../components/my_text_form_field.dart';
import '../utils/my_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final LoginController _authController = LoginController.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    _authController.isSignUpPasswordHidden(true);
    if (_authController.currentUser.value != null) {
      _phoneController.text = _authController.currentUser.value?.phoneNumber ?? "";
      _nameController.text = _authController.currentUser.value?.displayName ?? "";
      _emailController.text = _authController.currentUser.value?.email ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/image/parcel.png'),
                MyTextField(
                  hintText: "Enter Name",
                  controller: _nameController,
                  borderRadius: BorderRadius.circular(8),
                  // inputType: TextInputType.number,
                  validator: (st) {
                    if (st == null || st.isEmpty) {
                      return "This field is required";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Enter Email",
                  controller: _emailController,
                  borderRadius: BorderRadius.circular(8),
                  // inputType: TextInputType.number,
                  validator: (st) {
                    if (st == null || st.isEmpty) {
                      return "This field is required";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Enter Phone Number",
                  controller: _phoneController,
                  borderRadius: BorderRadius.circular(8),
                  inputType: TextInputType.number,
                  validator: (st) {
                    if (st == null || st.isEmpty) {
                      return "This field is required";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Obx(
                  () => MyTextField(
                    hintText: "Enter Password",
                    isObscure: _authController.isSignUpPasswordHidden.value,
                    controller: _passwordController,

                    suffixWidget: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          _authController.isSignUpPasswordHidden(!_authController.isSignUpPasswordHidden.value);
                        },
                        child: Icon(_authController.isSignUpPasswordHidden.value ? Icons.visibility : Icons.visibility_off),
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
                    isObscure: _authController.isSignUpPasswordHidden.value,
                    controller: _confPasswordController,
                    borderRadius: BorderRadius.circular(8),
                    // inputType: TextInputType.number,
                    suffixWidget: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          _authController.isSignUpPasswordHidden(!_authController.isSignUpPasswordHidden.value);
                        },
                        child: Icon(_authController.isSignUpPasswordHidden.value ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (st) {
                      if (st == null || st.isEmpty) {
                        return "This field is required";
                      }

                      if (_passwordController.text != st) {
                        return "Confirm Password do not match";
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Visibility(
                    visible: _authController.isSignUpLoading.value,
                    replacement: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          String name = _nameController.text;
                          String email = _emailController.text;
                          String passWord = _passwordController.text;
                          String mobile = _phoneController.text;
                          bool result = await _authController.createUserWithEmailPassword(
                            name: name,
                            mobile: mobile,
                            email: email,
                            password: passWord,
                          );
                          if (result) {
                            Get.snackbar("User Registered", "", snackPosition: SnackPosition.BOTTOM);
                            if (context.mounted) Navigator.pop(context);
                          } else {
                            Get.snackbar("User Not Registered", "", snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.primary,
                          elevation: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              "Sign Up".toUpperCase(),
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
      ),
    );
  }
}
