import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fabricModel.dart';

class SingleTon {
  // Singleton instance
  static final SingleTon fabricDetails = SingleTon._internal();

  factory SingleTon() => fabricDetails;

  SingleTon._internal();
  static DocumentSnapshot? selectedQRDoc;
  QRDataModel? qrDataModel;
  // Utility to clear data
  void clear() {
    qrDataModel = null;
    selectedQRDoc = null;
  }
}
