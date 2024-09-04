import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveAdminDashboard.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveDoctorDashboard.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveLoginScreen.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveUserDashboard.dart';
import 'package:yourhealth/auth.dart';

Future<List<String>> checkUserRoles(String? userId) async {
  List<String> roles = [];

  try {
    // Check if the user is an Admin
    DocumentSnapshot adminDoc =
        await FirebaseFirestore.instance.collection('admins').doc(userId).get();
    if (adminDoc.exists) {
      roles.add("admin");
    }

    // Check if the user is a Doctor
    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(userId)
        .get();
    if (doctorDoc.exists) {
      roles.add("doctor");
    }

    // Check if the user is a regular User
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      roles.add("user");
    }
  } catch (e) {
    print('Error checking roles: $e');
  }

  return roles;
}

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
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
          // User is logged in, now check their roles
          return FutureBuilder<List<String>>(
            future: checkUserRoles(Auth().getCurrentUser()?.uid),
            builder: (context, rolesSnapshot) {
              if (rolesSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (rolesSnapshot.hasError ||
                  !rolesSnapshot.hasData ||
                  rolesSnapshot.data!.isEmpty) {
                // If there was an error or no roles were found
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('User roles not found. Please log in again.')),
                // );
                return const ResponsiveLoginScreen();
              }

              // If the user has multiple roles, ask them to choose one
              if (rolesSnapshot.data!.length > 1) {
                return _buildRoleSelectionDialog(context, rolesSnapshot.data!);
              }

              // If the user has only one role, directly navigate
              switch (rolesSnapshot.data!.first) {
                case "admin":
                  print("Entering the admin dashboard");
                  return const Responsiveadmindashboard();
                case "doctor":
                  print("Entering the doctor dashboard");
                  return const Responsivedoctordashboard();
                case "user":
                  print("Entering the user dashboard");
                  return Responsiveuserdashboard();
                default:
                  return const ResponsiveLoginScreen();
              }
            },
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

  Widget _buildRoleSelectionDialog(BuildContext context, List<String> roles) {
    return MaterialApp(
      home: Scaffold(
        body: AlertDialog(
          title: const Text('Select Account Type'),
          content: SingleChildScrollView(
            child: ListBody(
              children: roles.map((role) {
                return ListTile(
                  title: Text(role),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          switch (role) {
                            case "admin":
                              return const Responsiveadmindashboard();
                            case "doctor":
                              return const Responsivedoctordashboard();
                            case "user":
                              return Responsiveuserdashboard();
                            default:
                              return const ResponsiveLoginScreen();
                          }
                        },
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
