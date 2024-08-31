import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/MobileApp/RegisterPage.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';
import 'package:yourhealth/WebApp/RegisterPage.dart';

List<PlatformFile> selectedFiles = [];

class ResponsiveRegisterScreen extends StatefulWidget {
  const ResponsiveRegisterScreen({super.key});

  @override
  _ResponsiveRegisterScreenState createState() => _ResponsiveRegisterScreenState();
}

class _ResponsiveRegisterScreenState extends State<ResponsiveRegisterScreen> with WidgetsBindingObserver {
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
          return const RegisterScreenWeb();
        } else {
          // Layout for mobile
          return const RegisterScreenMobile();
        }
      },
    );
  }
}