import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/widgets/hefestus_page.dart';
import 'package:hefestus/ui/widgets/image_viewer.dart';
import 'package:hefestus/ui/widgets/place_view.dart';

class PlacePage extends GetView<AuthController> {
  const PlacePage({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return HefestusPage(
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
