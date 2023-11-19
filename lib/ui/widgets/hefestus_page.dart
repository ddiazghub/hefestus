import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/widgets/appbar.dart';

class HefestusPage extends GetView<AuthController> {
  const HefestusPage({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hefestusAppbar(context),
      body: body,
    );
  }
}
