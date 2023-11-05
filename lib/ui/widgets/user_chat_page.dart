import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/widgets/chat_page.dart';

import '../../data/model/user.dart';

class UserChatPage extends GetView<UserController> {
  const UserChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ObxValue(
      (rx) {
        return rx.value == null
            ? UserList(rx: rx)
            : ChatPage(receiver: rx.value);
      },
      Rxn<String>(),
    );
  }
}

class UserList extends GetView<UserController> {
  const UserList({super.key, required this.rx});

  final Rxn<String> rx;

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
          onTap: () => rx.value = element.uid,
        ),
      );
    }

    final users = controller.otherUsers.toList();

    if (users.isEmpty) {
      return const Center(
        child: Text('No users'),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => item(users[index]),
    );
  }
}
