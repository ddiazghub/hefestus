import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/widgets/appbar.dart';

class HefestusPage extends GetView<AuthController> {
  const HefestusPage({super.key, required this.body, this.floatingActionButton});

  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hefestusAppbar(context),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
