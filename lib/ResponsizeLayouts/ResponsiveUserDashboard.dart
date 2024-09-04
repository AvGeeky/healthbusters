import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/UserDashboardMobile.dart';
import 'package:yourhealth/WebApp/UserDashboardWeb.dart';


String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

class Responsiveuserdashboard extends StatefulWidget {

  Responsiveuserdashboard({super.key});
  
  @override
  ResponsiveuserdashboardState createState() => ResponsiveuserdashboardState();
}

class ResponsiveuserdashboardState extends State<Responsiveuserdashboard> with WidgetsBindingObserver {
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
          return const Userdashboardweb();
        } else {
          // Layout for mobile
          return const UserdashboardMobile();
        }
      },
    );
  }
}