import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<Map<String, dynamic>?> getUserData(String userId) async {
  try {
    // Get the user document from Firestore
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (!userDoc.exists) {
      // If the document does not exist, return null
      return null;
    }

    // Get the user data as a Map
    Map<String, dynamic> userData = userDoc.data()!;

    // Initialize fields for user details
    String? name = userData['name'];
    String? email = userData['email'];
    String? gender = userData['gender'];
    DateTime? dateOfBirth = userData['dateOfBirth']?.toDate();

    // Prepare a result map with user details
    Map<String, dynamic> result = {
      'name': name,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
    };

    // If files field is present, fetch the files' download URLs
    if (userData.containsKey('files')) {
      List<dynamic> fileUrls = userData['files'];
      List<String> updatedFileUrls = [];

      for (var fileUrl in fileUrls) {
        // Get the file's reference using the download URL
        Reference fileRef = FirebaseStorage.instance.refFromURL(fileUrl);

        // Get the updated download URL (in case it has changed)
        String updatedDownloadUrl = await fileRef.getDownloadURL();
        updatedFileUrls.add(updatedDownloadUrl);
      }

      // Add the updated file URLs to the result map
      result['files'] = updatedFileUrls;
    }

    return result;

  } catch (e) {
    print('Failed to get user data: $e');
    return null;
  }
}
