import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tabahi_chat_app/screens/login_screen.dart';
import 'package:tabahi_chat_app/utils/my_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animDouble;

  @override
  void initState() {
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animDouble = Tween<double>(begin: 0.5, end: 1).animate(_animController);

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });

    _animController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> printName() async {
    await Future.delayed(const Duration(seconds: 5));
    print("Hasnain Ansari");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MyTheme.primary,
              MyTheme.blueLight,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animDouble,
              child: const Card(
                elevation: 20,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FlutterLogo(size: 100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "TABAHI CHAT APP",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
