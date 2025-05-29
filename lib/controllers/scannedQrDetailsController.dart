import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:texuraqr/singleton/singleton.dart';

class ScannedFabricController extends GetxController {
  final data = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  /// 🧾 Fetch and assign QR data
  void fetchData() async {
    final doc = SingleTon.selectedQRDoc;
    if (doc != null && doc.exists) {
      final qrDataSnap = await doc.reference.collection('QrData').get();
      if (qrDataSnap.docs.isNotEmpty) {
        final qrMap = qrDataSnap.docs.first.data();
        data.assignAll(qrMap.map((key, value) => MapEntry(key, value.toString())));
      }
    }
  }


  /// 🟣 Stylish display field for info
  Widget buildDisplayField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD1C4E9), // Light purple
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: TextField(
          enabled: false,
          style: GoogleFonts.poppins(
            color: Colors.deepPurple.shade900,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              color: Colors.deepPurple.shade700,
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: Colors.deepPurple.shade700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  /// 🟣 Color indicator dot
  Widget buildColorDot(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            offset: const Offset(0, 2),
          )
        ],
      ),
    );
  }

  /// 🟣 Gradient action button
  Widget buildGradientButton(String label, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
