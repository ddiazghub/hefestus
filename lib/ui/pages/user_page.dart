import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/data/model/user.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:hefestus/ui/widgets/cached_image.dart';
import 'package:hefestus/ui/widgets/hefestus_page.dart';

class UserPage extends GetView<UserController> {
  const UserPage({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return HefestusPage(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 25.0),
        child: Column(
          children: [
            CachedImage(url: user.image),
            Text('Bienvenido ${user.name}'),
          ],
        ),
      ),
    );
  }
}
