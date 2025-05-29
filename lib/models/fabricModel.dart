class QRDataModel {
  final String companyName;
  final String companyEmail;
  final String fabricName;
  final String pricePerMeter;
  final String composition;
  final String certification;
  final String contactNumber; // renamed for clarity
  final String color1;
  final String color2;
  final String color3;


  QRDataModel({
    required this.companyName,
    required this.companyEmail,
    required this.fabricName,
    required this.pricePerMeter,
    required this.composition,
    required this.certification,
    required this.contactNumber,
    required this.color1,
    required this.color2,
    required this.color3,
  });

  factory QRDataModel.fromJson(Map<String, dynamic> json) {
    return QRDataModel(
      companyName: json['companyName'] ?? '',
      companyEmail: json['companyEmail'] ?? '',
      fabricName: json['fabricName'] ?? '',
      pricePerMeter: json['pricePerMeter'] ?? '',
      composition: json['composition'] ?? '',
      certification: json['certification'] ?? '',
      contactNumber: json['contactNumber'] ?? '', // Updated key
      color1: json['color1'] ?? 'ffffffff',
      color2: json['color2'] ?? 'ffffffff',
      color3: json['color3'] ?? 'ffffffff',
    );
  }

  Map<String, dynamic> toJson() => {
    'companyName': companyName,
    'companyEmail': companyEmail,
    'fabricName': fabricName,
    'pricePerMeter': pricePerMeter,
    'composition': composition,
    'certification': certification,
    'contactNumber': contactNumber, // Updated key
    'color1': color1,
    'color2': color2,
    'color3': color3,
  };
}
