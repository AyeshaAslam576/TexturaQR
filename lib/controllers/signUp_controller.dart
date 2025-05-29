import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texuraqr/routes/Routes.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();
  final cpassword = TextEditingController();

  final RxBool isPassVisible = true.obs;
  final RxBool isCnfrmPswdVisible = true.obs;
  final RxBool isLoading = false.obs;

  final RxString selectedRole = ''.obs;
  final RxList<String> roles = ["Manufacturer", "Customer"].obs;

  final Color primaryColor = const Color(0xFF6A1B9A);

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    if (selectedRole.value.isEmpty) {
      Get.snackbar("Required", "Please select a user role", backgroundColor: Colors.orange);
      return null;
    }

    try {
      isLoading.value = true;
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await saveUserToFirestore(
        uid: cred.user!.uid,
        email: email,
        name: fullname.text.trim(),
        method: "email",
      );
      Get.snackbar("Success", "Account created successfully", backgroundColor: Colors.green);

      if (selectedRole.value == "Customer") {
        Get.offAllNamed(ScreenRoutes.scanQR); // or ScreenRoutes.scanQR if you have route constants
      } else if (selectedRole.value == "Manufacturer") {
        Get.offAllNamed(ScreenRoutes.manufactureFvrt);
      }

      clearControllers();
      return cred.user;

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          Get.snackbar("Weak Password", "Password is too weak.", backgroundColor: Colors.red);
          break;
        case 'email-already-in-use':
          Get.snackbar("Email Exists", "Account already exists.", backgroundColor: Colors.red);
          break;
        default:
          Get.snackbar("Error", e.message ?? "Unknown error", backgroundColor: Colors.red);
      }
    } catch (_) {
      Get.snackbar("Error", "Signup failed", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> saveUserToFirestore({
    required String uid,
    required String email,
    required String name,
    required String method,
    String? profilePic,
  }) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "uid": uid,
      "email": email,
      "name": name,
      "role": selectedRole.value,
      "profilePic": profilePic ?? '',
      "createdAt": FieldValue.serverTimestamp(),
      "method": method,
    }, SetOptions(merge: true));
  }

  void clearControllers() {
    email.clear();
    password.clear();
    fullname.clear();
    cpassword.clear();
    selectedRole.value = '';
  }

  InputDecoration inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: primaryColor),
      suffixIcon: suffixIcon,
      hintStyle: GoogleFonts.poppins(color: primaryColor.withOpacity(0.7)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Text(text, style: GoogleFonts.poppins(color: primaryColor, fontWeight: FontWeight.w600)),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    bool isObscure = false,
    VoidCallback? toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        validator: validator,
        cursorColor: primaryColor,
        decoration: inputDecoration(
          hintText: hintText,
          prefixIcon: icon,
          suffixIcon: toggleVisibility != null
              ? IconButton(
            icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: primaryColor),
            onPressed: toggleVisibility,
          )
              : null,
        ),
      ),
    );
  }

  Widget buildButton({required String text, required VoidCallback onPressed}) {
    return Obx(() => AbsorbPointer(
      absorbing: isLoading.value,
      child: AnimatedOpacity(
        opacity: isLoading.value ? 0.6 : 1,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            ),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(text, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    ));
  }

  Widget buildDivider(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(label, style: GoogleFonts.poppins(color: Colors.black)),
          ),
          const Expanded(child: Divider(color: Colors.grey)),
        ],
      ),
    );
  }
}
