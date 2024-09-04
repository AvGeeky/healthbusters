import 'package:flutter/material.dart';
// Explicit import for web support
import 'package:yourhealth/ResponsizeLayouts/ResponsiveOtpScreen.dart';
import 'package:yourhealth/WebApp/LoginScreen.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';

String verificationId = '0';

final TextEditingController phoneController = TextEditingController();

String? selectedRole;

class LoginScreenMobile extends StatefulWidget {
  const LoginScreenMobile({super.key});

  @override
  _LoginScreenMobileState createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends State<LoginScreenMobile>
    with SingleTickerProviderStateMixin {
  final Auth _auth = Auth();
  // List of country codes
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward(); // Start the animation immediately

    _animation = Tween<double>(begin: 200, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _verifyPhoneNumber() async {
    try {
      await _auth.signInWithPhoneNumber(
        selectedCountryCode + phoneController.text,
        (verificationId) {
          setState(() {
            isLoading = false;
          });
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
      setState(() {
        isLoading = false;
      });
      // Handle errors such as invalid phone number or network issues
      print('Failed to verify phone number: $e');
      // You can show a dialog or a Snackbar with the error message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to verify phone number: $e')),
      // );
    }
  }

  // Method to show country code picker
  void _showCountryCodePicker() {
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: countryCodes.map((code) {
            return Column(
              children: [
                ListTile(
                  title: Text('$code ${countryNames[code]}'),
                  onTap: () {
                    setState(() {
                      selectedCountryCode = code;
                    });
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  selected: code == selectedCountryCode ? true : false,
                  selectedColor: primaryBlue,
                ),
                const Divider(
                  height: 2,
                )
              ],
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
          AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  top: 20 + _animation.value * 0.8,
                  left: MediaQuery.of(context).size.width / 2 - 75,
                  child: Image.asset(
                    'assets/illustrations/doctor2.png',
                    height: 250,
                  ),
                );
              }),
          // Login Box
          AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  top: 230 + _animation.value,
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
                        Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Login As',
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedRole,
                                items: <String>['User', 'Doctor', 'Admin']
                                    .map((String role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRole = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a role';
                                  }
                                  return null;
                                },
                              ),
                              // ...
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Phone No',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              _isHovered = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _isHovered = false;
                            });
                          },
                          child: TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: _isHovered ? 'Phone Number' : null,
                              prefixIcon: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 45,
                                height: 50,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Colors.grey),
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets
                                        .zero, // Removes extra padding
                                  ),
                                  onPressed: _showCountryCodePicker,
                                  child: Center(
                                    child: Text(
                                      selectedCountryCode,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Enter your phone number',
                              contentPadding: const EdgeInsets.fromLTRB(
                                  12, 0, 12, 0), // Adjust the left padding
                            ),
                            keyboardType: TextInputType.phone,
                          ),
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
                              setState(() {
                                isLoading = true;
                              });
                              if (selectedRole != null) {
                                _verifyPhoneNumber();
                              }else{
                                setState((){
                                   isLoading = false;
                                  //  ScaffoldMessenger.of(context).showSnackBar(
                                  //     const SnackBar(content: Text('Please select a role'))
                                  //   );                  
                                 });
                                }
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
                                    'SEND OTP',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
