import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:hefestus/ui/widgets/hefestus_page.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';

class ChatPage extends GetView<UserController> {
  const ChatPage({super.key, required this.user, required this.store});

  final String user;
  final String store;

  @override
  Widget build(BuildContext context) {
    return HefestusPage(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 25.0),
        child: Column(children: [
          ChatList(user: user, store: store),
          ChatInput(user: user, store: store),
        ]),
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.user, required this.store});

  final String user;
  final String store;

  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  late ScrollController scroll;
  final ChatController chat = Get.find();

  @override
  void initState() {
    super.initState();
    scroll = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scroll.dispose();
  }

  void scrollToEnd(Duration _) async {
    scroll.animateTo(
      scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    String uid = Get.find<AuthController>().id!;

    return Obx(() {
      WidgetsBinding.instance.addPostFrameCallback(scrollToEnd);
      final messages = chat.where(widget.user, widget.store);

      return Expanded(
        flex: 4,
        child: ListView.builder(
          itemCount: messages.length,
          controller: scroll,
          itemBuilder: (context, index) {
            final element = messages[index];

            return Card(
              margin: const EdgeInsets.all(4.0),
              color:
                  uid == element.sender ? Colors.yellow[200] : Colors.grey[300],
              child: ListTile(
                onTap: () => chat.updateMsg(element.key, element.text),
                onLongPress: () => chat.delete(element.key),
                title: Text(
                  element.text,
                  textAlign:
                      uid == element.sender ? TextAlign.right : TextAlign.left,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class ChatInput extends GetView<ChatController> {
  const ChatInput({super.key, required this.user, required this.store});

  final String user;
  final String store;

  static FormGroup form() => fb.group({
        'input': ['']
      });

  @override
  Widget build(BuildContext context) {
    final bool isUser = Get.find<AuthController>().isUser;

    return ReactiveFormBuilder(
      form: form,
      builder: (context, form, child) {
        void send() {
          final String? value = form.control('input').value;

          if (value != null && value.isNotEmpty) {
            if (isUser) {
              controller.send(value, user, store);
            } else {
              controller.send(value, store, user);
            }

            form.control('input').value = '';
          }
        }

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(left: 5.0, top: 5.0),
                child: ReactiveTextField<String>(
                  key: const Key('MsgTextField'),
                  formControlName: 'input',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your message',
                  ),
                  onSubmitted: (value) => send(),
                ),
              ),
            ),
            TextButton(
              key: const Key('SendButton'),
              onPressed: send,
              child: const Text('Send'),
            )
          ],
        );
      },
    );
  }
}
