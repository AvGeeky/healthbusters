import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/RegisterPage.dart';
import 'package:yourhealth/colorPallete.dart';
import 'package:yourhealth/auth.dart';

class OtpVerificationPageNMobile extends StatefulWidget {
  String phoneNumber = '-1';
  String verificationId;
  OtpVerificationPageNMobile(this.phoneNumber, this.verificationId, {super.key});

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
  final Auth _auth = Auth(); // Create an instance of Auth
  final int otpLength = 6;
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
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  Text(
                    "OTP sent to ${widget.phoneNumber}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter the OTP for verification",
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
                      onPressed: _signInWithPhoneNumber,
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
