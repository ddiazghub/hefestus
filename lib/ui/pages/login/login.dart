import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/data/model/user.dart';

import '../../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController auth = Get.find();

  static final defaultUsers = [
    AuthUser('a@a.com', '123456'),
    AuthUser('b@b.com', '123456'),
    AuthUser('c@c.com', '123456'),
  ];

  void signIn() async {
    for (final user in defaultUsers) {
      await auth.signup(user);
      await auth.logout();
    }

    await auth.login(defaultUsers[0].email, defaultUsers[0].password);
  }

  void login(user) {
    auth.login(user, '123456');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => login('a@a.com'),
                child: const Text('Login with a@a.com'),
              ),
              ElevatedButton(
                onPressed: () => login('b@b.com'),
                child: const Text('Login with b@b.com'),
              ),
              ElevatedButton(
                onPressed: () => login('c@c.com'),
                child: const Text('Login with c@c.com'),
              ),
              ElevatedButton(onPressed: signIn, child: const Text('Sign in')),
            ],
          ),
        ),
      ),
    );
  }
}
