import 'dart:async';

import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/authentication_controller.dart';
import 'package:loggy/loggy.dart';

import '../../data/model/message.dart';

class ChatController extends GetxController {
  final _messages = <Message>[].obs;

  List<Message> get messages => _messages;

  late StreamSubscription<MessageQuerySnapshot> subscription;

  void start() {
    messages.clear();
    subscription = MessageRef.orderByCreatedAt().snapshots().listen((snapshot) {
      _messages.value = [for (final doc in snapshot.docs) doc.data];
    });
  }

  void stop() => subscription.cancel();

  Future<void> updateMsg(Message message) async {
    try {
      await MessageRef.doc(message.key).update(
        text: message.text,
        user: message.user,
      );
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }

  Future<void> send(String text) async {
    final uid = Get.find<AuthController>().uid!;
    final message = Message(text, uid);

    try {
      await MessageRef.add(message);
    } catch (error) {
      logError(error);

      return Future.error(error);
    }
  }

  Future<void> delete(String key) async {
    try {
      await MessageRef.doc(key).delete();
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }
}
