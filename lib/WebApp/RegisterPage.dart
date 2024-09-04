import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveAdminDashboard.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveDoctorDashboard.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveRegisterScreen.dart';
import 'package:yourhealth/ResponsizeLayouts/ResponsiveUserDashboard.dart';
import 'package:yourhealth/WebApp/UserDashboardWeb.dart';
import 'package:yourhealth/auth.dart';
import 'package:yourhealth/colorPallete.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController phoneemailController = TextEditingController();
String? selectedGender;
DateTime? selectedDate;

Future<void> submitForm(BuildContext context, String userRole) async {
  
  if (userRole == "User") {
    if (nameController.text.isEmpty ||
        phoneemailController.text.isEmpty ||
        selectedGender == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }
  }else{
    if (nameController.text.isEmpty ||
        phoneemailController.text.isEmpty ||
        selectedGender == null
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }
  }

  try {
    // Save user details to Firestore
    if (userRole == "Admin") {
      await FirebaseFirestore.instance.collection('admins').doc(userId).set({
        'name': nameController.text,
        'email': phoneemailController.text,
        'gender': selectedGender,
        'status': "pending"
      });

      requestAccess(userRole);
      
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Responsiveadmindashboard(),
          ));
    } else if (userRole == "Doctor") {
      await FirebaseFirestore.instance.collection('doctors').doc(userId).set({
        'name': nameController.text,
        'email': phoneemailController.text,
        'gender': selectedGender,
        'status': "pending"
      });

      requestAccess(userRole);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Responsivedoctordashboard(),
      ));
    } else {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': nameController.text,
        'email': phoneemailController.text,
        'gender': selectedGender,
        'files': []
      });

      // Upload files to Firebase Storage and get download URLs
      List<String> fileUrls = [];
      for (var file in selectedFiles) {
        String fileName = file.name;
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('userDetails/$userId/$fileName');

        UploadTask uploadTask = storageRef.putData(file.bytes!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        fileUrls.add(downloadUrl);
      }

      // Update Firestore document with the file URLs
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'files': fileUrls,
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Registration successful')),
      // );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Responsiveuserdashboard(),
      ));
    }
  } catch (e) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Failed to register: ${e.toString()}')),
    // );
  }
}

class RegisterScreenWeb extends StatefulWidget {
  late String userRole;
  RegisterScreenWeb(this.userRole, {super.key});

  @override
  State<RegisterScreenWeb> createState() => _RegisterScreenWebState();
}

class _RegisterScreenWebState extends State<RegisterScreenWeb> {
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.files);
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('${result.files.length} file(s) selected')),
      // );
    }
  }

  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('REGISTER'),
        backgroundColor: primaryBlue,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.2, // 20% from the top
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
                    children: [
                      // First Row: Input Fields and File Upload Box
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name, Email, Gender, and DOB Fields
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    hintText: 'Enter your full name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: phoneemailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter your email address',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: selectedGender,
                                  decoration: const InputDecoration(
                                    labelText: 'Gender',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Male', child: Text('Male')),
                                    DropdownMenuItem(
                                        value: 'Female', child: Text('Female')),
                                    DropdownMenuItem(
                                        value: 'Other', child: Text('Other')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                widget.userRole == "User"
                                    ? InkWell(
                                        onTap: _selectDate,
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                            labelText: 'Date of Birth',
                                            border: OutlineInputBorder(),
                                          ),
                                          child: Text(
                                            selectedDate == null
                                                ? 'Select your date of birth'
                                                : DateFormat('yyyy-MM-dd')
                                                    .format(selectedDate!),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // File Upload Box
                          widget.userRole == "User"
                              ? Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: _pickFiles,
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          selectedFiles.isEmpty
                                              ? 'Tap to upload files'
                                              : 'Files Selected: ${selectedFiles.length}',
                                          style: const TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Second Row: List of Uploaded Files

                      if (selectedFiles.isNotEmpty && widget.userRole == "User")
                        SizedBox(
                          height:
                              200, // Adjust height based on your design needs
                          child: ListView.builder(
                            itemCount: selectedFiles.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.insert_drive_file),
                                title: Text(selectedFiles[index].name),
                                subtitle: Text(
                                    '${(selectedFiles[index].size / 1024).toStringAsFixed(2)} KB'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.red),
                                  onPressed: () => _removeFile(index),
                                ),
                              );
                            },
                          ),
                        ),
                      Center(
                        child: SizedBox(
                          width: 250,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () =>
                                submitForm(context, widget.userRole),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double getLoginBoxWidth(BuildContext context) {
    return 500;
  }
}
