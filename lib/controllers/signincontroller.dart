import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texuraqr/routes/Routes.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;

  RxBool isPassVisible = false.obs;
  final Color primaryColor = const Color(0xff5E60CE);

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  Future<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = cred.user;

      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-found', message: "No user found.");
      }

      final userDoc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      final role = userDoc["role"];
      _navigateToRoleBasedScreen(role);
      return user;
    } catch (e) {
      Get.snackbar("Login Failed", e.toString(), backgroundColor: Colors.red);
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut(); // Force account picker
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;
      final docRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
      final doc = await docRef.get();

      String? role;

      if (!doc.exists || !doc.data()!.containsKey('role')) {
        // Role not assigned yet – prompt
        role = await _showRoleDialog(context);
        if (role == null) {
          await _auth.signOut();
          return null;
        }

        await docRef.set({
          "email": user.email,
          "name": user.displayName,
          "profilePic": user.photoURL,
          "role": role,
          "createdAt": FieldValue.serverTimestamp(),
          "method": "google",
        }, SetOptions(merge: true));
      } else {
        role = doc['role'];
      }

      _navigateToRoleBasedScreen(role!);
      return userCredential;
    } catch (e) {
      Get.snackbar("Error", "Google Sign-In failed: $e", backgroundColor: Colors.red);
      print(".................................................");
      print(e);
      print(".................................................");
      return null;
    }
  }

  Future<String?> _showRoleDialog(BuildContext context) async {
    String? selectedRole;
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Your Role"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text("Customer"),
                value: "Customer",
                groupValue: selectedRole,
                onChanged: (value) {
                  selectedRole = value;
                  Get.back(result: value);
                },
              ),
              RadioListTile<String>(
                title: const Text("Manufacturer"),
                value: "Manufacturer",
                groupValue: selectedRole,
                onChanged: (value) {
                  selectedRole = value;
                  Get.back(result: value);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToRoleBasedScreen(String role) {
    if (role == "Customer") {
      Get.offAllNamed(ScreenRoutes.scanQR);
    } else if (role == "Manufacturer") {
      Get.offAllNamed(ScreenRoutes.manufactureFvrt);
    } else {
      Get.snackbar("Role Error", "User role not assigned.", backgroundColor: Colors.red);
    }
  }

  InputDecoration inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
      prefixIcon: Icon(prefixIcon, color: primaryColor),
      suffixIcon: suffixIcon,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 1.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
      ),
    );
  }

  void clearControllers() {
    email.clear();
    password.clear();
  }
}
