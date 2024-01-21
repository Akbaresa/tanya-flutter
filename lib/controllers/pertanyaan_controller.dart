import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PertanyaanController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final TextEditingController headerController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  Future<void> tambahPertanyaan() async {
    try {
      final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.pertanyaan);
      final SharedPreferences prefs = await _prefs;
      final String? token = prefs.getString('token'); 
      Map body = {
          'header': headerController.text,
          'deskripsi': deskripsiController.text,
      };
      print(token);
      final response = await http.post(
        url,
        headers: {'X-API-TOKEN': token ?? '' , 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Pertanyaan added successfully!');
      } else {
        Get.snackbar('Error', 'Failed to add pertanyaan');
      }
    } catch (error) {
      print('Error adding pertanyaan: $error');
    }
  }
}
