import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:texuraqr/controllers/splashscreencontroller.dart';

class Splashscreen extends StatelessWidget {
  Splashscreen({super.key});
  final SplashScreenController splashScreenController = Get.put(SplashScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0d9ff), // Soft lilac background 💜
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔵 Logo Avatar
              CircleAvatar(
                backgroundImage: const AssetImage("assets/texura.png"),
                radius: 60,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 25),

              // 💬 App Title
              Text(
                "Welcome to Textura QR",
                style: GoogleFonts.poppins(
                  color: const Color(0xff5e60ce),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              const SpinKitPumpingHeart(
                color: Color(0xff6930c3),
                size: 50,
                duration: Duration(milliseconds: 1600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
