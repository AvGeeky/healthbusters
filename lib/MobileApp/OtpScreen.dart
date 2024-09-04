import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveAdminDashboard.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveDoctorDashboard.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveRegisterScreen.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveUserDashboard.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';
import 'package:yourhealth/WebApp/OtpScreen.dart';
import 'package:yourhealth/WebApp/RegisterPage.dart';
import 'package:yourhealth/colorPallete.dart';
import 'package:yourhealth/auth.dart';

void handleUserNavigation(BuildContext context, UserCredential userCredential, String selectedRole) async {
  if (userCredential == null) {
    print("UserCredential is null");
    return;
  }

  if (selectedRole == null || selectedRole.isEmpty) {
    print("Selected role is null or empty");
    return;
  }

  if (context == null) {
    print("Context is null");
    return;
  }

  String uid = userCredential.user?.uid ?? '';

  if (uid.isEmpty) {
    print("User ID is null or empty");
    return;
  }


  bool accountExists = await doesAccountExist(uid, selectedRole);

  if (accountExists) {
    print("${selectedRole} Account exists");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      if (selectedRole == "Admin") {
        return const Responsiveadmindashboard();
      } else if (selectedRole == "Doctor") {
        return const Responsivedoctordashboard();
      } else {
        return Responsiveuserdashboard();
      }
    }));
  } else {
    print("Entering the registration page for registering $selectedRole");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ResponsiveRegisterScreen(selectedRole);
      }),
    );
  }
}

class OtpVerificationPageNMobile extends StatefulWidget {
  String phoneNumber = '-1';
  String verificationId;
  OtpVerificationPageNMobile(this.phoneNumber, this.verificationId,
      {super.key});

  // function to generate the otp textfields
  Widget buildOtpField(int index, BuildContext context,
      List<TextEditingController> controllers, List<FocusNode> focusNodes) {
    int otplength = 6;
    return SizedBox(
      width: 40,
      height: 40,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < otplength - 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  _OtpVerificationPageNMobileState createState() =>
      _OtpVerificationPageNMobileState();
}

class _OtpVerificationPageNMobileState
    extends State<OtpVerificationPageNMobile> {
  @override
  void initState() {
    phoneNumber = widget.phoneNumber;
    verificationId = widget.verificationId;
    super.initState();
    for (int i = 0; i < otpLength; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

// Method to handle SMS code verification
void signInWithPhoneNumber(BuildContext context, String verificationId) async {
  String otp = controllers.map((controller) => controller.text).join();
  if (otp.length == otpLength) {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    try {
      // Create PhoneAuthCredential with the verification ID and SMS code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Sign in the user with the credential
      UserCredential userCredential = await auth.signInWithCredential(credential);

      // Check if the user is new or existing
      bool accountExists = await doesAccountExist(userCredential.user!.uid, selectedRole!);

      if (mounted) {
        // Update loading state before navigating
        setState(() {
          isLoading = false;
        });

        if (accountExists) {
          print("${selectedRole} Account exists");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            if (selectedRole == "User") {
              return Responsiveuserdashboard();
            } else if (selectedRole == "Doctor") {
              return const Responsivedoctordashboard();
            } else {
              return const Responsiveadmindashboard();
            }
          }));
        } else {
          print("Entering the registration page for registering $selectedRole");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return ResponsiveRegisterScreen(selectedRole!);
            }),
          );
        }
      }

    } catch (e) {
      if (mounted) {
        // Update loading state on error
        setState(() {
          isLoading = false;
        });

        // Use a post-frame callback to ensure that context is valid
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-in failed: ${e.toString()}')),
          );
        });
      }
    }
  } else {
    if (mounted) {
      // Update loading state if OTP length is invalid
      setState(() {
        isLoading = false;
      });

      // Use a post-frame callback to ensure that context is valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the full OTP')),
        );
      });
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      appBar: AppBar(
        title: const Text('OTP VERIFICATION'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Close button action
              Navigator.pop(context);
            },
          ),
        ],
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 2 - 75,
            child: Image.asset(
              'assets/illustrations/doctor2.png',
              height: 250,
            ),
          ),
          Positioned(
            top: 230,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "OTP VERIFICATION",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  Text(
                    "OTP sent to ${phoneNumber}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter the OTP for verification",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        otpLength,
                        (index) => OtpVerificationPageNMobile(
                                phoneNumber, verificationId)
                            .buildOtpField(
                                index, context, controllers, focusNodes)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Didn't receive OTP?"),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          // Handle resend OTP
                        },
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        //For testing ignoring signing in
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           isLoginPage ? const HomeScreen() : const ResponsiveRegisterScreen()));
                        setState(() {
                          isLoading = true;
                        });
                        signInWithPhoneNumber(context, verificationId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Verify & Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
