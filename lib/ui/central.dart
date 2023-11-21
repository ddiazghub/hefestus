import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/controllers/chat_controller.dart';
import 'package:hefestus/ui/controllers/map_controller.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:hefestus/ui/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hefestus/ui/pages/map_page.dart';
import 'package:hefestus/ui/pages/user_chat_page.dart';
import 'package:hefestus/ui/widgets/spinner.dart';

class Central extends GetView<AuthController> {
  const Central({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<MapController>().start();
      Get.find<UserController>().start();
    });

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.find<ChatController>().start();
          });

          final future = Future.delayed(
            const Duration(seconds: 1),
            () => controller.getUserData(),
          );

          return FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return controller.isUser
                    ? const MapPage()
                    : const UserChatPage();
              }

              return const Spinner();
            },
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.find<ChatController>().stop();
          });

          return const LoginPage();
        }
      },
    );
  }
}
