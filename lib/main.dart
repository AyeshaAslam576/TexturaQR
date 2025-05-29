import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texuraqr/routes/Routes.dart';
import 'package:texuraqr/view/fabricDataEnter.dart';
import 'package:texuraqr/view/generateQR.dart';
import 'package:texuraqr/view/manufactureFvrt.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: QRGenerator(),
      getPages: ScreenRoutes.myPages,
      initialRoute: ScreenRoutes.splashScreen,
    );
  }
}
