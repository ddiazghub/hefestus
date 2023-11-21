import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/pages/chat_page.dart';
import 'package:hefestus/ui/widgets/hefestus_page.dart';

import '../../data/model/user.dart';

class UserChatPage extends GetView<UserController> {
  const UserChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HefestusPage(body: UserList());
  }
}

class UserList extends GetView<UserController> {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    Widget item(AppUser element) {
      return Card(
        margin: const EdgeInsets.all(4.0),
        child: ListTile(
          title: Text(
            element.email,
          ),
          subtitle: Text(element.uid),
          onTap: () => Get.to(ChatPage(receiver: element.uid)),
        ),
      );
    }

    return Obx(() {
      final users = controller.users.values.toList();

      if (users.isEmpty) {
        return const Center(
          child: Text('No users'),
        );
      }

      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => item(users[index]),
      );
    });
  }
}
