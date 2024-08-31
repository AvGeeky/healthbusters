import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';

class ResponsiveLoginScreen extends StatefulWidget {
  const ResponsiveLoginScreen({super.key});

  @override
  ResponsiveLoginScreenState createState() => ResponsiveLoginScreenState();
}

class ResponsiveLoginScreenState extends State<ResponsiveLoginScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {}); // Rebuild the layout when the screen size changes
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Layout for desktop
          return const LoginScreenWeb();
        } else {
          // Layout for mobile
          return const LoginScreenMobile();
        }
      },
    );
  }
}