import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yourhealth/FirebaseStorage.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveUserDashboard.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


  final String url = 'https://outlook.office365.com/owa/calendar/SIHHospital@ssn.edu.in/bookings/';

  Future<void> redirectToUrl() async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

class Userdashboardweb extends StatefulWidget {
  const Userdashboardweb({super.key});

  @override
  State<Userdashboardweb> createState() => _UserdashboardwebState();
}

late Future<Map<String, dynamic>?> userDataFuture;

bool isWebViewReady = false;

class _UserdashboardwebState extends State<Userdashboardweb>
    with TickerProviderStateMixin {
  bool isCollapsed = true;
  late AnimationController _animationController;
  late AnimationController _rotateanimationController;
  late AnimationController _fadeanimationController;
  late Animation<double> _widthAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _iconFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotateanimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeanimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _widthAnimation =
        Tween<double>(begin: 86.0, end: 200.0).animate(_animationController);

    _rotationAnimation = Tween<double>(
            begin: 0.0, end: 0.7853981633974483 * 2) // 45 degrees in radians
        .animate(CurvedAnimation(
            parent: _rotateanimationController, curve: Curves.easeInOut));

    _iconFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _fadeanimationController, curve: Curves.bounceOut));

    userDataFuture = getUserData(userId);
    _fadeanimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotateanimationController.dispose();
    _fadeanimationController.dispose();
    super.dispose();
  }

  void toggleSidebar() {
    setState(() {
      isCollapsed = !isCollapsed;
      if (isCollapsed) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        backgroundColor: primaryBlue,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _widthAnimation,
              builder: (context, child) {
                return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(20),
                    width: _widthAnimation.value,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: primaryBlue,
                    ),
                    child: Stack(
                      children: [
                        !isCollapsed
                            ? Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: _widthAnimation.value - 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white),
                                ),
                              )
                            : const SizedBox.shrink(),
                        AnimatedBuilder(
                            animation: _iconFadeAnimation,
                            builder: (context, child) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    _iconFadeAnimation.value,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: MouseRegion(
                                            onEnter: (_) {
                                              _rotateanimationController
                                                  .forward();
                                            },
                                            onExit: (_) {
                                              _rotateanimationController
                                                  .reverse();
                                            },
                                            child: isCollapsed
                                                ? IconButton(
                                                    icon: Icon(
                                                        isCollapsed
                                                            ? Icons.menu
                                                            : Icons.close,
                                                        color: Colors.white),
                                                    onPressed: toggleSidebar,
                                                  )
                                                : AnimatedBuilder(
                                                    animation:
                                                        _rotationAnimation,
                                                    builder: (context, child) {
                                                      return Transform.rotate(
                                                        angle:
                                                            _rotationAnimation
                                                                .value,
                                                        child: IconButton(
                                                          icon: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white),
                                                          onPressed:
                                                              toggleSidebar,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          )),
                                    ),
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: ListView(
                                        children: [
                                          _buildNavItem(Icons.calendar_today,
                                              "Appointment"),
                                          const SizedBox(height: 10),
                                          _buildNavItem(Icons.queue, "Queue"),
                                          const SizedBox(height: 10),
                                          _buildNavItem(Icons.logout, "Logout"),
                                          const SizedBox(height: 10),
                                          _buildNavItem(
                                              Icons.person, "Profile"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ));
              },
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Stack(children: [
                          Container(
                              margin: const EdgeInsets.only(top: 10, right: 10),
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: primaryBlue),
                              child: Center(
                                child: FutureBuilder<Map<String, dynamic>?>(
                                  future: userDataFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      final userName =
                                          snapshot.data?['name'] ?? 'Guest';
                                      return Center(
                                        child: Text(
                                          '$greeting $userName!',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Verdana',
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                          child: Text('Hello Guest!'));
                                    }
                                  },
                                ),
                              )),
                          Positioned(
                            top: -7,
                            left: -10,
                            child: Image.asset(
                              'assets/illustrations/doctor1.png',
                              height: 150,
                            ),
                          ),
                        ])),
                    const Center(
                      child: ElevatedButton(
                        onPressed: redirectToUrl,
                        child: Text('Open Booking Page'),
                      ),
                    ),
                  ],
                ),
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
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(3),
              height: 50,
              width: !isCollapsed ? 200 : 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isHovered
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : primaryBlue,
              ),
              child: TextButton.icon(
                label: isCollapsed
                    ? const SizedBox.shrink()
                    : Text(
                        title,
                        style: TextStyle(
                          color: isHovered ? primaryBlue : Colors.white,
                        ),
                      ),
                onPressed: () {
                  if (title == 'Logout') {
                    Auth().signOut();
                  }
                },
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
