import 'package:get/get.dart';

import 'package:texuraqr/view/fabricDataEnter.dart';
import 'package:texuraqr/view/fabricDetail.dart';
import 'package:texuraqr/view/generateQR.dart';
import 'package:texuraqr/view/manufactureFvrt.dart';

import 'package:texuraqr/view/scanQR.dart';
import 'package:texuraqr/view/scannedQRDetails.dart';
import 'package:texuraqr/view/signIn.dart';
import 'package:texuraqr/view/signUp.dart';
import 'package:texuraqr/view/splashScreen.dart';
class ScreenRoutes{
static const String edit='/edit';
static const String fabricDataEnter='/fabricDataEnter';
static const String fabricDetail='/fabricDetail';
static const String generateQR='/generateQR';
// static const String manufactureFvrt='/manufactureFvrt';
static const String role='/role';
static const String scannedQRDetails='/scannedQRDetails';
 static const String scanQR='/scanQR';
static const String signIn='/signIn';
static const String signUp='/signUp';
static const String splashScreen='/splashScreen';
static const String manufactureFvrt="/manufactureFvrt";
static final List<GetPage> myPages=[

  GetPage(name: fabricDataEnter, page: ()=>FabricDataEnter()),
  GetPage(name: fabricDetail, page: ()=>FabricDetailsScreen()),
  GetPage(name: generateQR, page: ()=>QRGenerator()),
  GetPage(name: splashScreen, page: ()=>Splashscreen()),
  GetPage(name: manufactureFvrt, page:()=> ManufacturerFavouritesScreen()),

  GetPage(name: scannedQRDetails, page: ()=>ScannedFabricDetail()),
  GetPage(name: scanQR, page: ()=>QRScanScreen()),
  GetPage(name: signIn, page: ()=>Signin()),
  GetPage(name: signUp, page: ()=>Signup()),
];
}