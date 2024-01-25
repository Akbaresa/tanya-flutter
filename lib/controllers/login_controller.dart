import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/home.dart';
import '../screen/auth/auth_screen.dart';
import '../utils/api_endpoints.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> login() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.login);
      Map body = {
        'username': emailController.text.trim(),
        'password': passwordController.text,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['errors'] == null) {
          var token = json['data']['token'];
          // print(token);
          await _saveTokenToSharedPreferences(token);

          emailController.clear();
          passwordController.clear();
          Get.off(Home());
        }
      } else {
        throw jsonDecode(response.body)["errors"] ?? "Unknown Error Occurred test";
      }
      
    } catch (error) {
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }

   Future<void> logout() async {
    final SharedPreferences prefs = await _prefs;
    final String? token = prefs.getString('token');
    print(token);
    if (token != null) {
      try {
        var url = Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.logout);
        final response = await http.delete(
          url,
          headers: {'X-API-TOKEN': token},
        );

        if (response.statusCode == 200) {
          prefs.clear();
          Get.offAll(const AuthScreen());
        } else {
          print('Failed to logout on the server: ${response.body}');
        }
      } catch (error) {
        print('Error during logout: $error');
      }
    }
  }

  Future<void> _saveTokenToSharedPreferences(String token) async {
    try {
      final SharedPreferences prefs = await _prefs;
      await prefs.setString('token', token);
      final String? token1 =  prefs.getString('token');
      print(token1);
    } catch (error) {
      print('Error menyimpan shared preferences: $error');
    }
  }
}
