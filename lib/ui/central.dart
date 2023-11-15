import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/chat_controller.dart';
import 'package:hefestus/ui/controllers/map_controller.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:hefestus/ui/pages/content_page.dart';
import 'package:hefestus/ui/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hefestus/ui/pages/place_page.dart';

class Central extends StatelessWidget {
  const Central({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.find<UserController>().start();
            Get.find<ChatController>().start();
            Get.find<MapController>().start();
          });

          // return const ContentPage();
          return const PlacePage();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.find<UserController>().stop();
            Get.find<ChatController>().stop();
            Get.find<MapController>().stop();
          });

          return const LoginPage();
        }
      },
    );
  }
}
