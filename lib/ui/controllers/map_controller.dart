import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hefestus/ui/controllers/stream_controller.dart';

class MapController extends StreamController {
  final Rx<double> _latitude = 0.0.obs;
  final Rx<double> _longitude = 0.0.obs;

  double get latitude => _latitude.value;
  double get longitude => _longitude.value;

  static const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10);

  void onData(Position position) {
    _latitude.value = position.latitude;
    _longitude.value = position.longitude;
  }

  Future<bool> handlePermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Location services are disabled, please enable.';
    }

    return switch (await Geolocator.checkPermission()) {
      LocationPermission.deniedForever =>
        throw 'Location permissions are permanently denied, we cannot request permissions.',
      LocationPermission.denied =>
        await Geolocator.requestPermission() == LocationPermission.denied
            ? throw 'Location permissions are denied'
            : true,
      _ => true,
    };
  }

  @override
  Future<void> start() async {
    if (!active) {
      await handlePermissions();

      subscription = Geolocator.getPositionStream(locationSettings: settings)
          .listen(onData);
    }
  }
}
