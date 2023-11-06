import 'package:get/get.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/data/model/point.dart';

abstract class BasePlaceDatasource {
  Future<List<Place>> search(Point center);
}

class PlaceDatasource extends GetConnect implements BasePlaceDatasource {
  PlaceDatasource(this.apiKey);

  static const String url = 'https://places.googleapis.com/v1/places:searchNearby';
  final String apiKey;

  @override
  Future<List<Place>> search(Point center) async {
    final headers = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': PlaceRequest.fields(),
    };

    final body = PlaceRequest(center: center).toJson();
    final response = await httpClient.post(url, body: body, headers: headers);
    final places = PlaceResponse.fromJson(response.body).places;

    print(places);

    return places;
  }
}
