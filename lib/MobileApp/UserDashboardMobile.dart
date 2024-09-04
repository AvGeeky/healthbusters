import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yourhealth/FirebaseStorage.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveUserDashboard.dart';
import 'package:yourhealth/WebApp/UserDashboardWeb.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';

class UserdashboardMobile extends StatefulWidget {
  const UserdashboardMobile({super.key});

  @override
  State<UserdashboardMobile> createState() => _UserdashboardMobileState();
}

class _UserdashboardMobileState extends State<UserdashboardMobile>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  late AnimationController _fadeanimationController;
  late Animation<double> _iconFadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isWebViewReady = true;
      });
    });
    _fadeanimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _iconFadeAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(
            parent: _fadeanimationController, curve: Curves.bounceOut));

    userDataFuture = getUserData(userId);
    _fadeanimationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
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
        margin: const EdgeInsets.only(
          top: 50,
          left: 20,
          right: 20,
        ),
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
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: primaryBlue,
                            ),
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
                      child:ElevatedButton(
                        onPressed: redirectToUrl,
                        child: Text('Open Booking Page'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
                animation: _iconFadeAnimation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(2),
                    width: _iconFadeAnimation.value *
                        MediaQuery.of(context).size.width,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
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
                  );
                }),
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
              margin: const EdgeInsets.all(1),
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        color: isHovered ? Colors.white : primaryBlue,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (title == 'Logout') {
                            Auth().signOut();
                            print("signing out");
                          }
                        },
                        icon: Icon(
                          icon,
                          color: isHovered ? primaryBlue : Colors.white,
                        ),
                      ),
                    ),
                    Text(title,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
