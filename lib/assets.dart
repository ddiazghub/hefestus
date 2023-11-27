import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef MapIcons = ({BitmapDescriptor user, BitmapDescriptor hardware, BitmapDescriptor hardwareGray});

class Assets {
  static const user = 'assets/user_marker.png';
  static const hardware = 'assets/hardware_icon.png';
  static const hardwareGray = 'assets/hardware_icon_gray.png';
  static const fallback = 'assets/fallback.png';
  static const logo = 'assets/logo.png';
  static const logoSmall = 'assets/logo_small.png';
  static const logoWhite = 'assets/logo_white.png';
  static const logoSmallWhite = 'assets/logo_small_white.png';

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
      hardwareGray: await BitmapDescriptor.fromAssetImage(
        imageConfig,
        Assets.hardwareGray,
      ),
    );

    return icons!;
  }
}
