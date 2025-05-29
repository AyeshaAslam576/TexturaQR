import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class FabricDataController extends GetxController {
  // 🔤 Text Fields
  late TextEditingController companyName;
  late TextEditingController companyEmail;
  late TextEditingController fabricName;
  late TextEditingController pricePerMeterController;
  late TextEditingController composition;
  late TextEditingController certification;
  late TextEditingController phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxList<Color> selectedColors = <Color>[].obs;

  final Color primaryColor = const Color(0xFF6A1B9A);
  final Color secondaryColor = const Color(0xFF8E24AA);

  @override
  void onInit() {
    super.onInit();
    phoneNumberController = TextEditingController();
    companyName = TextEditingController();
    companyEmail = TextEditingController();
    fabricName = TextEditingController();
    pricePerMeterController = TextEditingController();
    composition = TextEditingController();
    certification = TextEditingController();
  }

  /// 🖌️ Color Picker
  void pickColor(BuildContext context, int index) async {
    Color initialColor = selectedColors.length > index
        ? selectedColors[index]
        : Colors.purple.shade200;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFEDE7F6),
        title: Text("Pick a color",
            style: GoogleFonts.poppins(color: primaryColor)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initialColor,
            onColorChanged: (color) {
              if (selectedColors.length > index) {
                selectedColors[index] = color;
              } else {
                selectedColors.add(color);
              }
            },
            enableAlpha: false,
            showLabel: true,
          ),
        ),
        actions: [
          TextButton(
            child:
                Text("Done", style: GoogleFonts.poppins(color: secondaryColor)),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  /// ✍️ Build Text Field
  Widget buildTextField(
      String hintText, IconData icon, TextEditingController textController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: textController,
        cursorColor: primaryColor,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$hintText is required";
          }
          if (hintText == "Company Email") {
            final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net|edu|gov|mil|biz|info|io|co|uk|us|ca|au|de|in)$',
                caseSensitive: false);
            if (!emailRegex.hasMatch(value)) {
              return "Please enter a valid email address with a proper domain (e.g., .com, .org)";
            }
          }
          return null;
        },
        style: GoogleFonts.poppins(color: primaryColor),
        decoration: InputDecoration(
          suffixIcon: Icon(icon, color: primaryColor),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: primaryColor.withOpacity(0.7)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: primaryColor.withOpacity(0.6), width: 1),
          ),
        ),
      ),
    );
  }

  /// 🟣 Build Gradient Button
  Widget buildGradientButton(String text, VoidCallback onTap) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  void resetForm() {
    companyName.clear();
    companyEmail.clear();
    fabricName.clear();
    pricePerMeterController.clear();
    composition.clear();
    certification.clear();
    selectedColors.clear();
    phoneNumberController.clear();
  }
}
