import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:texuraqr/singleton/singleton.dart';
import 'package:texuraqr/routes/Routes.dart';

class ScannedQRController extends GetxController {
  late QRViewController qrController;
  final RxBool isLoading = false.obs;

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    qrController.scannedDataStream.listen((scanData) async {
      final scannedString = scanData.code ?? "";
      if (scannedString.isEmpty) return;

      qrController.pauseCamera();
      await fetchQrData(scannedString);
    });
  }

  // Future<void> fetchQrData(String scannedData) async {
  //   try {
  //     isLoading.value = true;
  //     final Map<String, dynamic> decodedScannedMap = jsonDecode(scannedData);
  //
  //     final snapshot = await FirebaseFirestore.instance.collection('qrs').get();
  //
  //     for (var doc in snapshot.docs) {
  //       final qrDataSnap = await doc.reference.collection('QrData').get();
  //       if (qrDataSnap.docs.isEmpty) continue;
  //
  //       final qrDataMap = qrDataSnap.docs.first.data();
  //
  //       if (mapEquals(qrDataMap, decodedScannedMap)) {
  //         SingleTon.selectedQRDoc = doc;
  //         Get.offNamed(ScreenRoutes.scannedQRDetails);
  //         return;
  //       }
  //     }
  //
  //     _showError("QR Not Found", "This QR code does not exist in our database.");
  //     qrController.resumeCamera();
  //   } catch (e) {
  //     _showError("Error", "Failed to fetch QR data.");
  //     qrController.resumeCamera();
  //     print("Error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> fetchQrData(String scannedData) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> decodedScannedMap = jsonDecode(scannedData);

      final snapshot = await FirebaseFirestore.instance.collection('qrs').get();

      for (var doc in snapshot.docs) {
        final qrDataSnap = await doc.reference.collection('QrData').get();
        if (qrDataSnap.docs.isEmpty) continue;

        final qrDataMap = qrDataSnap.docs.first.data();

        if (mapEquals(qrDataMap, decodedScannedMap)) {
          SingleTon.selectedQRDoc = doc;
          Get.offNamed(ScreenRoutes.scannedQRDetails);
          return;
        }
      }

      _showError(
          "QR Not Found", "This QR code does not exist in our database.");
      qrController.resumeCamera();
    } catch (e) {
      _showError("Error", "Failed to fetch QR data.");
      qrController.resumeCamera();
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  // Optional: More readable map matcher
  bool _mapsAreEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    return mapEquals(a, b);
  }

  // Camera lifecycle
  void flipCamera() {
    qrController.flipCamera();
  }

  void resumeCamera() {
    qrController.resumeCamera();
  }

  void pauseCamera() {
    qrController.pauseCamera();
  }

  @override
  void onClose() {
    qrController.dispose();
    super.onClose();
  }
}
