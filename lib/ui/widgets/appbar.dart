import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/central.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/pages/place_page.dart';
import 'package:hefestus/ui/pages/user_page.dart';

void Function() profileHandler(AuthController auth) {
  if (auth.isUser) {
    return () => Get.to(UserPage(user: auth.userData!));
  } else {
    return () => Get.to(PlacePage(place: auth.storeData!.place));
  }
}

AppBar hefestusAppbar(BuildContext context) {
  final theme = Theme.of(context);
  final AuthController auth = Get.find();

  return AppBar(
    title: Text('Welcome ${auth.user?.email ?? ''}'),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.exit_to_app,
          size: 30,
        ),
        onPressed: () {
          auth.logout();
          Get.offAll(const Central());
        },
      ),
      if (auth.user != null)
        IconButton(
          icon: const Icon(
            Icons.account_circle,
            size: 30,
          ),
          onPressed: profileHandler(auth),
        ),
    ],
    backgroundColor: theme.colorScheme.primary,
    foregroundColor: theme.colorScheme.onPrimary,
  );
}
