import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texuraqr/models/fabricModel.dart';

import 'package:texuraqr/routes/Routes.dart';
import '../controllers/manufactureFavouriteController.dart';
import '../singleton/singleton.dart';
class ManufacturerFavouritesScreen extends StatelessWidget {
  ManufacturerFavouritesScreen({super.key});
  final controller = Get.put(ManufacturerFavouritesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // light lavender
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A), // deep purple
        centerTitle: true,
        elevation: 4,
        title: Text(
          "Your QR Codes",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.qrDocs.isEmpty) {
          return Center(
            child: Text(
              "No QR Codes Found",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          );
        }

          return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          itemCount: controller.qrDocs.length,
          itemBuilder: (context, index) {
            final qr = controller.qrDocs[index];
            final fabricName = qr.data.fabricName;
            final fabricComposition = qr.data.composition;
            final imageUrl = qr.imageUrl;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD1C4E9), Color(0xFFB39DDB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade100,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(imageUrl),
                  backgroundColor: Colors.white,
                ),
                title: Text(
                  fabricName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: const Color(0xFF4527A0),
                  ),
                ),
                subtitle: Text(
                  fabricComposition,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF5E35B1),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.navigate_next, color: Color(0xFF6A1B9A)),
                  onPressed: () {
                    controller.setSelectedQR(qr.id);
                  },
                ),
                onTap: () {
                  controller.setSelectedQR(qr.id);
                },
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(ScreenRoutes.fabricDataEnter);
        },
        backgroundColor: const Color(0xFF6A1B9A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
