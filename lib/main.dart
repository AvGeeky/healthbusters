import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width > 780;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isWeb(context)
          ? const LoginScreenWeb()
          : const LoginScreenMobile(),
    );
  }
}
