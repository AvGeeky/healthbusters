import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/MobileApp/OtpScreen.dart';
import 'package:yourhealth/MobileApp/RegisterPage.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveAdminDashboard.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveDoctorDashboard.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveRegisterScreen.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveUserDashboard.dart';
import 'package:yourhealth/animatedWidgets.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';

final int otpLength = 6;
final List<TextEditingController> controllers = [];
final List<FocusNode> focusNodes = [];
String phoneNumber = '1';

class OtpVerificationPageWeb extends StatefulWidget {
  String phoneNumber = '1';
  String verificationId;
  OtpVerificationPageWeb(this.phoneNumber, this.verificationId, {super.key});
  @override
  _OtpVerificationPageWebState createState() => _OtpVerificationPageWebState();
}

class _OtpVerificationPageWebState extends State<OtpVerificationPageWeb> {
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
  void signInWithPhoneNumber(
      BuildContext context, String verificationId) async {
    String otp = controllers.map((controller) => controller.text).join();
    if (otp.length == otpLength) {
      try {
        // Create PhoneAuthCredential with the verification ID and SMS code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        );

        // Sign in the user with the credential
        UserCredential userCredential = await auth.signInWithCredential(credential);

        // After signing in, check if the user is new or existing
        // ignore: use_build_context_synchronously
        setState(() {
          isLoading = false;
        });
        bool accountExists = await doesAccountExist(currentUser!.uid, selectedRole!);

        if (accountExists) {
          print("${selectedRole} Account exists");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ResponsiveRegisterScreen(selectedRole!);
            }),
          );
        }
        
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Sign-in failed: ${e.toString()}')),
        // );
      }
    } else {
        setState(() {
          isLoading = false;
        });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please enter the full OTP')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('OTP VERIFICATION'),
        backgroundColor: primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Close button action
            },
          ),
        ],
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // 20% from the top
            left: MediaQuery.of(context).size.width / 2 -
                getLoginBoxWidth(context) / 2 -
                200, // 10% from the left
            child: Image.asset(
              'assets/illustrations/doctor1.png',
              height: MediaQuery.of(context).size.height *
                  0.4, // 40% of screen height
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              width: getLoginBoxWidth(context),
              height: getLoginBoxHeight(context),
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
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 5),
                  const Divider(),
                  const Align(
                    alignment: Alignment.topRight,
                    child: RotatingCancelButton()
                  ),
                  Text(
                    "OTP sent to ${phoneNumber}", // Replace with dynamic number
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter the OTP for verification", // Replace with dynamic number
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
                      const Text("Don't receive OTP?"),
                      const SizedBox(
                        width: 5,
                      ),
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
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           isLoginPage ? const HomeScreen() : const ResponsiveRegisterScreen()));

                        // Handle OTP verification
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
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
