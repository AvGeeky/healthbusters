import 'package:flutter/material.dart';
import 'package:yourhealth/MobileApp/LoginScreen.dart';
import 'package:yourhealth/MobileApp/OtpScreen.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';

String selectedCountryCode = '+91'; // Default country code

  // To get the width of the login box
double getLoginBoxWidth(BuildContext context) {
  double loginBoxWidth = MediaQuery.of(context).size.width;
  if (loginBoxWidth < 480) {
    loginBoxWidth = loginBoxWidth * 0.8;
  } else if (loginBoxWidth < 780) {
    loginBoxWidth = loginBoxWidth * 0.6;
  } else {
    loginBoxWidth = 470;
  }
  return loginBoxWidth;
}
// To get the height of the login box
double getLoginBoxHeight(BuildContext context) {
  double loginBoxHeight = MediaQuery.of(context).size.height;
  if (loginBoxHeight < 480) {
    loginBoxHeight = loginBoxHeight * 0.8;
  } else if (loginBoxHeight < 780) {
    loginBoxHeight = loginBoxHeight * 0.6;
  } else {
    loginBoxHeight = 450;
  }
  return loginBoxHeight;
}

class LoginScreenWeb extends StatefulWidget {
  const LoginScreenWeb({super.key});

  @override
  _LoginScreenWebState createState() => _LoginScreenWebState();
}

class _LoginScreenWebState extends State<LoginScreenWeb> {
  final Auth _auth = Auth();

  // List of country codes
  final List<String> _countryCodes = ['+1', '+44', '+91', '+33', '+81'];

  void _verifyPhoneNumber() async {
      try {
        await _auth.signInWithPhoneNumber(
          selectedCountryCode + phoneController.text,
          (verificationId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationPageNMobile(
                    selectedCountryCode + phoneController.text ,verificationId),
              ),
            );
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
      appBar: AppBar(
        title: Text(isLoginPage ? 'LOGIN' : 'REGISTER'),
        backgroundColor: primaryBlue,
      ),
      body: Stack(
        fit: StackFit
            .expand, // Ensures the background image covers the entire screen
        children: [
          // Positioned image
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
          // Login Box
          Center(
            child: Stack(
              children: [
                Container(
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                           alignment: Alignment.center,
                           child: Text(
                             isLoginPage ? 'LOGIN' : 'REGISTER',
                             style: const TextStyle(
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
                                            right:
                                                BorderSide(color: Colors.grey),
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
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12),
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
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            // navigate to register page or login
                            isLoginPage = !isLoginPage ;
                            setState(() {
                              
                            });
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              isLoginPage ? "Create an account" : "Already have an account?",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: primaryBlue,
                                  color: primaryBlue,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                             _verifyPhoneNumber();
                              //A router to the OTP verification page
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
