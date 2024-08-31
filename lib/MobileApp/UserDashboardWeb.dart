import 'package:flutter/material.dart';
import 'package:yourhealth/FirebaseStorage.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';
import 'package:yourhealth/main.dart';

class UserdashboardMobile extends StatefulWidget {
  const UserdashboardMobile({super.key});

  @override
  State<UserdashboardMobile> createState() => _UserdashboardMobileState();
}

class _UserdashboardMobileState extends State<UserdashboardMobile>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        backgroundColor: primaryBlue,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20)),
                              color: primaryBlue,
                            ),
                            child: Center(
                              child: Text(
                                userData != null
                                    ? 'Hello ${userData?['name']}!'
                                    : 'Hello Guest!',
                                style: const TextStyle(
                                  fontSize: 50,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Verdana',
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -7,
                            left: -10,
                            child: Image.asset(
                              'assets/illustrations/doctor1.png',
                              height: 150,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Dashboard Content",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: primaryBlue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.calendar_today, "Appointment"),
                  _buildNavItem(Icons.queue, "Queue"),
                  _buildNavItem(Icons.logout, "Logout"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildNavItem(IconData icon, String title) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Align(
          alignment: Alignment.centerLeft,
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: isHovered
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : primaryBlue,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  icon,
                  color: isHovered ? primaryBlue : Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
