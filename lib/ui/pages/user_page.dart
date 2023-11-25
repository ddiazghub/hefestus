import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/data/model/user.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:hefestus/ui/widgets/cached_image.dart';
import 'package:hefestus/ui/widgets/hefestus_page.dart';
import 'package:intl/intl.dart';

class UserPage extends GetView<UserController> {
  const UserPage({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    String bday = DateFormat('yyyy-MM-dd').format(user.birthday);
    return HefestusPage(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 25.0),
        child: Column(
          children: [
            Container(
                height: height * 0.5,
                color: Colors.grey,
                child: Center(
                  child: CachedImage(url: user.image),
                )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bienvenido ${user.name}',
                      style: theme.textTheme.displaySmall),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(
                      Icons.email,
                      size: 14,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      user.email,
                      maxLines: 4,
                      overflow: TextOverflow.fade,
                      style: theme.textTheme.bodySmall,
                    )
                  ]),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(user.phone ?? 'Unknow phone number'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.cake_outlined,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(bday),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
