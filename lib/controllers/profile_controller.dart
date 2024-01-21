import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_endpoints.dart';

class ProfileController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final RxBool isLoading = true.obs;
  final RxBool isUpdating = false.obs;
  final RxString username = ''.obs;
  final RxString email = ''.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final url = Uri.parse(
  ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getUser);
  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;


      final SharedPreferences prefs = await _prefs;
      final String? token = prefs.getString('token');
      final response = await http.get(
        url,
        headers: {'X-API-TOKEN': token ?? ''},
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body)['data'];
        username.value = userData['username'] ?? '';
        email.value = userData['email'] ?? '';
        usernameController.text = username.value;
        emailController.text = email.value;
      } else {
        throw Exception('Failed to load user data');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserData() async {
    try {
      isUpdating.value = true;
      final SharedPreferences prefs = await _prefs;
      final String? token = prefs.getString('token');

      final response = await http.patch(
        url,
        headers: {'X-API-TOKEN': token ?? '', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text,
          'email': emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog();
        await fetchUserData(); // Reload user data after a successful update
      } else {
        throw Exception('Failed to update user data');
      }
    } catch (error) {
      print('Error updating user data: $error');
    } finally {
      isUpdating.value = false;
    }
  }

  void _showSuccessDialog() {
    Get.defaultDialog(
      title: 'Success',
      content: Text('User data updated successfully!'),
      onCancel: () {
        Get.back();
      },
      onConfirm: () {
        Get.back();
      },
    );
  }
}
