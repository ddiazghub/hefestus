import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/controllers/stream_controller.dart';
import 'package:loggy/loggy.dart';

import '../../data/model/message.dart';

class ChatController extends StreamController<MessageQuerySnapshot> {
  final _messages = <(String, String)?, RxList<Message>>{}.obs;

  RxMap<(String, String)?, RxList<Message>> get messages => _messages;
  RxList<Message> get global => messages[null] ?? <Message>[].obs;

  RxList<Message> where(String user1, String user2) =>
      messages[(user1, user2)] ?? <Message>[].obs;

  List<Message> chatFor(Message message) {
    if (message.receiver == null) {
      messages[null] ??= <Message>[].obs;

      return messages[null]!;
    } else {
      final chat = <Message>[].obs;
      messages[(message.sender, message.receiver!)] ??= chat;
      messages[(message.receiver!, message.sender)] ??= chat;

      return messages[(message.sender, message.receiver)]!;
    }
  }

  void onReceive(MessageQuerySnapshot snapshot) {
    for (final doc in snapshot.docChanges) {
      final message = doc.doc.data!;
      final chat = chatFor(message);
      print('New Message: ${message.text}, type: ${doc.type}');
      print('Sender: ${message.sender}');
      print('Receiver: ${message.receiver}');
      print('Before: $chat');

      bool getByKey(msg) => msg.key == message.key;

      switch (doc.type) {
        case DocumentChangeType.added:
          chat.add(message);
          break;
        case DocumentChangeType.modified:
          final index = chat.indexWhere(getByKey);
          chat[index] = message;
          break;
        case DocumentChangeType.removed:
          chat.removeWhere(getByKey);
      }

      print('After: $chat');
    }
  }

  static int orderByDate(Message a, Message b) =>
      a.createdAt.compareTo(b.createdAt);

  @override
  Future<void> start() async {
    super.start();
    messages.clear();
    subscription = MessageRef.orderByCreatedAt().snapshots().listen(onReceive);
  }

  Future<void> updateMsg(String key, String text) async {
    try {
      await MessageRef.doc(key).update(text: text);
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }

  Future<void> send(String text, String sender, String receiver) async {
    final message = Message(text, sender, receiver: receiver);

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
