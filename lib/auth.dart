import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
String userId = FirebaseAuth.instance.currentUser!.uid;
User? currentUser = FirebaseAuth.instance.currentUser;
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
