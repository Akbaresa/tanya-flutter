import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KomentarController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> tambahKomentar(String deskripsi, String idPertanyaan) async {
    try {
      final url = Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.komentar}');
      final SharedPreferences prefs = await _prefs;
      final String? token = prefs.getString('token');
      
      final response = await http.post(
        url,
        headers: {'X-API-TOKEN': token ?? '', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'deskripsi': deskripsi,
          'idPertanyaan': idPertanyaan,
        }),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Comment added successfully!');
      } else {
        Get.snackbar('Error', 'Failed to add comment');
      }
    } catch (error) {
      print('Error adding comment: $error');
    }
  }
}
