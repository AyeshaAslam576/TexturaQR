import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:texuraqr/routes/Routes.dart';
import 'package:texuraqr/singleton/singleton.dart';

import '../models/fabricModel.dart';

class QrGeneratecontroller extends GetxController {
  late QRDataModel qrDataModel;
  final SingleTon singleTonStoredQrData = SingleTon.fabricDetails;
  ScreenshotController screenshotController = ScreenshotController();
  RxBool isQrGenerated = false.obs;

  /// 1. Prepare QR data from singleton
  void setDataQr() {
    final singleModel = SingleTon.fabricDetails.qrDataModel;
    if (singleModel == null) {
      Get.snackbar("Error", "QR data not found. Please enter details first.", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    qrDataModel = singleModel;
    isQrGenerated.value = true;

    Get.snackbar("Success", "QR Generated 🎉",
        backgroundColor: Colors.brown.shade300, colorText: Colors.white);
  }

  Future<String?> uploadToCloudinary(Uint8List imageBytes) async {
    try {
      const cloudName = 'dbgogkbcq';
      const uploadPreset = 'unsigned_qr_upload';

      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'qr_code.png'));

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = res.body;
        final url = RegExp(r'"secure_url":"(.*?)"').firstMatch(data)?.group(1);
        return url?.replaceAll(r'\/', '/');
      } else {
        throw "Upload failed with status ${response.statusCode}";
      }
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  /// 3. Save QR to Firestore & Gallery
  Future<void> saveQrToFirebaseAndGallery() async {
    try {
      final Uint8List? qrImage = await screenshotController.capture();

      if (qrImage == null) {
        Get.snackbar("QR Error", "QR code could not be captured ❌", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final localDir = await getTemporaryDirectory();
      final localPath = '${localDir.path}/qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(localPath)..writeAsBytesSync(qrImage);

      await ImageGallerySaver.saveImage(qrImage);

      final imageUrl = await uploadToCloudinary(qrImage);
      if (imageUrl == null) {
        Get.snackbar("Upload Failed", "Image upload to Cloudinary failed ❌", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Auth Error", "You must be signed in to save QR data 🔒", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final userId = user.uid;

      /// 🔥 Create main QR doc
      final qrDoc = await FirebaseFirestore.instance.collection("qrs").add({
        "imageUrl": imageUrl,
        "generatedBy": userId,
        "timestamp": FieldValue.serverTimestamp(),
      });

      /// ✅ Create nested collection 'QrData' and save JSON
      await qrDoc.collection("QrData").add(qrDataModel.toJson());

      /// 🔁 Link QR ID to user
      await FirebaseFirestore.instance.collection("users").doc(userId).set({
        "generatedQrCodes": FieldValue.arrayUnion([qrDoc.id])
      }, SetOptions(merge: true));

      Get.snackbar("Success ✅", "QR Code Saved & Uploaded", backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAllNamed(ScreenRoutes.manufactureFvrt);

    } catch (e, st) {
      print("Exception: $e\nStackTrace: $st");
      Get.snackbar("Error ❌", "Something went wrong. Please try again.", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// Reusable styled button
  Widget buildGradientButton(String text, VoidCallback onPressed) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)]),
        borderRadius: BorderRadius.circular(25),
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
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            text,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
