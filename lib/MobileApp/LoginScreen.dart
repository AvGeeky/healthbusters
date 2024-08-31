import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/OtpScreen.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveOtpScreen.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';
import 'package:yourhealth/WebApp/OtpScreen.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';
import 'package:yourhealth/main.dart';

String verificationId = '0';

final TextEditingController phoneController = TextEditingController();

class LoginScreenMobile extends StatefulWidget {
  const LoginScreenMobile({super.key});

  @override
  _LoginScreenMobileState createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends State<LoginScreenMobile> {
  final Auth _auth = Auth();
  // List of country codes
  final List<String> _countryCodes = ['+1', '+44', '+91', '+33', '+81'];

  void _verifyPhoneNumber() async {
    try {
      await _auth.signInWithPhoneNumber(
        selectedCountryCode + phoneController.text,
        (verificationId) {
          print("Routing to Otp screen");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Responsiveotpscreen(
                      selectedCountryCode + phoneController.text,
                      verificationId)));
        },
      );
    } catch (e) {
      // Handle errors such as invalid phone number or network issues
      print('Failed to verify phone number: $e');
      // You can show a dialog or a Snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify phone number: $e')),
      );
    }
  }

  // Method to show country code picker
  void _showCountryCodePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: _countryCodes.map((code) {
            return ListTile(
              title: Text(code),
              onTap: () {
                setState(() {
                  selectedCountryCode = code;
                });
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      appBar: AppBar(
        title: const Text('LOGIN'),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Positioned image at the top
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 2 - 75,
            child: Image.asset(
              'assets/illustrations/doctor2.png',
              height: 250,
            ),
          ),
          // Login Box
          Positioned(
            top: 230,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height - 170,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
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
                  const Text(
                    'Phone No',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      // Country Code Button and Phone Number Field in one container
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              // Country Code Button
                              GestureDetector(
                                onTap: _showCountryCodePicker,
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        right: BorderSide(color: Colors.grey),
                                      )),
                                  child: Center(
                                    child: Text(
                                      selectedCountryCode,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              // Phone Number TextField
                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  decoration: const InputDecoration(
                                    border: InputBorder
                                        .none, // Remove the TextField border
                                    hintText: 'Enter your phone number',
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        //For testing purpose ignoring the verification
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return Responsiveotpscreen(
                        //           selectedCountryCode + phoneController.text,
                        //           "jljlj");
                        // }));
                        //A router to the OTP verification page
                        _verifyPhoneNumber();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                      ),
                      child: const Text(
                        'SEND OTP',
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
