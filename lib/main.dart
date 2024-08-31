import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yourhealth/FirebaseStorage.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveLoginScreen.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveUserDashboard.dart';
import 'package:yourhealth/WebApp/UserDashboardWeb.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Map<String, dynamic>? userData;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  userData = await getUserData(userId);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasData) {
          // User is logged in
          return MaterialApp(
            home: Responsiveuserdashboard(),
          );
        } else {
          // User is not logged in
          return const MaterialApp(
            home: ResponsiveLoginScreen(),
          );
        }
      },
    );
  }
}
