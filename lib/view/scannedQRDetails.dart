import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/scannedQrDetailsController.dart';
import 'package:texuraqr/routes/Routes.dart';

class ScannedFabricDetail extends StatelessWidget {
  ScannedFabricDetail({super.key});

  final ScannedFabricController controller = Get.put(ScannedFabricController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(ScreenRoutes.scanQR); // Navigate to scan screen
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEDE7F6), // Light lavender background
        body: SafeArea(
          child: Obx(() => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.07, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Color(0xFF6A1B9A)),
                        onPressed: () {
                          Get.offAllNamed(ScreenRoutes.scanQR);
                        },
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Company Logo Circle
                    CircleAvatar(
                      backgroundColor: const Color(0xFF8E24AA),
                      radius: 35,
                      child: Text(
                        controller.data["companyName"] != null
                            ? controller.data["companyName"]![0]
                            : "?",
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Company Name
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        controller.data["companyName"] ?? "Unknown Company",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF4A148C),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Info Fields
                    controller.buildDisplayField(
                        controller.data["companyEmail"] ?? "No Email Provided",
                        Icons.email_outlined),
                    controller.buildDisplayField(
                        controller.data["contactNumber"] ?? "No Contact Number",
                        Icons.phone_outlined),
                    controller.buildDisplayField(
                        controller.data["fabricName"] ?? "Unknown Fabric",
                        Icons.bookmark_outline),
                    controller.buildDisplayField(
                      "Rs ${controller.data["pricePerMeter"] ?? '0'} per meter",
                      Icons.attach_money,
                    ),
                    controller.buildDisplayField(
                        controller.data["composition"] ?? "No Composition",
                        Icons.format_paint),
                    controller.buildDisplayField(
                        "Available Colors", Icons.color_lens_outlined),

                    // Color Dots Row
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.data["color1"] != null)
                            controller.buildColorDot(Color(int.parse(
                                controller.data["color1"]!,
                                radix: 16))),
                          if (controller.data["color2"] != null)
                            controller.buildColorDot(Color(int.parse(
                                controller.data["color2"]!,
                                radix: 16))),
                          if (controller.data["color3"] != null)
                            controller.buildColorDot(Color(int.parse(
                                controller.data["color3"]!,
                                radix: 16))),
                        ],
                      ),
                    ),

                    // Contact Us Button
                    controller.buildGradientButton("Contact Us", () {
                      Get.snackbar(
                        "Contact Information",
                        "📧 Email: ${controller.data["companyEmail"] ?? "Not available"}\n"
                            "📞 Phone: ${controller.data["contactNumber"] ?? "Not available"}\n\n"
                            "Please copy the contact details to get in touch with us.",
                        backgroundColor: const Color(0xFFD1C4E9),
                        colorText: Colors.black87,
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 5),
                        margin: const EdgeInsets.all(12),
                        borderRadius: 10,
                        icon: const Icon(Icons.contact_phone,
                            color: Colors.deepPurple),
                      );
                    }),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
