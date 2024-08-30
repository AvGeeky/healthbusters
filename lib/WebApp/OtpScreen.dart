
import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/MobileApp/OtpScreen.dart';
import 'package:yourhealth/RegisterPage.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';

class OtpVerificationPageWeb extends StatefulWidget {
  String phoneNumber = '-1';
  String verificationId;
  OtpVerificationPageWeb(this.phoneNumber, this.verificationId, {super.key});

  @override
  _OtpVerificationPageWebState createState() => _OtpVerificationPageWebState();
}

class _OtpVerificationPageWebState extends State<OtpVerificationPageWeb> {
  final int otpLength = 6;
  final Auth _auth = Auth(); // Create an instance of Auth
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < otpLength; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

   // Method to handle SMS code verification
  void _signInWithPhoneNumber() {
    String otp = controllers.map((controller) => controller.text).join();
    if (otp.length == otpLength) {
      _auth.signInWithSmsCode(verificationId! , otp).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully signed in!')),
        );
        // Navigate to Home Screen or another page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed: ${e.message}')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
         fit: StackFit
            .expand, 
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        // Handle back navigation
                        // Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    "OTP sent to ${widget.phoneNumber}", // Replace with dynamic number
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter the OTP for verification", // Replace with dynamic number
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        otpLength,
                        (index) =>
                            OtpVerificationPageNMobile(widget.phoneNumber, widget.verificationId)
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
                        // Handle OTP verification
                      if (!isLoginPage) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                      }                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                      ),
                      child: const Text(
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
