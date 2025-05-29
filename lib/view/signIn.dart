import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texuraqr/controllers/signincontroller.dart';
import 'package:texuraqr/routes/Routes.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Ask user if they want to exit the app
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Exit App?', style: GoogleFonts.poppins()),
              content: Text('Are you sure you want to exit the app?',
                  style: GoogleFonts.poppins()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No',
                      style: GoogleFonts.poppins(color: Colors.deepPurple)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes',
                      style: GoogleFonts.poppins(color: Colors.deepPurple)),
                ),
              ],
            );
          },
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAE6F6),
        body: SafeArea(
          child: Stack(
            children: [
              // 🎨 Background top illustration
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: screenHeight * 0.3,
                  child:
                      Image.asset("assets/Illustration.png", fit: BoxFit.cover),
                ),
              ),

              // 🔐 Login Form
              Positioned(
                top: screenHeight * 0.18,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F4FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Welcome Back!",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: Text(
                              "Let's sign you in ✨",
                              style:
                                  GoogleFonts.poppins(color: Colors.grey[600]),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 📧 Email Field
                          Text("Email",
                              style: GoogleFonts.poppins(fontSize: 14)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: controller.email,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Email address is required";
                              }
                              final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net|edu|gov|mil|biz|info|io|co|uk|us|ca|au|de|in)$',
                                  caseSensitive: false);
                              if (!emailRegex.hasMatch(val)) {
                                return "Please enter a valid email address with a proper domain (e.g., .com, .org)";
                              }
                              return null;
                            },
                            decoration: controller.inputDecoration(
                              hintText: "Enter your email",
                              prefixIcon: Icons.email_outlined,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 🔒 Password Field
                          Text("Password",
                              style: GoogleFonts.poppins(fontSize: 14)),
                          const SizedBox(height: 6),
                          Obx(() => TextFormField(
                                controller: controller.password,
                                obscureText: controller.isPassVisible.value,
                                validator: (val) => val!.isEmpty
                                    ? "Password is required"
                                    : null,
                                decoration: controller.inputDecoration(
                                  hintText: "Enter your password",
                                  prefixIcon: Icons.lock_outline,
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        controller.isPassVisible.toggle(),
                                    icon: Icon(
                                      controller.isPassVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                              )),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text("Forgot Password?",
                                  style: GoogleFonts.poppins(
                                      color: Colors.deepPurple)),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 🎯 Sign In Button
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  await controller.loginWithEmailAndPassword(
                                    email: controller.email.text.trim(),
                                    password: controller.password.text.trim(),
                                  );
                                  controller.clearControllers();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text("Sign In",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 🌐 Divider
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text("or continue with",
                                    style: GoogleFonts.poppins()),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 🔘 Google Sign In
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await controller.signInWithGoogle(context);
                                    controller.clearControllers();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                  ),
                                  icon: const CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/google.jpeg"),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  label: Text("Sign In with Google"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // 👤 Sign Up link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account? ",
                                    style: GoogleFonts.poppins()),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(ScreenRoutes.signUp),
                                  child: Text("Sign Up",
                                      style: GoogleFonts.poppins(
                                          color: Colors.deepPurple)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
