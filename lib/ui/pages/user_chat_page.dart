import 'package:hefestus/data/model/message.dart';
import 'package:hefestus/data/repository/place_repository.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/controllers/chat_controller.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/pages/chat_page.dart';
import 'package:hefestus/ui/widgets/hefestus_page.dart';
import 'package:hefestus/ui/widgets/snapshot_builder.dart';

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
    final AuthController auth = Get.find();
    final ChatController chatController = Get.find();
    final PlaceRepository repo = Get.find();

    Widget userItem(AppUser user) {
      final place = auth.id!;
      final chat = chatController.where(place, user.uid);

      return Card(
        margin: const EdgeInsets.all(4.0),
        color: const Color(0x5500a884),
        child: ListTile(
          title: Text(user.name),
          subtitle: Text(chat.last.text, overflow: TextOverflow.ellipsis),
          onTap: () => Get.to(ChatPage(
            user: user.uid,
            store: place,
          )),
        ),
      );
    }

    Widget storeItem(StoreUserData store) {
      final userId = auth.id!;
      final chat = chatController.where(userId, store.place.id);

      return Card(
        margin: const EdgeInsets.all(4.0),
        color: const Color(0x5500a884),
        child: ListTile(
          title: Text(store.place.displayName),
          subtitle: Text(chat.last.text, overflow: TextOverflow.ellipsis),
          onTap: () => Get.to(ChatPage(
            user: userId,
            store: store.place.id,
          )),
        ),
      );
    }

    return Obx(() {
      if (auth.isUser) {
        var stores = controller.stores.values.toList();

        if (stores.isEmpty) {
          return const Center(
            child: Text('No conversations'),
          );
        }

        final futures = stores.map((e) async {
          return e.withData(await repo.getPlace(e.place));
        });

        return FutureBuilder(
            future: Future.wait(futures),
            builder: (context, snapshot) {
              return SnapshotBuilder(
                  snapshot: snapshot,
                  builder: (context, data) {
                    data = data.where((store) => chatController.where(auth.id!, store.place.id).isNotEmpty).toList();

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => storeItem(data[index]),
                    );
                  });
            });
      } else {
        var users = controller.users.values.toList();

        if (users.isEmpty) {
          return const Center(
            child: Text('No conversations'),
          );
        }

        users = users.where((user) => chatController.where(auth.id!, user.uid).isNotEmpty).toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => userItem(users[index]),
        );
      }
    });
  }
}
