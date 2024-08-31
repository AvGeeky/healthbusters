import 'package:flutter/material.dart';
import 'package:yourhealth/FirebaseStorage.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';
import 'package:yourhealth/main.dart';

class Userdashboardweb extends StatefulWidget {
  const Userdashboardweb({super.key});

  @override
  State<Userdashboardweb> createState() => _UserdashboardwebState();
}

class _UserdashboardwebState extends State<Userdashboardweb>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _widthAnimation =
          Tween<double>(begin: 86.0, end: 200.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                    borderRadius: BorderRadius.circular(20),
                    color: primaryBlue,
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: toggleSidebar,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            _buildNavItem(Icons.calendar_today, "Appointment"),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildNavItem(Icons.queue, "Queue"),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildNavItem(Icons.logout, "Logout"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
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
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: primaryBlue),
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
                                    fontFamily: 'Verdana'
                                  ),
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
                      child: Text(
                        "Dashboard Content",
                        style: TextStyle(fontSize: 24),
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
              margin: const EdgeInsets.all(3),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isHovered
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : primaryBlue,
              ),
              child: TextButton.icon(
                label: isCollapsed
                    ? const SizedBox(
                        width: 0,
                      )
                    : Text(
                        title,
                        style: TextStyle(
                          color: isHovered ? primaryBlue : Colors.white,
                        ),
                      ),
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
