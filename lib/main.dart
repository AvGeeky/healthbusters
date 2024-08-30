import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';
import 'package:yourhealth/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

bool isWeb(BuildContext context) {
  return MediaQuery.of(context).size.width > 780;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isWeb(context) ? const LoginScreenWeb() : const LoginScreenMobile(),
    );
  }
}
