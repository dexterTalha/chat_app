import 'package:flutter/material.dart';
import 'package:tabahi_chat_app/components/my_text_form_field.dart';
import 'package:tabahi_chat_app/utils/my_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordHidden = true;
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            children: [
              Image.asset('assets/image/parcel.png'),
              const SizedBox(height: 20),
              const Text(
                "Login Here",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                hintText: "Enter user/email id",
                controller: _emailController,
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          isPasswordHidden = !isPasswordHidden;
                          setState(() {});

                          ///  condition ? true : false
                        },
                        child: Icon(isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    filled: true,
                    fillColor: MyTheme.primaryContainerLight,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    print("LOGIN");
                    print(_emailController.text);
                    _emailController.text = "";
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.primary,
                    elevation: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        "Login".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
