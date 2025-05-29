import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:texuraqr/models/fabricModel.dart';
import 'package:texuraqr/singleton/singleton.dart';
import 'package:texuraqr/routes/Routes.dart';
import 'package:google_fonts/google_fonts.dart';

class FabricDetailController extends GetxController {
  final email = TextEditingController();
  final fabricName = TextEditingController();
  final price = TextEditingController();
  final composition = TextEditingController();
  final companyName = TextEditingController();
  final contactNumber = TextEditingController();

  RxList<Color> colors = <Color>[].obs;
  RxBool isEditing = false.obs;

  DocumentSnapshot? get doc => SingleTon.selectedQRDoc;
  String? docId;

  @override
  void onInit() {
    super.onInit();
    fetchQrData();
  }

  Future<void> fetchQrData() async {
    final snapshot = SingleTon.selectedQRDoc;
    if (snapshot == null) return;

    docId = snapshot.id;

    final subCollection = await snapshot.reference.collection('QrData').get();
    if (subCollection.docs.isEmpty) return;

    final data = subCollection.docs.first.data();
    final model = QRDataModel.fromJson(data);

    email.text = model.companyEmail;
    fabricName.text = model.fabricName;
    price.text = model.pricePerMeter;
    composition.text = model.composition;
    companyName.text = model.companyName;
    contactNumber.text = model.contactNumber;

    try {
      colors.assignAll([
        Color(int.parse(model.color1, radix: 16)),
        Color(int.parse(model.color2, radix: 16)),
        Color(int.parse(model.color3, radix: 16)),
      ]);
    } catch (_) {
      colors.assignAll([Colors.grey, Colors.grey, Colors.grey]);
    }
  }

  Future<void> updateQr() async {
    if (docId == null) return;

    final snapshot = SingleTon.selectedQRDoc;
    final subDocs = await snapshot!.reference.collection("QrData").get();
    if (subDocs.docs.isEmpty) return;

    final qrDoc = subDocs.docs.first.reference;

    await qrDoc.update({
      'companyEmail': email.text,
      'fabricName': fabricName.text,
      'pricePerMeter': price.text,
      'composition': composition.text,
      'contactNumber': contactNumber.text,
    });

    isEditing.value = false;
    Get.offAllNamed(ScreenRoutes.manufactureFvrt);
  }

  Future<void> deleteQr() async {
    if (docId == null) return;

    await FirebaseFirestore.instance.collection("qrs").doc(docId!).delete();
    Get.snackbar("Deleted", "QR deleted successfully", backgroundColor: Colors.red, colorText: Colors.white);
    Get.offAllNamed(ScreenRoutes.manufactureFvrt);
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required bool isEditable,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        enabled: isEditable,
        style: GoogleFonts.poppins(color: Colors.deepPurple, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: const Color(0xFF6A1B9A)),
          filled: true,
          fillColor: const Color(0xFFEDE7F6),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6A1B9A), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFB39DDB), width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFB39DDB), width: 1),
          ),
        ),
      ),
    );
  }

  Widget buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.9), color]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
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
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
