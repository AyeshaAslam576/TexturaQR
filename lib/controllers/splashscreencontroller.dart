
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texuraqr/routes/Routes.dart';
class SplashScreenController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    startTimer();
    super.onReady();
  }
  void startTimer(){
    Timer(Duration(seconds: 3),NavigateToNextScreen);
  }
  void NavigateToNextScreen(){
    Get.offNamed(ScreenRoutes.signIn);
  }
}