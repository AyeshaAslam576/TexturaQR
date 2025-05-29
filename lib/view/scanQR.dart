import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../controllers/scanQRController.dart';

class QRScanScreen extends StatelessWidget {
  QRScanScreen({super.key});

  final controller = Get.put(ScannedQRController());
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF6A1B9A); // deep purple

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text("Scan QR Code",style: TextStyle(color: Colors.white),),
        backgroundColor: themeColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch,color: Colors.white,),
            onPressed: controller.flipCamera,
            tooltip: 'Switch Camera',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: controller.onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: themeColor,
                borderRadius: 12,
                borderLength: 28,
                borderWidth: 8,
                cutOutSize: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner_rounded, size: 40, color: Colors.deepPurple),
                  const SizedBox(height: 12),
                  Text(
                    "Align the QR code inside the frame to scan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
