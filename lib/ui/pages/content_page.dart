import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hefestus/ui/widgets/appbar.dart';
import 'package:hefestus/ui/widgets/map_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../widgets/chat_page.dart';
import '../widgets/user_chat_page.dart';

class ContentPage extends GetView<AuthController> {
  const ContentPage({super.key});

  static final List<Widget> _widgets = [const MapPage(), const ChatPage(), const UserChatPage()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ObxValue(
      (tabs) {
        return Scaffold(
          appBar: hefestusAppbar(context),
          body: _widgets[tabs.value],
          bottomNavigationBar: CurvedNavigationBar(
            items: const [
              Tooltip(
                message: 'Maps',
                child: Icon(
                  Icons.map,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              Tooltip(
                message: 'User',
                child: Icon(
                  Icons.cabin,
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
            index: tabs.value,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 170),
            onTap: (index) => tabs.value = index,
          ),
        );
      },
      0.obs,
    );
  }
}
