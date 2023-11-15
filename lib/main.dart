import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/data/repository/place_repository.dart';
import 'package:hefestus/data/sources/place_datasource.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/controllers/chat_controller.dart';
import 'package:hefestus/ui/controllers/map_controller.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:loggy/loggy.dart';
import 'package:hefestus/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ui/my_app.dart';

// Nice try, this API Key is IP restricted
const apiKey = 'AIzaSyAYzFXFPyTWmQ5rHGlLcxorM-gf-KWLoLE';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;

  if (kIsWeb) {
    firestore.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
  } else if (Platform.isIOS || Platform.isAndroid) {
    firestore.settings = const Settings(persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  Get.put(ChatController());
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(PlaceRepository(PlaceDatasource(apiKey)));
  Get.put(MapController());

  runApp(const MyApp());
}
