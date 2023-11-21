import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/pages/chat_page.dart';
import 'package:hefestus/ui/widgets/hefestus_page.dart';
import 'package:hefestus/ui/widgets/image_viewer.dart';
import 'package:hefestus/ui/widgets/place_view.dart';

class PlacePage extends GetView<AuthController> {
  const PlacePage({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return HefestusPage(
      floatingActionButton: controller.isUser
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
                textStyle: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onPrimary,
                  fontFamily: 'PlayFair',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Get.to(ChatPage(
                user: controller.id!,
                store: place.id,
              )),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Contact',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          : null,
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: height * 0.5,
            color: Colors.grey,
            child: ImageViewer(place: place),
          ),
          PlaceView(place: place)
        ],
      ),
    );
  }
}
