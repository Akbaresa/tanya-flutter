import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/profile_controller.dart';
import 'package:flutter_application_1/model/home.dart';
import 'package:get/get.dart';

class ProfilScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              // No need to fetchUserData here, it's already done in the controller's onInit
              Get.off(Home());
            },
            child: const Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Obx(
        () => profileController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: profileController.usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: profileController.emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        profileController.updateUserData();
                      },
                      child: Text('Simpan'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
