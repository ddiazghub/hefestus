import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/data/model/point.dart';
import 'package:hefestus/data/repository/place_repository.dart';
import 'package:hefestus/ui/controllers/stream_controller.dart';

class MapController extends StreamController {
  final PlaceRepository repo = Get.find();
  final Rxn<Point> _location = Rxn();
  final RxList<Place> _places = <Place>[].obs;

  Point? get location => _location.value;
  double? get latitude => location?.latitude;
  double? get longitude => location?.longitude;
  List<Place> get places => _places;

  static const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10);

  void onData(Position position) {
    _location.value = Point(position.latitude, position.longitude);
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

  Future<void> search(Point center) async {
    if (places.isEmpty) {
      _places.value = await repo.search(center);
    }
  }

  @override
  Future<void> start() async {
    super.start();
    await handlePermissions();
    subscription = Geolocator.getPositionStream(locationSettings: settings).listen(onData);
  }
}
