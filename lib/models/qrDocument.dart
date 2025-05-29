import 'fabricModel.dart';

class QRDocument {
  final String id;
  final String imageUrl;
  final QRDataModel data;

  QRDocument({
    required this.id,
    required this.imageUrl,
    required this.data,
  });
}
