import 'package:flutter_application_1/screen/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() async {
  runApp(const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthScreen(),
  ));
}