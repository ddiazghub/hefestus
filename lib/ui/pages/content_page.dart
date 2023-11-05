import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hefestus/ui/widgets/map_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../controllers/auth_controller.dart';
import '../widgets/chat_page.dart';
import '../widgets/user_chat_page.dart';

class ContentPage extends GetView<AuthController> {
  ContentPage({super.key});

  final tabs = TabController();

  static final List<Widget> _widgets = [
    const MapPage(),
    const ChatPage(),
    const UserChatPage()
  ];

  void _logout() async {
    try {
      await controller.logout();
    } catch (e) {
      logError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(title: Text('Welcome ${controller.email}'), actions: [
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                size: 30,
              ),
              onPressed: () {
                _logout();
              },
            ),
          ]),
          body: _widgets[tabs.selected],
          bottomNavigationBar: CurvedNavigationBar(
            items: const [
              Tooltip(
                message: 'Home',
                child: Icon(
                  Icons.home,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              Tooltip(
                message: 'Global Chat',
                child: Icon(
                  Icons.chat,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              Tooltip(
                message: 'Private Chats',
                child: Icon(
                  Icons.accessibility,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ],
            height: 60,
            letIndexChange: (index) => true,
            color: Theme.of(context).colorScheme.primary,
            buttonBackgroundColor: const Color(0xFFF6A641),
            backgroundColor: Colors.transparent.withOpacity(0),
            index: tabs.selected,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 170),
            onTap: (index) => tabs.selected = index,
          ),
        );
      }
    );
  }
}

class TabController extends GetxController {
  final _selected = 0.obs;

  int get selected => _selected.value;
  set selected(int value) => _selected.value = value;
}
