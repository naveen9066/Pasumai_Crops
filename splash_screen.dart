import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart'; // or wherever your login/registration page is

class SplashScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange; // ✅ Accept the function

  const SplashScreen({super.key, required this.onLocaleChange});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait for 0.5 seconds then navigate
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginPage(onLocaleChange: widget.onLocaleChange),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Or any branding color
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200, // You can adjust the size
          height: 200,
        ),
      ),
    );
  }
}
