import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../data/model/message.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  ChatController chat = Get.find();
  AuthController auth = Get.find();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    chat.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    chat.stop();
    super.dispose();
  }

  Widget _item(Message element, int posicion, String uid) {
    logInfo('Current user? -> ${uid == element.user} msg -> ${element.text}');
    return Card(
      margin: const EdgeInsets.all(4.0),
      color: uid == element.user ? Colors.yellow[200] : Colors.grey[300],
      child: ListTile(
        onTap: () => chat.updateMsg(element),
        onLongPress: () => chat.delete(element.key),
        title: Text(
          element.text,
          textAlign: uid == element.user ? TextAlign.right : TextAlign.left,
        ),
      ),
    );
  }

  Widget _list() {
    logInfo('Current user ${auth.uid}');

    return GetX<ChatController>(builder: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

      return ListView.builder(
        itemCount: chat.messages.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          var element = chat.messages[index];
          return _item(element, index, auth.uid!);
        },
      );
    });
  }

  Future<void> _sendMsg(String text) async {
    //FocusScope.of(context).requestFocus(FocusNode());
    logInfo('Calling _sendMsg with $text');
    await chat.send(text);
  }

  Widget _textInput() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 5.0, top: 5.0),
            child: TextField(
              key: const Key('MsgTextField'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your message',
              ),
              onSubmitted: (value) {
                _sendMsg(_controller.text);
                _controller.clear();
              },
              controller: _controller,
            ),
          ),
        ),
        TextButton(
            key: const Key('sendButton'),
            child: const Text('Send'),
            onPressed: () {
              _sendMsg(_controller.text);
              _controller.clear();
            })
      ],
    );
  }

  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 25.0),
      child: Column(
        children: [Expanded(flex: 4, child: _list()), _textInput()],
      ),
    );
  }
}
