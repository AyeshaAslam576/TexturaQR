import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:texuraqr/routes/Routes.dart';
import 'package:texuraqr/singleton/singleton.dart';

import '../models/fabricModel.dart';
import '../models/qrDocument.dart';
class ManufacturerFavouritesController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchQRCodes();
  }
  RxList<QRDocument> qrDocs = <QRDocument>[].obs;

  Future<void> fetchQRCodes() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final qrSnap = await FirebaseFirestore.instance
          .collection('qrs')
          .where('generatedBy', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      final List<QRDocument> enrichedDocs = [];

      for (final doc in qrSnap.docs) {
        final subSnap = await doc.reference.collection('QrData').limit(1).get();
        if (subSnap.docs.isNotEmpty) {
          final qrData = QRDataModel.fromJson(subSnap.docs.first.data() as Map<String, dynamic>);
          enrichedDocs.add(QRDocument(
            id: doc.id,
            imageUrl: doc['imageUrl'],
            data: qrData,
          ));
        }
      }

      qrDocs.assignAll(enrichedDocs);

    } catch (e) {
      print('Error fetching QR codes: $e');
    }
  }
  void setSelectedQR(String docId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('qrs').doc(docId).get();
      SingleTon.selectedQRDoc = doc;
      Get.toNamed(ScreenRoutes.fabricDetail);
    } catch (e) {
      print("Error retrieving document: $e");
    }
  }

}
