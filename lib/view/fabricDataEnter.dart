import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/fabricDataController.dart';
import 'package:texuraqr/routes/Routes.dart';
import 'package:texuraqr/singleton/singleton.dart';

import '../models/fabricModel.dart';

class FabricDataEnter extends StatelessWidget {
  FabricDataEnter({super.key});
  final FabricDataController controller = Get.put(FabricDataController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(ScreenRoutes
            .manufactureFvrt); // Navigate back to manufacturer screen
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEDE7F6),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Enter Fabric Details",
                      style: TextStyle(
                        color: Color(0xFF4A148C),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  controller.buildTextField(
                      "Company Name", Icons.home, controller.companyName),
                  controller.buildTextField(
                      "Company Email", Icons.email, controller.companyEmail),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.phone,
                      cursorColor: controller.primaryColor,
                      style:
                          GoogleFonts.poppins(color: controller.primaryColor),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        final pattern =
                            RegExp(r'^(03\d{9})$|^((042|021|051)-?\d{7})$');
                        if (!pattern.hasMatch(value.trim())) {
                          return 'Enter a valid mobile or PTCL number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon:
                            Icon(Icons.phone, color: controller.primaryColor),
                        hintText: "Contact Number",
                        hintStyle: GoogleFonts.poppins(
                            color: controller.primaryColor.withOpacity(0.7)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: controller.primaryColor, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: controller.primaryColor.withOpacity(0.6),
                              width: 1),
                        ),
                      ),
                    ),
                  ),
                  controller.buildTextField("Fabric Name",
                      Icons.app_registration, controller.fabricName),
                  controller.buildTextField("Price Per Meter",
                      Icons.price_change, controller.pricePerMeterController),
                  controller.buildTextField("Material Composition",
                      Icons.compost, controller.composition),
                  controller.buildTextField("Sustainability Certification",
                      Icons.verified, controller.certification),

                  const SizedBox(height: 20),

                  // Colors Picker
                  Row(
                    children: const [
                      Icon(Icons.color_lens, color: Color(0xFF6A1B9A)),
                      SizedBox(width: 8),
                      Text("Available Colors",
                          style: TextStyle(color: Color(0xFF6A1B9A))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Row(
                        children: List.generate(3, (index) {
                          return GestureDetector(
                            onTap: () => controller.pickColor(context, index),
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: controller.selectedColors.length > index
                                    ? controller.selectedColors[index]
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(color: Color(0xFF6A1B9A)),
                              ),
                              child: controller.selectedColors.length <= index
                                  ? const Icon(Icons.add,
                                      size: 20, color: Color(0xFF6A1B9A))
                                  : null,
                            ),
                          );
                        }),
                      )),

                  const SizedBox(height: 30),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.buildGradientButton(
                          "Reset", controller.resetForm),
                      controller.buildGradientButton("Next", () {
                        if (controller.formKey.currentState!.validate()) {
                          if (controller.selectedColors.length < 3) {
                            Get.snackbar(
                              "Validation Error",
                              "Please select 3 colors before proceeding.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          SingleTon.fabricDetails.qrDataModel = QRDataModel(
                            companyName: controller.companyName.text,
                            companyEmail: controller.companyEmail.text,
                            fabricName: controller.fabricName.text,
                            pricePerMeter:
                                controller.pricePerMeterController.text,
                            composition: controller.composition.text,
                            certification: controller.certification.text,
                            contactNumber:
                                controller.phoneNumberController.text,
                            color1: controller.selectedColors[0].value
                                .toRadixString(16),
                            color2: controller.selectedColors[1].value
                                .toRadixString(16),
                            color3: controller.selectedColors[2].value
                                .toRadixString(16),
                          );

                          Get.snackbar(
                              "Saved", "Fabric data stored successfully ❤️",
                              backgroundColor: const Color(0xFFD1C4E9),
                              colorText: Colors.black);
                          Get.toNamed(ScreenRoutes.generateQR);
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
