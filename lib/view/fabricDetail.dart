import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texuraqr/controllers/fabricDetailController.dart';
import 'package:google_fonts/google_fonts.dart';
class FabricDetailsScreen extends StatelessWidget {
  FabricDetailsScreen({super.key});
  final controller = Get.put(FabricDetailController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6), // soft lavender background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6A1B9A)),
                onPressed: () => Get.back(),
              ),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/company_logo.png"),
                      radius: 40,
                      backgroundColor: Color(0xFF8E24AA),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.companyName.text,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              controller.buildTextField(label: "Email", controller: controller.email, isEditable: controller.isEditing.value),
              controller.buildTextField(label: "Fabric Name", controller: controller.fabricName, isEditable: controller.isEditing.value),
              controller.buildTextField(label: "Price Per Meter", controller: controller.price, isEditable: controller.isEditing.value),
              controller.buildTextField(label: "Material Composition", controller: controller.composition, isEditable: controller.isEditing.value),
              controller.buildTextField(label: "Contact Number", controller: controller.contactNumber, isEditable: controller.isEditing.value), // ✅ NEW

              const SizedBox(height: 16),
              Text(
                "Available Colors",
                style: GoogleFonts.poppins(color: Color(0xFF6A1B9A), fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              Row(
                children: controller.colors.map((color) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  );
                }).toList(),
              ),
            ],
          )),
        ),
      ),

      bottomNavigationBar: Obx(() => Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: controller.isEditing.value
              ? [
            Expanded(
              child: controller.buildButton(
                text: "Update",
                onPressed: controller.updateQr,
                color: const Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: controller.buildButton(
                text: "Cancel",
                onPressed: () => controller.isEditing.value = false,
                color: Colors.grey,
              ),
            ),
          ]
              : [
            Expanded(
              child: controller.buildButton(
                text: "Edit",
                onPressed: () => controller.isEditing.value = true,
                color: const Color(0xFF8E24AA),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: controller.buildButton(
                text: "Delete",
                onPressed: controller.deleteQr,
                color: Colors.red,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
