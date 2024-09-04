import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Explicit import for web support

final FirebaseAuth auth = FirebaseAuth.instance;
String userId = FirebaseAuth.instance.currentUser!.uid;
User? currentUser = FirebaseAuth.instance.currentUser;

Future<bool> isDoctor(String userId) async {
  try {
    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(userId)
        .get();

    print("does doctor exist: ${doctorDoc.exists}");
    return doctorDoc.exists;
  } catch (e) {
    print('Error checking if doctor exists: $e');
    return false;
  }
}

Future<bool> isUser(String userId) async {
  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    print("does user exist: ${userDoc.exists}");
    return userDoc.exists;
  } catch (e) {
    print('Error checking if user exists: $e');
    return false;
  }
}

Future<bool> isAdmin(String userId) async {
  try {
    DocumentSnapshot adminDoc =
        await FirebaseFirestore.instance.collection('admins').doc(userId).get();

    print("does admin exist: ${adminDoc.exists}");
    return adminDoc.exists;
  } catch (e) {
    print('Error checking if admin exists: $e');
    return false;
  }
}

  Future<bool> doesAccountExist(String uid, String role) async {
    if (role == "Admin") {
      return await isAdmin(uid);
    } else if (role == "Doctor") {
      return await isDoctor(uid);
    } else if (role == "User") {
      return await isUser(uid);
    } else {
      return false; // Handle unexpected roles
    }
  }

class Auth {
  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => auth.authStateChanges();

  // Sign in with phone number
  Future<void> signInWithPhoneNumber(
      String phoneNumber, Function(String) onCodeSent) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Optionally handle auto-verification if needed
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        print("The code ${verificationId} has sent");
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle auto-retrieval timeout if needed
        print("Auto Retreival time");
      },
    );
  }

  // Sign in with SMS code
  Future<void> signInWithSmsCode(String verificationId, String smsCode) async {
    print(verificationId);
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await auth.signInWithCredential(credential);
  }

  // Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return auth.currentUser;
  }
}

void requestAccess(String userRole) {}
