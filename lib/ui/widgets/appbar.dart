import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';

AppBar hefestusAppbar(BuildContext context) {
  final theme = Theme.of(context);
  final AuthController controller = Get.find();

  return AppBar(
    title: Text('Welcome ${controller.email}'),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.exit_to_app,
          size: 30,
        ),
        onPressed: () => controller.logout(),
      ),
    ],
    backgroundColor: theme.colorScheme.primary,
    foregroundColor: theme.colorScheme.onPrimary,
  );
}
