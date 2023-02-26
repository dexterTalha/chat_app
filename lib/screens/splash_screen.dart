import 'package:flutter/material.dart';
import 'package:tabahi_chat_app/utils/my_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animDouble;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animDouble = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
      // reverseCurve: Curves.bounceIn,
    );
    _animOffset =
        Tween<Offset>(begin: Offset(-3, 0), end: Offset(3, 0)).animate(
      _animController,
    );
    _animController.repeat(reverse: true);
    // _animController.addListener(() {
    //   if (_animController.isCompleted) {
    //     _animController.reverse();
    //   }
    // });
    super.initState();
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
            FadeTransition(
              opacity: _animDouble,
              child: SlideTransition(
                position: _animOffset,
                child: const Card(
                  elevation: 20,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlutterLogo(size: 100),
                  ),
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
