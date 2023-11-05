import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/controllers/chat_controller.dart';
import 'package:hefestus/ui/controllers/map_controller.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:loggy/loggy.dart';
import 'package:hefestus/firebase_options.dart';

import 'ui/my_app.dart';

Future<void> main() async {
  // this is the key
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(ChatController());
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(MapController());

  runApp(const MyApp());
}
