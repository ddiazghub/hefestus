import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';

class HefestusPage extends GetView<AuthController> {
  const HefestusPage({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome ${controller.email}'), actions: [
        IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            size: 30,
          ),
          onPressed: () => controller.logout(),
        ),
      ]),
      body: body,
    );
  }
}
