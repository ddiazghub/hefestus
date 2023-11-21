import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef MapIcons = ({BitmapDescriptor user, BitmapDescriptor hardware});

class Assets {
  static const user = 'user_marker.png';
  static const hardware = 'hardware_icon.png';
  static const fallback = 'fallback.png';
  static const logo = 'logo.png';
  static const logoSmall = 'logo_small.png';
  static const logoWhite = 'logo_white.png';
  static const logoSmallWhite = 'logo_small_white.png';

  static const imageConfig = ImageConfiguration(size: Size(48, 48));
  static MapIcons? icons;

  static Future<MapIcons> getIcons() async {
    icons ??= (
      user: await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.user,
      ),
      hardware: await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.hardware,
      ),
    );

    return icons!;
  }
}
