import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/widgets/image_viewer.dart';
import 'package:hefestus/ui/widgets/place_view.dart';

class PlacePage extends GetView<AuthController> {
  const PlacePage({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
          appBar: AppBar(title: Text('Welcome ${controller.email}'), actions: [
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                size: 30,
              ),
              onPressed: () => controller.logout(),
            ),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
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
