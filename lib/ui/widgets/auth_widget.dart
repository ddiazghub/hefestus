import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/pages/content_page.dart';
import 'package:hefestus/ui/pages/login/login.dart';
import 'package:hefestus/ui/widgets/spinner.dart';

abstract class AuthBuilder extends GetView<AuthController> {
  const AuthBuilder({
    super.key,
    required this.builder,
    required this.redirect,
    required this.authPredicate,
  });

  final Widget Function(BuildContext) builder;
  final dynamic Function() redirect;
  final bool Function(User?) authPredicate;

  dynamic Function(Duration) get redirectAction => (_) => Get.off(redirect);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authPredicate(controller.user)) {
        return builder(context);
      }

      WidgetsBinding.instance.addPostFrameCallback(redirectAction);

      return const Spinner();
    });
  }
}

class RequiresAuth extends AuthBuilder {
  const RequiresAuth({super.key, required super.builder})
      : super(redirect: loginRedirect, authPredicate: hasAuth);

  static dynamic loginRedirect() => LoginPage();
  static bool hasAuth(User? user) => user != null;
}

class RequiresNoAuth extends AuthBuilder {
  const RequiresNoAuth({super.key, required super.builder})
      : super(redirect: homeRedirect, authPredicate: noAuth);

  static dynamic homeRedirect() => ContentPage();
  static bool noAuth(User? user) => user == null;
}
