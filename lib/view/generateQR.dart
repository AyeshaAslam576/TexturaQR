import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:texuraqr/controllers/qrGenerateController.dart';
import 'dart:convert';

class QRGenerator extends StatelessWidget {
  QRGenerator({super.key});
  final QrGeneratecontroller controller = Get.put(QrGeneratecontroller());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // Lavender background
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        centerTitle: true,
        elevation: 4,
        title: Text(
          "Welcome to texura",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child:
                CircleAvatar(backgroundImage: AssetImage("assets/texura.png")),
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Fabric QR Code",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A148C),
                  ),
                ),
                const SizedBox(height: 30),

                // QR Container
                Obx(() => Screenshot(
                      controller: controller.screenshotController,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD1C4E9), Color(0xFFB39DDB)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.shade100,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: controller.isQrGenerated.value
                            ? QrImageView(
                                data:
                                    jsonEncode(controller.qrDataModel.toJson()),
                                size: screenWidth * 0.6,
                                backgroundColor: Colors.white,
                              )
                            : SizedBox(
                                width: screenWidth * 0.6,
                                height: screenWidth * 0.6,
                                child: Center(
                                  child: Text(
                                    "No QR Yet",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    )),
                const SizedBox(height: 40),
                Obx(() => controller.isQrGenerated.value
                    ? controller.buildGradientButton(
                        "Save QR", controller.saveQrToFirebaseAndGallery)
                    : controller.buildGradientButton(
                        "Generate QR", controller.setDataQr)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
