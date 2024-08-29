import 'package:flutter/material.dart';
import 'package:yourhealth/colorPallete.dart';

class LoginScreenWeb extends StatefulWidget {
  const LoginScreenWeb({super.key});

  @override
  _LoginScreenWebState createState() => _LoginScreenWebState();
}

class _LoginScreenWebState extends State<LoginScreenWeb> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+1'; // Default country code

  // List of country codes
  final List<String> _countryCodes = ['+1', '+44', '+91', '+33', '+81'];

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
                  _selectedCountryCode = code;
                });
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          }).toList(),
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                                          _selectedCountryCode,
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
                                      controller: _phoneController,
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
                            // navigate to register page
                            print("Entering register page");
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Create an account",
                              style: TextStyle(
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
                            // Handle OTP send logic here
                            print(
                                'Send OTP to $_selectedCountryCode${_phoneController.text}');
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
                Positioned(
                  top: 50.0,
                  right: 20.0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      // Handle back navigation
                      Navigator.pop(context);
                    },
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
