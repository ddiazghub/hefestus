import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hefestus/ui/widgets/image_viewer.dart';
import 'package:hefestus/ui/widgets/place_view.dart';

class PlacePage extends StatelessWidget {
  const PlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: const Icon(Icons.menu),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: height * 0.4,
            color: Colors.grey,
            child: ExtendedImage.asset(
              'assets/image/pic1.jpg',
              fit: BoxFit.cover,
              loadStateChanged: imageLoadHandler,
            ),
          ),
          const PlaceView()
        ],
      ),
    );
  }
}
