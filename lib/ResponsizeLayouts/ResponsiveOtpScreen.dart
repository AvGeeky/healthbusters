import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/OtpScreen.dart';
import 'package:yourhealth/WebApp/OtpScreen.dart';

class Responsiveotpscreen extends StatefulWidget {
  String phoneNumber = '-1';
  String verificationId;

  Responsiveotpscreen(this.phoneNumber, this.verificationId,{super.key});
  
  @override
  ResponsiveotpscreenState createState() => ResponsiveotpscreenState();
}

class ResponsiveotpscreenState extends State<Responsiveotpscreen> with WidgetsBindingObserver {
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
          return OtpVerificationPageWeb(widget.phoneNumber,widget.verificationId);
        } else {
          // Layout for mobile
          return OtpVerificationPageNMobile(widget.phoneNumber,widget.verificationId);
        }
      },
    );
  }
}