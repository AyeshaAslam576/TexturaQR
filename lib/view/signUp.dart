import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/signUp_controller.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final SignUpController _controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          Get.back(); // Navigate back to sign in screen
          return false; // Prevent default back button behavior
        },
        child: Scaffold(
          backgroundColor: const Color(0xffEDE7F6),
          body: SafeArea(
            child: Stack(
              children: [
                // 🌄 Header Image
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: height * 0.17,
                    child: Image.asset("assets/ill.png", fit: BoxFit.cover),
                  ),
                ),

                // 📝 Title
                Positioned(
                  top: height * 0.19,
                  left: width * 0.25,
                  child: Text(
                    "Get Started Free!",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _controller.primaryColor,
                    ),
                  ),
                ),

                // 📋 Form Section
                Positioned(
                  top: height * 0.25,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _controller.formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Free Forever. No Credit Card Needed!",
                                style: GoogleFonts.poppins(
                                  color: _controller.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _controller.buildLabel("Email Address"),
                            _controller.buildTextField(
                              controller: _controller.email,
                              hintText: "yourname@gmail.com",
                              icon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email address is required";
                                }
                                final emailRegex = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net|edu|gov|mil|biz|info|io|co|uk|us|ca|au|de|in)$',
                                    caseSensitive: false);
                                if (!emailRegex.hasMatch(value)) {
                                  return "Please enter a valid email address with a proper domain (e.g., .com, .org)";
                                }
                                if (value.length > 50) {
                                  return "Email address is too long";
                                }
                                return null;
                              },
                            ),
                            _controller.buildLabel("Full Name"),
                            _controller.buildTextField(
                              controller: _controller.fullname,
                              hintText: "Your Name",
                              icon: Icons.person,
                              validator: ValidationBuilder()
                                  .required()
                                  .minLength(3)
                                  .build(),
                            ),
                            _controller.buildLabel("Password"),
                            Obx(() => _controller.buildTextField(
                                  controller: _controller.password,
                                  hintText: "Password",
                                  icon: Icons.lock,
                                  isObscure: _controller.isPassVisible.value,
                                  toggleVisibility: () =>
                                      _controller.isPassVisible.toggle(),
                                  validator: ValidationBuilder()
                                      .required()
                                      .minLength(6)
                                      .build(),
                                )),
                            _controller.buildLabel("Confirm Password"),
                            Obx(() => _controller.buildTextField(
                                  controller: _controller.cpassword,
                                  hintText: "Re-enter Password",
                                  icon: Icons.lock_outline,
                                  isObscure:
                                      _controller.isCnfrmPswdVisible.value,
                                  toggleVisibility: () =>
                                      _controller.isCnfrmPswdVisible.toggle(),
                                  validator: (val) {
                                    if (val != _controller.password.text)
                                      return "Passwords do not match";
                                    return null;
                                  },
                                )),
                            const SizedBox(height: 8),
                            _controller.buildLabel("Select Role"),
                            Obx(() => Column(
                                  children: _controller.roles.map((role) {
                                    return RadioListTile<String>(
                                      title: Text(role),
                                      value: role,
                                      groupValue:
                                          _controller.selectedRole.value,
                                      onChanged: (val) {
                                        _controller.selectedRole.value = val!;
                                      },
                                    );
                                  }).toList(),
                                )),
                            const SizedBox(height: 10),
                            _controller.buildButton(
                              text: "Sign Up",
                              onPressed: () async {
                                if (_controller.formKey.currentState!
                                    .validate()) {
                                  if (_controller.selectedRole.value.isEmpty) {
                                    Get.snackbar(
                                        "Error", "Please select a role",
                                        backgroundColor: Colors.orange);
                                    return;
                                  }
                                  await _controller
                                      .createUserWithEmailAndPassword(
                                    _controller.email.text.trim(),
                                    _controller.password.text.trim(),
                                  );
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?",
                                    style: GoogleFonts.poppins()),
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text("Sign In",
                                      style: GoogleFonts.poppins(
                                          color: Colors.deepPurple)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
