import 'package:flutter/material.dart';
import 'package:tabahi_chat_app/utils/my_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
          children: const [
            Card(
              elevation: 20,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: FlutterLogo(size: 100),
              ),
            ),
            SizedBox(height: 20),
            Text(
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
